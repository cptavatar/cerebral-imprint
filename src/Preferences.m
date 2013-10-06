//
//  Preferences.m
//  $Id: Preferences.m 15 2009-06-22 22:18:38Z cptavatar $
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
#import "Preferences.h"
#import "PreferencesKeys.h"

@implementation Preferences

static Preferences * singleton = nil;

+ (Preferences *) instance
{
    @synchronized(self) {
        if(singleton == nil) {
            singleton = [[Preferences alloc]init];
        }
    }
    return singleton;
}

- init 
{
    smallFont = nil;
    largeFont = nil;
    NSString *userDefaultsValuesPath;
    NSMutableDictionary *userDefaultsValuesDict;
    
    // load the default values for the user defaults
    userDefaultsValuesPath=[[NSBundle mainBundle] pathForResource:@"UserDefaults"
                                                           ofType:@"plist"];
    userDefaultsValuesDict=[NSMutableDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    [userDefaultsValuesDict setValue:[[NSFont systemFontOfSize:[NSFont systemFontSize]] fontName] forKey:SMALL_FONT_NAME];
    [userDefaultsValuesDict setValue:[[NSFont systemFontOfSize:[NSFont systemFontSize]] fontName] forKey:LARGE_FONT_NAME];
    [userDefaultsValuesDict setObject:[NSNumber numberWithFloat:[NSFont systemFontSize]] forKey:SMALL_FONT_SIZE];
    [userDefaultsValuesDict setObject:[NSNumber numberWithFloat:([NSFont systemFontSize] + 5)] forKey:LARGE_FONT_SIZE];
    [userDefaultsValuesDict setValue:nil forKey:LAST_OPENED_FILE];
    
    // set them in the standard user defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithDictionary:userDefaultsValuesDict]];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:userDefaultsValuesDict];
    return self;
}

/*
 * Should we check for updates on application start
 */
- (BOOL) checkForUpdateOnStart
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:UPDATE_CHECK];
}

- (void) setCheckForUpdateOnStart:(BOOL)answerQuestion
{
    [[NSUserDefaults standardUserDefaults] setBool:answerQuestion forKey:UPDATE_CHECK];
}

/*
 * Should pressing return answer the question for the short answer test
 */
- (BOOL) enterAnswersQuestion
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ENTER_ANSWERS_QUESTION];
}
- (void) setEnterAnswersQuestion:(BOOL)doUpdate
{
    [[NSUserDefaults standardUserDefaults] setBool:doUpdate forKey:ENTER_ANSWERS_QUESTION];
}

/*
 * How many times do we need to see a card before we 
 * can consider it known?
 */
- (int) knownMinViewings
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:KNOWN_MIN_VIEWINGS];
}
- (void) setKnownMinViewings:(int)newValue
{
    [[NSUserDefaults standardUserDefaults] setInteger:newValue forKey:KNOWN_MIN_VIEWINGS];
}

/*
 * What is the minimum accuracy before we consider a card known?
 */
- (int) knownMinPercent
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:KNOWN_MIN_PERCENT];
}
- (void) setKnownMinPercent:(int)newValue
{
    [[NSUserDefaults standardUserDefaults] setInteger:newValue forKey:KNOWN_MIN_PERCENT];
}

/*
 * When calculating the accuracy on a given card, how 
 * much should we weigh the most recent results versus
 * the overall results?
 */
- (int) knownRecentWeight
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:KNOWN_RECENT_WEIGHT];
}
- (void) setKnownRecentWeight:(int)newValue
{
    [[NSUserDefaults standardUserDefaults] setInteger:newValue forKey:KNOWN_RECENT_WEIGHT];
}

/*
 * When in learning mode, how much should we lean towards
 * choosing a card from the working set versus the known cards?
 */
- (int) workingSetPreference
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:WORKING_SET_PREF];
}

- (void) setWorkingSetPreference:(int) newValue
{
    [[NSUserDefaults standardUserDefaults] setInteger:newValue forKey:WORKING_SET_PREF];
}

/*
 * How many cards should we try to keep in our working set?
 */
- (int) workingSetSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:WORKING_SET_SIZE];
}

- (void) setWorkingSetSize:(int) newValue
{
    [[NSUserDefaults standardUserDefaults] setInteger:newValue forKey:WORKING_SET_SIZE];
}

/*
 * Which font should we use for flash card tests and for the 
 * question in MC/SA tests?
 */
- (void) setLargeFont:(NSFont*)font
{
    //[udController setObject:font forKey:@"largeFont"];
    [[NSUserDefaults standardUserDefaults] setObject:[font fontName] forKey:LARGE_FONT_NAME];
    [[NSUserDefaults standardUserDefaults] setFloat:[font pointSize]  forKey:LARGE_FONT_SIZE];
}

- (NSFont*) largeFont
{
    return [NSFont fontWithName:[[NSUserDefaults standardUserDefaults] stringForKey:LARGE_FONT_NAME] 
                           size:[[NSUserDefaults standardUserDefaults] floatForKey:LARGE_FONT_SIZE]];   
}

/*
 * Which font should we use for the answer in MC tests?
 */
- (void) setSmallFont:(NSFont*)back
{
    [[NSUserDefaults standardUserDefaults] setObject:[back fontName] forKey:SMALL_FONT_NAME];
    [[NSUserDefaults standardUserDefaults] setFloat:[back pointSize]  forKey:SMALL_FONT_SIZE];
}

- (NSFont*)smallFont
{
    return [NSFont fontWithName:[[NSUserDefaults standardUserDefaults] stringForKey:SMALL_FONT_NAME] 
                           size:[[NSUserDefaults standardUserDefaults] floatForKey:SMALL_FONT_SIZE]];
}

/*
 * What was the last file we tested?
 */
- (NSString*) lastFile 
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:LAST_OPENED_FILE];
}

- (void) setLastFile:(NSString *)lastFile 
{
    [[NSUserDefaults standardUserDefaults] setObject:lastFile forKey:LAST_OPENED_FILE];
}

/*
 * How long should we pause before presenting the user with
 * possible answers for the MC test?
 */
- (int) mcPauseDuration 
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:MC_PAUSE];
}

- (void) setMcPauseDuration:(int) seconds 
{
    [[NSUserDefaults standardUserDefaults] setInteger:seconds forKey:MC_PAUSE];
}

@end
