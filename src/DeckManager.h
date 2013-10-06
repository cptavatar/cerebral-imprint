//
//  DeckManager.h
//  $Id: DeckManager.h 17 2009-06-23 18:02:59Z cptavatar $
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
//  This class manages an array of card decks in our model. This 
//  class also adheres to NSCoding so its data can be persisted. 
//
#import <Foundation/Foundation.h>
#import "CardDeck.h"

@interface DeckManager :NSObject <NSCoding> 
{
// Our list of Card Decks
    NSMutableArray * decks;
}

// Return the deck at given index
- (CardDeck *) getDeckAtIndex:(int)index;

// Append deck to our list of decks
- (void) appendDeck:(CardDeck *) deck;

// Remove deck at the given index from our list of decks
- (void) removeDeckAtIndex:(int)index;

// Return the number of decks we are managing
- (int) count;

// Getters and Setters /////////
- (NSMutableArray*) decks;
- (void) setDecks:(NSMutableArray*)newDecks;

@end


