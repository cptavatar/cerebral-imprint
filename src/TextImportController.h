//
//  TextImportController.h
//  $Id: TextImportController.h 15 2009-06-22 22:18:38Z cptavatar $
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
//  This class is used to handle interaction with the TextImportPanel used to
//  import text files and convert them to card decks. 
//
#import <Foundation/Foundation.h>
#import "CardDeck.h"

@interface TextImportController : NSObject 
{
// References to the import panel and its various widgets
    IBOutlet id fileName;
    IBOutlet id deckName;
    IBOutlet id radioCard;
    IBOutlet id radioSide;
    IBOutlet id delimiterSide;
    IBOutlet id delimiterCard;

    IBOutlet id importPanel;

// Reference to the array controller containing our list
// of card decks
    IBOutlet id arrayController;
    
// The name of the file we are importing
    NSString * importFile;
}

// Handler for canceling out of the import 
- (IBAction) cancelButton:(id)sender;

// Handler for proceeding with the import
- (IBAction) importButton:(id)sender;

// Update the UI with the current filename, stripping the path
- (void) updateView;

// Replace escaped strings like \n and \t with their equivilent
- (NSString*) replaceCommonSubstrings:(NSString *)input;

// Build a card deck from a file: 
// file - the name of the file
// deck - the name of the deck to build
// cardDelimiter - the sequence used to separate one card from another
// sideDelimiter - the sequence used to separate one side from another
- (CardDeck *) buildDeckFromFile:(NSString *) file deckName:(NSString *)deck cardDelimiter:(NSString *)cardDelimiter sideDelimiter:(NSString *)sideDelimiter;

// Getters and Setters /////////////////////
- (void) setFile:(NSString *)fileName;
- (id) importPanel;

@end
