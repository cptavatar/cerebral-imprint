//
//  LearningTest.m
//  $Id: LearningTest.m 17 2009-06-23 18:02:59Z cptavatar $
//
//  Cerebral Imprint
//  http://www.alexrose.net/code/cerebral-imprint/
//
//  Copyright (C) 2004-2009 Alex Rose
//
//  Licensed under the GPL, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.gnu.org/licenses/gpl-2.0.html
//
//  The class extends the basic CardDeckTest to handle the more complicated logic
//  of Learning mode tests
//
#import "LearningTest.h"
#import "Preferences.h"
#import <libc.h>

#define WORKING 1
#define KNOWN 2
//#define ENABLE_LOGGING 

/*
 Learning tests are not that complicated - we split things into 3 piles - known, unknown, and working. What we are
 spliiting up are only indexes that point into the master list of testCards, not object references. There 
 are 3 other collections to mention - a history array that keeps track of what we have seen to allow for "back" operations
 and 2 "pipelines" to try and ensure a more even distribution of cards from each sets while still allowing cards to be shuffled back and forth.
 */
@implementation LearningTest

//create a new test deck based on one or more input decks
- (id) init:(int)cDirection decks:(NSArray*)cardDecks
{
    cardDirection = cDirection;
    testCards = [[NSMutableArray alloc]init];
    history = [[NSMutableArray alloc]init];
    knownPipeline = [[NSMutableArray alloc] init];
    workingPipeline = [[NSMutableArray alloc] init];
    
    knownSet = nil;
    workingSet = nil;
    unknownCards = nil;
    multipleChoiceAnswers = nil;
    
    int cardIndex,deckSize;
    CardDeck* currentDeck;
    for(currentDeck in cardDecks)
    {
        deckSize = [currentDeck count];
        for(cardIndex = 0; cardIndex < deckSize; cardIndex++)
        {
            [testCards addObject:[currentDeck getCardAtIndex:cardIndex]];
        }
    }
    
    
    [self splitCardsIntoPiles];
    [self chooseCard];
    [self calculateSide];
    
    return self;
}

// Split cards into 3 piles, used at initialization
- (void) splitCardsIntoPiles
{
    Preferences * instance = [Preferences instance];
    [testCards sortUsingSelector:@selector(compareByMastery:)];
    

    
    workingSet = [[NSMutableSet alloc]init];
    knownSet = [[NSMutableSet alloc]init];
    unknownCards = [[NSMutableArray alloc]init];
    nextUnknown = 0;
    
    
    while([testCards count] > nextUnknown){
        FlashCard * tempCard = [testCards objectAtIndex:nextUnknown];
        if([tempCard calculatedPercentage] >= [instance knownMinPercent] &&
           [tempCard total] >= [instance knownMinViewings])
            [knownSet addObject:[NSNumber numberWithInt:nextUnknown++]];
        else if([workingSet count] < [instance workingSetSize])
            [workingSet addObject:[NSNumber numberWithInt:nextUnknown++]];
        else
            [unknownCards addObject:[NSNumber numberWithInt:nextUnknown++]];
    }
    
#ifdef ENABLE_LOGGING
    NSLog(@"Prefs: minView %d workingSet %d workingPref %d", [instance knownMinViewings], [instance workingSetSize], [instance workingSetPreference]);
#endif
    
    //QUESTION: do we really want to seed working with 
    // known cards? Maybe if we sort in % learned order first...
    //
    //if([workingSet count] < [instance workingSetSize]){
    //  int intPlaceholder = [testCards count] - [workingSet count] -1;
    //  
    //  while([workingSet count] < [instance workingSetSize] && [knownSet count] > 0){
    //      NSNumber * tempIndex = [NSNumber numberWithInt:intPlaceholder];
    //      [workingSet addObject:tempIndex];
    //      [knownSet removeObject:tempIndex];
    //      intPlaceholder--;
    //  }
    //      
    //}

}


