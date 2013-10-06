//
//  FlashCard.m
//  $Id: FlashCard.m 17 2009-06-23 18:02:59Z cptavatar $
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
//  This class is represents a the base of our model, the flash card. This 
//  class also adheres to NSCoding so its data can be persisted. 
//
#import "FlashCard.h"
#import "Preferences.h"

@implementation FlashCard

- init 
{
    [super init];
    front = @"New Front";
    back = @"New Back";
    total = 0;
    totalRight = 0;
    recentResults = [[NSMutableArray alloc]init]; 
    
    return self;
}

// record the results of viewing the card in a flash card test
- (void) recordResult:(BOOL)right
{
    total ++;
    if(right)
        totalRight ++;
    
    [recentResults insertObject:[NSNumber numberWithBool:right] atIndex:0] ;
    
    if([recentResults count] > RECENT_RESULT_SIZE)
        [recentResults removeLastObject];
}

// use the preferences to calculate if a card is "known" or not
- (BOOL) known  {
    Preferences * instance = [Preferences instance];
  //  NSLog(@"Percentages %d %d", [instance knownMinPercent],[instance knownMinViewings]);
    if([self calculatedPercentage] >= [instance knownMinPercent] && total >= [instance knownMinViewings])
       return YES;
    return NO;
}

// Walk the recent results to figure out the recent results percentage average
- (float) recentPercentage;
{
    if(total == 0)
        return 0;
    
    int tempTotal = 0;
    int recentResultCount = [recentResults count];
    
    for(id loopItem in recentResults){
        if([loopItem boolValue] == YES) tempTotal++;
    }
    return tempTotal* 100.0 / recentResultCount; 
}

// Use the preferences to figure out weighted percentage
- (int) calculatedPercentage
{
    if(total == 0)
        return 0;
    
    Preferences * instance = [Preferences instance];
    float wieghtedRecent = [self recentPercentage] * [instance knownRecentWeight] / 100.0;
    float wieghtedTotal = (totalRight * (100.0 - [instance knownRecentWeight]))/total;
    int retval = wieghtedRecent + wieghtedTotal;
    return retval;
}

// Allow sorting by mastery
- (NSComparisonResult) compareByMastery:(FlashCard *) aCard
{
    int selfPercentage = [self calculatedPercentage];
    int otherPercentage = [aCard calculatedPercentage];
    
    if(selfPercentage == otherPercentage){
        int selfTotal = [self total];
        int otherTotal = [aCard total];
        
        if(selfTotal < otherTotal)
            return NSOrderedDescending;
        if(selfTotal > otherTotal)
            return NSOrderedAscending;
        
        return NSOrderedSame;
    }
    if(selfPercentage < otherPercentage)
        return NSOrderedDescending;
    
    return NSOrderedAscending;
}

// clear test results
- (void) resetCounts 
{
    total = 0;
    totalRight = 0;
    [recentResults removeAllObjects];
}

// Tell the GC what we're done with
- (void) finalize
{
    front = nil;
    back = nil;
    recentResults = nil;
    [super finalize];
}

// NSCoding Methods ////////////////////////////////////

- (void) encodeWithCoder:(NSCoder *)coder
{
    //ToDo - Store everything in a dict with a version 
    //NSDictionary * dict = [NSDictionary alloc]init];
    [coder encodeObject:front forKey:@"front"];
    [coder encodeObject:back forKey:@"back"];
    [coder encodeInt:total forKey:@"total"];
    [coder encodeInt:totalRight forKey:@"totalRight"];
    [coder encodeObject:recentResults forKey:@"results"];
}

- (id) initWithCoder:(NSCoder *)coder
{
    [super init];
    front = [coder decodeObjectForKey:@"front"];
    back = [coder decodeObjectForKey:@"back"];
    total = [coder decodeIntForKey:@"total"] ;
    totalRight = [coder decodeIntForKey:@"totalRight"] ;
    recentResults = [coder decodeObjectForKey:@"results"];

    return self;
}

// Getters and Setters /////////////////////////
- (NSString *) front
{
    return front;
}

- (void) setFront:(NSString *)newFront
{
    front = newFront;
}

- (NSString *) back
{
    return back;
}

- (void) setBack:(NSString *)newBack
{
    back = newBack;
}

- (int) total
{
    return total;
}

- (int) totalRight
{
    return totalRight;
}


@end
