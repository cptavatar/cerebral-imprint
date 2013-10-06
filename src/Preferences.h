//
//  Preferences.h
//  $Id: Preferences.h 15 2009-06-22 22:18:38Z cptavatar $
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
//  This class is a wrapper around the NSUserDefaults used to store the user preferences. 
//
#import <Foundation/Foundation.h>


@interface Preferences : NSObject 
{
    NSFont * largeFont, * smallFont;
}

// the singleoton instance of the preference object
+ (Preferences *) instance;

// Check for update on start - currently not used.
- (BOOL) checkForUpdateOnStart;
- (void) setCheckForUpdateOnStart:(BOOL)doUpdate;

// Should \n answer questions for short answer test
// usually on, disable for content that has \n s
- (BOOL) enterAnswersQuestion;
- (void) setEnterAnswersQuestion:(BOOL)answerQuestion;

// The minimum number of times the user must see a card before it
// can be considered known
- (int) knownMinViewings;
- (void) setKnownMinViewings:(int)newValue;

// The minimum calculated percent before a card can be considered known
- (int) knownMinPercent;
- (void) setKnownMinPercent:(int)newValue;

// How much should we weigh recent results versus overall results
- (int) knownRecentWeight;
- (void) setKnownRecentWeight:(int)newValue;

// For learning tests, how much should we favor displaying working set cards 
// versus known set cards
- (int) workingSetPreference;
- (void) setWorkingSetPreference:(int) newValue;

// For leaning mode tests, how many cards should we try and keep in the 
// work set
- (int) workingSetSize;
- (void) setWorkingSetSize:(int) newValue;

// The large font - derived from largeFontName & largeFontSize
- (void) setLargeFont:(NSFont*)font;
- (NSFont*) largeFont;

// The small font - derived from smallFontName & smallFontSize
- (void) setSmallFont:(NSFont*)back;
- (NSFont*) smallFont;

// The last file we opened - not used anymore
- (NSString*) lastFile;
- (void) setLastFile:(NSString *)lastFile;

// How long should we wait until showing the user the possible
// multiple choice answers
- (int) mcPauseDuration;
- (void) setMcPauseDuration:(int) seconds;

@end
