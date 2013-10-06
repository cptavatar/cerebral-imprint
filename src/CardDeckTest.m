//
//  CardDeckTest.m
//  $Id: CardDeckTest.m 15 2009-06-22 22:18:38Z cptavatar $
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
//  This class represents a flash card test.
//
#import "CardDeckTest.h"
#import <libc.h>

@implementation CardDeckTest

//create a new test deck based on one or more input decks
- (id) init:(int)cDirection deckDirection:(int)dDirection decks:(NSArray*)cardDecks
{
    [super init];
    
    int numDecks = [cardDecks count];
    cardDirection = cDirection;
    deckDirection = dDirection;
    testCards = [[NSMutableArray alloc]init];
    
    multipleChoiceAnswers = nil;
    
    int deckIndex, cardIndex,deckSize;
    CardDeck* currentDeck;
    switch(deckDirection)
    {
        case DECK_RANDOM:
        case DECK_FORWARD:
            for(deckIndex = 0; deckIndex < numDecks; deckIndex ++)
            {
                currentDeck = [cardDecks objectAtIndex:deckIndex];
                deckSize = [currentDeck count];
                for(cardIndex = 0; cardIndex < deckSize; cardIndex++)
                {
                    [testCards addObject:[currentDeck getCardAtIndex:cardIndex]];
                }
            }
            
            if(deckDirection == DECK_FORWARD)
                break;
            
            deckSize = [testCards count];
            
            int index1, index2, index3;
            for(cardIndex = 0; cardIndex < deckSize; cardIndex++)
            {
                index1 = random() % deckSize;
                index2 = random() % deckSize;
                index3 = random() % deckSize;
                
                //do a random exchange _and_ exchange the currentcard with a random one.
                [testCards exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
                [testCards exchangeObjectAtIndex:cardIndex withObjectAtIndex:index3];
            }
            break;
            
        case DECK_BACKWARD:
            for(deckIndex = numDecks -1; deckIndex >= 0; deckIndex --)
            {
                currentDeck = [cardDecks objectAtIndex:deckIndex];
                deckSize = [currentDeck count];
                for(cardIndex = deckSize -1; cardIndex >= 0; cardIndex--)
                {
                    [testCards addObject:[currentDeck getCardAtIndex:cardIndex]];
                }
            }            
            break;
            
        case DECK_LEARN:
            break;
            
        default:
            NSLog(@"Invalid deck direction passed into test constructor.");
    }
    [self calculateSide];
    return self;
}

//advance to the next card, record user success
//return YES if we wrap.
- (BOOL) nextCard:(BOOL)right
{
    [self willChangeValueForKey:@"status"];
    [self willChangeValueForKey:@"currentText"];
    
    [[testCards objectAtIndex:index] recordResult:right];
    
    BOOL retval = YES;
    
    if(index < [testCards count] - 1 )
        index++;
    else {
        index = 0;
        retval = NO;
    }
    [self calculateSide];
    
    [self didChangeValueForKey:@"status"];
    [self didChangeValueForKey:@"currentText"];
    
    return retval;
}

// "flip" the card over 
// only makes sense for flash card tests
- (void) flip
{
    [self willChangeValueForKey:@"currentText"];
    showFront = (!showFront);
    [self didChangeValueForKey:@"currentText"];
}

//return the current card text based on 
- (NSString *) currentText
{
    if(showFront)
        return [[testCards objectAtIndex:index] front];
    else
        return [[testCards objectAtIndex:index] back];
}

//back up to the previous card
//ignore if we are already at beginning
- (void) previousCard
{
    [self willChangeValueForKey:@"status"];
    [self willChangeValueForKey:@"currentText"];
    
    if(index > 0)
    {
        index--;
        [self calculateSide];
    }
    else
    {
        index = [testCards count] - 1;
        [self calculateSide];
    }
    
    [self didChangeValueForKey:@"status"];
    [self didChangeValueForKey:@"currentText"];
}

- (NSArray *)  multipleChoiceAnswers
{
    return multipleChoiceAnswers;
}

- (NSString *) status
{
    return [NSString stringWithFormat:@"Card %3d of %3d", index + 1, [testCards count]];
}

//return the current index
- (int) currentIndex
{
    return index;
}

//return how many card are in the test
- (int) count
{
    return [testCards count];
}

//generate an array of 4 randomly ordered 
//multiple choice answers including the 
//correct answer
- (void) generateMultipleChoice
{
    if(multipleChoiceAnswers != nil)
        [multipleChoiceAnswers release];
    
    multipleChoiceAnswers = [[NSMutableArray alloc] init];
    int cardIndex[4], i, j;
    int cardCounter = 1;

    cardIndex[0] = index;
    
    while(cardCounter < 4){
        int tempRandomIndex = random() % [testCards count];
        BOOL unique = YES;
        
        //see if we already have this card
        for(j = 0; j < cardCounter; j++)
            if(cardIndex[j] == tempRandomIndex)
                unique = NO;
                
        if(unique){
            cardIndex[cardCounter] = tempRandomIndex;
            cardCounter++;
        }
    }
    
    //now, randomly swap the actual answer position
    //with another index
    answerIndex = random() % 4;
    if(answerIndex != 0){
        int tempIndex = cardIndex[answerIndex];
        cardIndex[answerIndex] = cardIndex[0];
        cardIndex[0] = tempIndex;
    }
    
    //add results to array and return
    if(showFront){
        for(i =0; i < 4; i++){
            [multipleChoiceAnswers addObject:[[testCards objectAtIndex:cardIndex[i]] back]];
        }
    }else{
        for(i =0; i < 4; i++)
            [multipleChoiceAnswers addObject:[[testCards objectAtIndex:cardIndex[i]] front]];
    }
}

//return the correct answer text
//used in short answer tests
- (NSString*)  answer
{
    if(showFront)
        return [[testCards objectAtIndex:index] back];
    else
        return [[testCards objectAtIndex:index] front]; 
}

//return the correct answer index
//used in multiple choice tests
- (int) answerIndex
{
    return answerIndex;
}

//
- (NSArray*) testCards
{
    return testCards;
}

// Based on the card direction calculate which side should be shown
-(void) calculateSide
{
    int whichSide;
    switch(cardDirection)
    {
        case CARD_FORWARD:
            showFront = YES;
            break;
            
        case CARD_BACKWARD:
            showFront = NO;
            break;
            
        case CARD_RANDOM:
            whichSide = random() % 2;
            if(whichSide)
                showFront = YES;
            else
                showFront = NO;
            break;
            
        default:
            NSLog(@"Unknown card direction!");
    }
}

@end
