//
//  FlashCard.h
//  $Id: FlashCard.h 15 2009-06-22 22:18:38Z cptavatar $
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
#import <Foundation/Foundation.h>
#define RECENT_RESULT_SIZE 10

@interface FlashCard : NSObject <NSCoding> 
{
    NSString * front;
    NSString * back;
    NSMutableArray * recentResults;
    int total;
    int totalRight;
}

// Record the results of viewing this card in a flash card test.
// As a result the total will be incremented and if right == true
// then the total right will be also incremented. The recent results
// array will also be updated.
- (void) recordResult:(BOOL)right;

// return true if this card is "known" - this involves looking 
// at the preferences and examing the knownMinViewings, knownMinPercent
// settings
- (BOOL) known;

// Method used to compare two flash cards by mastery so that
// a list of cards can be sorted by mastery.
- (NSComparisonResult) compareByMastery:(FlashCard *)aCard;

// Clear all test results
- (void) resetCounts;

// Figure out a calculated percentage based on the weights the
// user has assigned to the recent results in the preferences 
- (int) calculatedPercentage;

// Walk the list of recent results and build up an average percentage
// correct based on its contents.
- (float) recentPercentage;

// Getters and Setters ///////////////////
- (NSString *) front;
- (void) setFront:(NSString *)newFront;

- (NSString *) back;
- (void) setBack:(NSString *)newBack;

- (int) total;
- (int) totalRight;



@end
