//
//  DeckManager.m
//  $Id: DeckManager.m 17 2009-06-23 18:02:59Z cptavatar $
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
#import "DeckManager.h"

@implementation DeckManager

-init
{
    if (!(self = [super init])) return nil;
    decks = [[NSMutableArray alloc] init];
    return self;
}

- (void) dealloc 
{
    decks = nil;
}

- (CardDeck *) getDeckAtIndex:(int)index
{
    return (CardDeck *) [decks objectAtIndex:index];
}

- (void) appendDeck:(CardDeck *)deck
{
    [decks addObject:deck];
}

- (void) removeDeckAtIndex:(int)index
{
    [decks removeObjectAtIndex:index];
}

- (int) count 
{
    return [decks count];
}

// NSCoding Methods /////////////////////////
-(void) encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:decks forKey:@"decks"]; 
}

-(id) initWithCoder:(NSCoder *)coder
{
    if (!(self = [super init])) return nil;
    decks = [coder decodeObjectForKey:@"decks"];
    return self;
}

// Getters and Setters ////////////////////////
- (void) setDecks:(NSMutableArray*)newDecks 
{
    [decks setArray:newDecks];
}

- (NSMutableArray*) decks 
{
    return decks;
}
@end
