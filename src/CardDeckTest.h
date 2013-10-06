//
//  CardDeckTest.h
//  $Id: CardDeckTest.h 17 2009-06-23 18:02:59Z cptavatar $
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
#import <Foundation/Foundation.h>
#import "CardDeck.h"

// constants ////////////////////

#define DECK_FORWARD 0
#define DECK_BACKWARD 1
#define DECK_RANDOM 2
#define DECK_LEARN 3

#define CARD_FORWARD 0
#define CARD_BACKWARD 1
#define CARD_RANDOM 2


@interface CardDeckTest : NSObject 
{
    NSMutableArray * testCards;
    int cardDirection;
    int deckDirection;
    BOOL showFront; 
    int index;
    NSMutableArray * multipleChoiceAnswers;
    int answerIndex;
}

// Create a new card test 
// cDirection - which side of the flash card to test on - use the CARD_* constants
// deckDirection - how to go throught the decks - use the DECK_* constants
// **** learning mode is not supported in this class **** 
// cardDecks - the array of decks
- (id) init:(int)cDirection deckDirection:(int)dDirection decks:(NSArray*)cardDecks;

// Advance to the next card, record user success
// right - did the user answer correctly
// return YES if we wrap the list of decks
- (BOOL) nextCard:(BOOL)right;

// show the other side of the card
- (void) flip;

// the current card text to show
- (NSString *) currentText;

// move to the previous card in the test
- (void) previousCard;

// what card are we on
- (int) currentIndex;

// how many cards in the test
- (int) count;

// return an array of 4 possible answers for current test card, 3 incorrect and
// and 1 correct
- (NSArray *) multipleChoiceAnswers;

// build the array of multiple choice answers
- (void) generateMultipleChoice;

// the answer to the current card
- (NSString*)  answer;

// return the index of the correct answer in the array of possible answers
- (int) answerIndex;

// based on cDirection figure out which side to show
- (void) calculateSide;

// build a display friendly status string that shows where 
// the users is in the test
- (NSString *) status;

// return an array of all the cards in the test
- (NSArray*) testCards;


@end