// Select a which card to show next based on the state of the preferences
- (void) chooseCard
{
    Preferences * pref = [Preferences instance];
    NSMutableArray * pipeline = nil;
    
    if([workingSet count] == 0 || 
        ([knownSet count] > 0 && (random() % 100 > [pref workingSetPreference]))){
        pipeline = knownPipeline;
        if([knownPipeline count] == 0)
            [self fillPipeline:knownSet whichPipeline:knownPipeline];
    }
    else {
        pipeline = workingPipeline;
        if([workingPipeline count] == 0)
            [self fillPipeline:workingSet whichPipeline:workingPipeline];
    }
    
    index = [[pipeline lastObject] intValue];
    [pipeline removeLastObject];
    
#ifdef ENABLE_LOGGING
    NSLog(@"Choosing from pipe %d size:%d views:%d percent:%d", pipeline == knownPipeline, [pipeline count], [[testCards objectAtIndex:index]total], [[testCards objectAtIndex:index]calculatedPercentage]);
#endif
}

// fill the pipeline based on the contents of set
- (void) fillPipeline:(NSSet*)set whichPipeline:(NSMutableArray *)pipeline
{   
    if([pipeline count] > 0)
        [pipeline removeAllObjects];
    
    [pipeline addObjectsFromArray:[set allObjects]];
    
    //Shuffle the contents a bit...
    int i;
    for(i = 0; i < [pipeline count]; i++ ){
        [pipeline exchangeObjectAtIndex:i withObjectAtIndex: (random() %[pipeline count])];
    }

#ifdef ENABLE_LOGGING
    NSLog(@" Total:%d sets:%d/%d/%d pipelines:%d/%d",[testCards count],[knownSet count],[workingSet count],[unknownCards count], [knownPipeline count],[workingPipeline count]);
#endif
    
}

// Overloaded Methods from CardDeckTest /////////////////////////////

// move to the previous card
- (void) previousCard
{
    [self willChangeValueForKey:@"status"];
    [self willChangeValueForKey:@"currentText"];
    
    if([history count] > 0)
    {
        NSNumber * tempIndex = [history objectAtIndex:[history count] -1 ];
        [history removeLastObject];

        index = [tempIndex intValue];

        [self calculateSide];
    }

    [self didChangeValueForKey:@"status"];
    [self didChangeValueForKey:@"currentText"];
}

// build a custom status string based on our 3 piles
- (NSString *) status
{
    return [NSString stringWithFormat:@"Working:%d Known:%d Unknown:%d", 
        [workingSet count], [knownSet count], [testCards count] - [workingSet count] -[knownSet count]];
}

//advance to the next card, record user success
//return YES if we wrap.
- (BOOL) nextCard:(BOOL)right
{
    [self willChangeValueForKey:@"status"];
    [self willChangeValueForKey:@"currentText"];
    
    [[testCards objectAtIndex:index] recordResult:right];

    NSNumber * tempIndex = [NSNumber numberWithInt:index];
    [history addObject:tempIndex];
    
    Preferences * instance = [Preferences instance];
    FlashCard * tempCard = [testCards objectAtIndex:index];
    
    
    //for the cases where cards switch sets
    if(right && [workingSet containsObject:tempIndex]){
        if([tempCard calculatedPercentage] >= [instance knownMinPercent] &&
           [tempCard total] >= [instance knownMinViewings]){
            [workingSet removeObject:tempIndex];
            [knownSet addObject:tempIndex];
            //NSLog(@"Moving card to known.");
        }
        
        if([workingSet count] < [instance workingSetSize] && 
            [unknownCards count] > 0){
            
            //NSLog(@"Moving %d from unknown to working", nextUnknown);
            [workingSet addObject:[unknownCards objectAtIndex:0]];
            [unknownCards removeObjectAtIndex:0];
        }

    }
    else if(!right && [knownSet containsObject:tempIndex]){
        if([tempCard calculatedPercentage] < [instance knownMinPercent]){
            [knownSet removeObject:tempIndex];
            [workingSet addObject:tempIndex];
        }
    }
    
    [self chooseCard];  
    [self calculateSide];
    
    [self didChangeValueForKey:@"status"];
    [self didChangeValueForKey:@"currentText"];
    
    //TODO - change method signature, not used anymore
    return NO;
}


// Getters and Setters ///////////////////////
- (NSSet *) workingSet
{
    return workingSet;
}

- (NSSet *) knownSet
{
    return knownSet;
}

@end
