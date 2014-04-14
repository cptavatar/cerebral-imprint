//
//  CerebralImprintWindowController.h
//  $Id: CerebralImprintWindowController.h 20 2009-06-23 21:02:16Z cptavatar $
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
//  This class is the main NSWindowController subclass for our NSDocument based application
//
#import <Cocoa/Cocoa.h>
#import "DeckEditorController.h"
#import "CerebralImprintDocument.h"
#import "CardDeckTest.h"
#import "LearningTest.h"

@interface CerebralImprintWindowController : NSWindowController {

// The decks cocoa binding array controller reference
    IBOutlet NSArrayController *arrayController;

// References to the main window and the radio button groupings 
    IBOutlet id mainWindow;
    IBOutlet id testModeRadio;
    IBOutlet id deckModeRadio;
    IBOutlet id cardModeRadio;  

// Reference to the deck editor panel and controller
    IBOutlet DeckEditorController *deckEditorController;
    IBOutlet id editorPanel;

// References to the text import panel and controller
    IBOutlet id importPanel;
    IBOutlet id importController;
    
//  References to the Flash test panel and controller
    IBOutlet id fcTestPanel;
    IBOutlet id fcTestController;

// References to the short answer panel and controller
    IBOutlet id fitbTestPanel;
    IBOutlet id fitbTestController;

// References to the multiple choice panel and controller
    IBOutlet id mcTestPanel;
    IBOutlet id mcTestController;
    
    IBOutlet id ksTestPanel;
    IBOutlet id ksTestController;

// References to the custom export view and its mode chooser     
    IBOutlet id exportView;
	IBOutlet id exportMode;
    IBOutlet id exportEncoding;
	
//  The current test
    CardDeckTest * currentTest;
    
}

// Open up a file chooser dialog and if the user selects a
// file show the import text file panel modally
- (IBAction) importTextFile:(id)sender;

// Open up a new feedback email using the default mail  
- (IBAction) sendFeedback:(id)sender;

// Open up the deck editor panel and show it modally.
- (IBAction) editButton:(id)sender;

// Delete the currently selected deck. Ask the user for confirmation first.
- (IBAction) deleteButton:(id)sender;

// Read in the settings from the 3 test mode radio groupings and based on those
// create a new test object then show the appropriate test panel
- (IBAction) startTest:(id)sender;

// Open up a custom file chooser and write out the content of the
// selected decks based on the user's criteria
- (IBAction) exportDecks:(id)sender;

// Return true if the user has only a single deck selected
- (BOOL) singleDeckSelected;

// Getters and Setters ///////////////////
- (NSMutableArray*) decks;
- (void) setDecks:(NSMutableArray*) newDecks;

- (CardDeckTest*) currentTest;
- (void) setCurrentTest:(CardDeckTest*)newTest;


@end
