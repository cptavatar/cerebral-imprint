//
//  DeckEditorController.h
//  $Id: DeckEditorController.h 15 2009-06-22 22:18:38Z cptavatar $
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
//  This simple class represents a deck of of flash cards in our model. This 
//  class also adheres to NSCoding so its data can be persisted. 
//
#import <Cocoa/Cocoa.h>
#import "CardDeck.h"

@interface DeckEditorController : NSObject 
{
//  References to Deck Editor panel UI elements
    IBOutlet id editorPanel;
    IBOutlet id totalViews;
    IBOutlet id totalPercent;
    IBOutlet id recentPercent;
    IBOutlet id isKnown;

// Reference to the cocoa bindings Array Controller 
// for the cards in this deck
    IBOutlet id cards;

// The deck we are current editing
    CardDeck * currentDeck;
}

// End editing and go back to the main window
- (IBAction) backButton:(id)sender;

// Delete the current card. Prompts the user for validation first.
- (IBAction) deleteButton:(id)sender;

// Update the user interface based on the current state of the panel.
// currently used to just update the card known, views metadata strings
- (void) updateView;

// Getters and Setters /////////
- (void) setCurrentDeck:(CardDeck *)deck;
- (CardDeck *) currentDeck;


@end
