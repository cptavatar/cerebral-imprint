//
//  MCController.m
//  $Id: MCController.m 17 2009-06-23 18:02:59Z cptavatar $
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
#import "MCController.h"

#import <unistd.h>

/*
 * Controller for multiple choice test panel
 */
@implementation MCController

- (void) awakeFromNib 
{    
    answerButtons = [NSArray arrayWithObjects:answerButton1, answerButton2, answerButton3, answerButton4,nil];
    answerText = [NSArray arrayWithObjects:answerText1, answerText2, answerText3, answerText4, nil];
    prefs = [Preferences instance];
    timer = nil;
}

// update the view based on the incorrectAnswer flag
- (void) updateView 
{

    int i;
    if(incorrectAnswer){
        [statusLabel setStringValue:@"Wrong"];
        [nextButton setTransparent:NO];
        [nextButton setEnabled:YES];
        [statusLabel setTextColor:[NSColor redColor]];
        int correctIndex = [currentTest answerIndex];
    
        for(i = 0; i< 4; i++){
            if(i == correctIndex){
                [[answerText objectAtIndex:i] setTextColor:[NSColor redColor]];
                
            }
            [[answerButtons objectAtIndex:i] setEnabled:NO];
        }
    }
    else{
        NSArray * answers = [currentTest multipleChoiceAnswers];
        [statusLabel setStringValue:[currentTest status]];
        [statusLabel setTextColor:[NSColor blackColor]];
        [nextButton setTransparent:YES];
        [nextButton setEnabled:NO];
    
        for(i = 0; i< [answers count]; i++){
            [[answerText objectAtIndex:i] setStringValue:@" "];
            [[answerButtons objectAtIndex:i] setEnabled:NO];
        }
        
        if(time != nil)
            [timer invalidate];
        
        //Set a timer to kick off a callback to populate the answers for multiple choice
        //This way the user can think about what the answer should be before being presented
        //the list of possibilities.
        timer = [NSTimer scheduledTimerWithTimeInterval: [prefs mcPauseDuration]
                                                 target: self
                                               selector: @selector(updateQuestions:)
                                               userInfo: nil
                                                repeats: NO];
        
        [[NSRunLoop currentRunLoop] addTimer:timer
                                     forMode:NSModalPanelRunLoopMode];

    }
}

// timer callback
- (void) updateQuestions: (NSTimer *)theTimer 
{
    int i;
    NSArray * answers = [currentTest multipleChoiceAnswers];
    
    for(i = 0; i< [answers count]; i++){
        [[answerText objectAtIndex:i] setStringValue:[answers objectAtIndex:i]];
        [[answerButtons objectAtIndex:i] setEnabled:YES];
        [[answerText objectAtIndex:i] setTextColor:[NSColor blackColor]];
    }
    [NSApp updateWindows];
} 

//end the quiz
- (void) quit 
{
    [mcPanel close];
}

// delegate method for panel - end modal on panel close
- (void) windowWillClose:(NSNotification *)aNotification 
{
    [NSApp stopModal];
}

// IBAction Handlers //////////////////////////////

// handler for answer buttons
- (IBAction) answer:(id)sender 
{   
    if(incorrectAnswer){
        incorrectAnswer = NO;
        [currentTest nextCard:NO];
        [currentTest generateMultipleChoice];
            
    }
    else {
        if([sender isEqual:[answerButtons objectAtIndex:[currentTest answerIndex]]]){
            [currentTest nextCard:YES];
            [currentTest generateMultipleChoice];
        }
        else
            incorrectAnswer = YES;
    }
    
    [self updateView];
      
}

//handler for end test button
- (IBAction) quit:(id)sender 
{
    [self quit];
}

// Getters and Setters ////////////////////////////

//set the deck test
- (void) setCurrentTest:(CardDeckTest *)test 
{
    currentTest = test;
    incorrectAnswer = NO;
    if (test != nil) {
        [currentTest generateMultipleChoice];
        [self updateView];
    }
}

@end
