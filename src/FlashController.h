//
//  FlashCardController.h
//  $Id: FlashController.h 15 2009-06-22 22:18:38Z cptavatar $
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
#import <Cocoa/Cocoa.h>
#import "CardDeckTest.h"
#import "Preferences.h"

@interface FlashController : NSObject 
{
// References for the user interface elements and the panel itself
    IBOutlet id rightButton;
    IBOutlet id wrongButton;
    IBOutlet id flashPanel;
    
// State information about where we are in the test
    CardDeckTest * currentTest;
    int index;
    BOOL front;

// Convenience reference to the preference singleton
    Preferences * prefs;
}

// Record the results of the current test and move to the next card
// Disables the right/wrong buttons to force the user to flip
- (void) next:(BOOL)rightAnswer;

// quit the test and return back to the main window. Ends modal.
- (void) quit;

// Handler for the back button. Returns to the previous card in the test. 
- (IBAction) back:(id)sender;

// Handler for the quit button. Ends modal 
- (IBAction) quit:(id)sender;

// Handler to record a correct result and move to the next card
- (IBAction) rightNext:(id)sender;

// Handler to record an incorrect result and move to the next card
- (IBAction) wrongNext:(id)sender;

// Handler to show the opposite side of the card than what is current displayed.
// Also, it enables the correct/incorrect buttons so the user can move forward.
- (IBAction) flip:(id)sender;

// Getters and Setters ////////////////////////
- (void) setCurrentTest:(CardDeckTest *) test;

@end
