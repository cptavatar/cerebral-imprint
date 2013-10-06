//
//  CardDeck.m
//  $Id: CardDeck.m 17 2009-06-23 18:02:59Z cptavatar $
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
#import "CardDeck.h"

@implementation CardDeck

- init
{
    [super init];
    name = @"New Deck";
    deck = [[NSMutableArray alloc] init];
    return self;
}

// NSCoder Functionality ///////////////

- (void) encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:deck forKey:@"deck"];
    [coder encodeObject:name forKey:@"name"];
}

- (id) initWithCoder:(NSCoder *)coder
{
    [super init];
   
    deck = [coder decodeObjectForKey:@"deck"];
    name = [coder decodeObjectForKey:@"name"];
    
    return self;
}

// Implementation ///////////////////////////

- (FlashCard *) getCardAtIndex:(int)index
{
    return (FlashCard *) [deck objectAtIndex:index];
}

- (void) appendCard:(FlashCard *) card
{
    [deck addObject:card];
}

- (int) count
{
    return [deck count];
}

- (void) removeCardAtIndex:(int)index
{
    [deck removeObjectAtIndex:index];
}

- (void) resetAllCounts 
{
    [deck makeObjectsPerformSelector:@selector(resetCounts)];
}

// tell the GC we're done 
- (void)finalize 
{
	name = nil;
	deck = nil;
	[super finalize];
}	

// Getters & Setters ///////////////

- (void) setName:(NSString *) newName
{
    name = newName;
}

- (NSString *) name
{
    return name;
}

- (void) setCards:(NSMutableArray*) newCards 
{
    deck = newCards;
}

- (NSMutableArray *) cards
{
    return deck;
}



@end
