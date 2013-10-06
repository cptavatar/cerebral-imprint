//
//  SAController.h
//  $Id: SAController.h 15 2009-06-22 22:18:38Z cptavatar $
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
//  This class handles interaction with witht the Short Answer Panel used for
//  performing short answer / fill in the blank tests. 
//
#import <Cocoa/Cocoa.h>
#import "CardDeckTest.h"
#import "Preferences.h"

@interface SAController : NSObject 
{
// References to panel and UI widgets
    IBOutlet id answerButton;
    IBOutlet id answerText;
    IBOutlet id statusLabel;
    IBOutlet id questionLabel;

    IBOutlet id saPanel;

// The current test    
    CardDeckTest * currentTest;

// Convenience reference to preferences
    Preferences * prefs;

// status flag for if the user has entered a wrong answer
    BOOL incorrectAnswer;
}

// Handler to submit an answer to the question
- (IBAction) answer:(id)sender;

// Handler for the end quiz button
- (IBAction) quit:(id)sender;

// If it is an incorrect answer, display the correct answer and a next button
// else hide the next button.
- (void) updateView;

// close the panel, end modal
- (void) quit;

// Getters and Setters ////////////////
- (void) setCurrentTest:(CardDeckTest *)test;

@end
