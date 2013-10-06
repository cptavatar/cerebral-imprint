//
//  CardDeck.h
//  $Id: CardDeck.h 13 2009-06-16 05:39:02Z cptavatar $
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
//  This simple class represents a deck of of flash cards in our model. This 
//  class also adheres to NSCoding so its data can be persisted. 
//
#import <Foundation/Foundation.h>
#import "FlashCard.h"

@interface CardDeck : NSObject <NSCoding> 
{
    NSMutableArray * deck;
    NSString * name;
}

// Return the flash card at the given index. 
- (FlashCard *) getCardAtIndex:(int)index;

// Return the number of cards in the deck
- (int) count;

// Add a FlashCard to the deck
- (void) appendCard:(FlashCard *) card;

// Remove a FlashCard from the deck
- (void) removeCardAtIndex:(int)index;

// Getter/Setter for the name of the deck
- (void) setName:(NSString *)newName;
- (NSString *) name;

// Replace the deck's cards with the contents of 
// the FlashCards passed in the newCards array
- (void) setCards:(NSMutableArray*) newCards;

// Return a handle to the deck's array of cards
- (NSMutableArray *) cards;

// Clear any previous test results for the cards contained
// within the deck
- (void) resetAllCounts;

@end
