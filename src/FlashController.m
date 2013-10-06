//
//  FlashCardController.h
//  $Id: FlashController.m 15 2009-06-22 22:18:38Z cptavatar $
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
//  The FlashController mediates interaction with the FlashPanel used for 
//  flash card tests.
//
#import "FlashController.h"

@implementation FlashController

- (void) awakeFromNib
{    
    prefs = [Preferences instance];
}

//button handler for back button
- (IBAction) flip:(id)sender
{
    [currentTest flip];
    [wrongButton setEnabled:YES];
    [rightButton setEnabled:YES];
    [[wrongButton superview] setNeedsDisplay:YES];
    [[rightButton superview] setNeedsDisplay:YES];
}
    
//advance to the next card, record right/wrong
- (void) next:(BOOL)rightAnswer
{
    [wrongButton setEnabled:NO];
    [rightButton setEnabled:NO];
    [currentTest nextCard:rightAnswer];
    front = YES;
}

//button handler for back button
- (IBAction) back:(id)sender
{
    front = YES;
    [currentTest previousCard];
}

//button handler for quit button
- (IBAction) quit:(id)sender
{
    [self quit];
}

//button handler for correct answer
- (IBAction) rightNext:(id)sender
{
    [self next:YES];
}

//button handler for wrong answer
- (IBAction)wrongNext:(id)sender
{
    [self next:NO];
}

//end the test
- (void) quit
{
    [flashPanel close];
}

// Delegate for the panel - stop modal on window close
- (void) windowWillClose:(NSNotification *)aNotification 
{
    [NSApp stopModal];
}

// Getter and Setters ////////////////////////
// Set the current test
- (void) setCurrentTest:(CardDeckTest *)test
{
    currentTest = test ;
    front = YES;
}

@end
