//
//  LearningTest.h
//  $Id: LearningTest.h 15 2009-06-22 22:18:38Z cptavatar $
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
#import <Foundation/Foundation.h>
#import "CardDeckTest.h"

@interface LearningTest : CardDeckTest 
{
// In learning mode there are 3 piles of cards - 
// * known cards
// * cards we don't know but are working on
// * the rest of the unknown cards
    NSMutableSet * knownSet;
    NSMutableSet * workingSet;
    NSMutableArray * unknownCards;

// The history stores what cards we've seen
// while the pipelines build up lists of what cards to show 
// to ensure that cards are not duplicated as often
    NSMutableArray * history;
    NSMutableArray * workingPipeline;
    NSMutableArray * knownPipeline;

    int nextUnknown;
    
}

// Create a new LearningTest
// - cDirection: which card face to show, one of the CARD_* constants
// - cardDecks: the array of card decks we are testing
- (id) init:(int)cDirection decks:(NSArray*)cardDecks;

// sort the list of cards in testCards (see CardDeckTest) by mastery and
// then break into our three piles based on the settings in prefences. 
// done at initialization
- (void) splitCardsIntoPiles;

// Figure out which card to show based on user preferences and if we
// have any known or working set cards
- (void) chooseCard;

// Add all the items from set to pipeline then shuffle contents
- (void) fillPipeline:(NSSet*)set whichPipeline:(NSMutableArray *)pipeline;

// Getters and Setters ///////
- (NSSet *) workingSet;
- (NSSet *) knownSet;

@end

