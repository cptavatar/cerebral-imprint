//
//  MCController.h
//  $Id: MCController.h 15 2009-06-22 22:18:38Z cptavatar $
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
//  This class handles interactions with the Multiple Choice Panel used to
//  for multiple choice tests.
//
#import <Cocoa/Cocoa.h>
#import "CardDeckTest.h"
#import "Preferences.h"

@interface MCController : NSObject 
{
// References to the panel and its UI widgets
    IBOutlet id nextButton;
    IBOutlet id statusLabel;
    IBOutlet id questionLabel;
    IBOutlet id mcPanel;
    
    IBOutlet id answerText1;
    IBOutlet id answerButton1;
    IBOutlet id answerText2;
    IBOutlet id answerButton2;
    IBOutlet id answerText3;
    IBOutlet id answerButton3;
    IBOutlet id answerText4;
    IBOutlet id answerButton4;
    
// Arrays used to store the array of answer buttons and answer text objects
    NSArray * answerButtons;
    NSArray * answerText;

// The current test we are testing
    CardDeckTest * currentTest;

// Convenience reference to the user preferences
    Preferences * prefs;

// State flag indicating the user has supplied an incorrect answer
    BOOL incorrectAnswer;

// Timer used for delayed displaying of the actual answers
    NSTimer * timer;
}

// Answer hander used by all the answer buttons. The controller figures out 
// out using the sender which one was sent and if it was correct or not. if correct 
// the user is presented with the next question. If incorrect, they are shown the correct answer
- (IBAction) answer:(id)sender;

// Handler used for quiting the test.  
- (IBAction) quit:(id)sender;

// Update the user interface elements - current highlighs the correct answer and 
// the next button if incorrectAnswer is true else it blanks out the answers, hides the next button
// and kicks off the timer to show the actual answers.
- (void) updateView;

// Close the panel, end modal
- (void) quit;

// Callback to make the answers visible. This forces the user to think about the answer instead
// of just picking from a list. 
- (void) updateQuestions: (NSTimer *) theTimer;

// Getters and Setters //////////////////////
- (void) setCurrentTest:(CardDeckTest *)test;

@end
