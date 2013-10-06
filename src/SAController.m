//
//  SAController.m
//  $Id: SAController.m 17 2009-06-23 18:02:59Z cptavatar $
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
#import "SAController.h"

@implementation SAController

// add to registry on awake
- (void) awakeFromNib 
{    
    prefs = [Preferences instance];
}

// update the view elements
- (void)updateView 
{   
    if(incorrectAnswer){
        [statusLabel setStringValue:@"Wrong"];
        [answerButton setTitle:@"Next"];
        [answerText setString:[currentTest answer]];
        [statusLabel setTextColor:[NSColor redColor]];
    }
    else{
        [answerText setString:@""];
        [statusLabel setStringValue:[currentTest status]];
        [statusLabel setTextColor:[NSColor blackColor]];
        [answerButton setTitle:@"Answer"];
    }
}

//quit the quiz
- (void) quit 
{
    [saPanel close];
}

// delegate for the panel, end modal on close
- (void) windowWillClose:(NSNotification *)aNotification 
{
    [NSApp stopModal];
}

//check to see if the user selected \n...
- (void) textDidChange:(NSNotification *)aNotification 
{
    if([prefs enterAnswersQuestion]) {
        NSString * text = [answerText string];
        int index = [text length] - 1;
        if(index == 0){
            NSString * subtext = [text substringFromIndex:index];
            if([subtext isEqualToString:@"\n"]){
                [answerText setString:@""];
            }
        }
        else if(index > 0){
            NSString * subtext = [text substringFromIndex:index];
            if([subtext isEqualToString:@"\n"]){
                [answerText setString:[text substringToIndex:index]];
                [self answer:nil];
            }
        }
    }
}

// IBAction Handlers ////////////////////////////

// handler for the answer button
- (IBAction) answer:(id)sender {
    
    if(incorrectAnswer){
        incorrectAnswer = NO; 
        [currentTest nextCard:NO];      
    }
    else {
        if([[currentTest answer] isEqualToString:[answerText string]])
        {
            [currentTest nextCard:YES];
        }
        else
            incorrectAnswer = YES;
    }
    
    [self updateView];
}

// handler for the end quiz button
- (IBAction) quit:(id)sender 
{
    [self quit];
}

// Getters and Setters //////////////////////////

//set the current test
- (void) setCurrentTest:(CardDeckTest *)test 
{
    currentTest = test;
    incorrectAnswer = NO;
    if (test != nil ) {
        [self updateView];
    }
}

@end
