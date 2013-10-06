//
//  CerebralImprintDocument.h
//  $Id: CerebralImprintDocument.h 20 2009-06-23 21:02:16Z cptavatar $
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
//  This class is the NSDocument subclass for our document based application
//
#import <Cocoa/Cocoa.h>
#import "DeckManager.h"

@interface CerebralImprintDocument : NSDocument
{
    DeckManager * deckManager;
}

// Write out the content of one or more decks to a file
// absolutePath - the full path where the file will be created
// selectedIndexes - an index set containing the indexs of the decks to export
// mode - a simple toggle as to whether we should export as a CSV file or one side per line
// encodingType - what encoding to use when writing the data (UTF8, etc...)
-(void) exportDecks:(NSString*)absolutePath selectedIndexes:(NSIndexSet*)indices mode:(BOOL)isCSV encodingType:(NSStringEncoding)encoding
;

// Getters and setter for the contents of our document, 
// arrays of CardDecks
- (NSMutableArray*) decks;
- (void) setDecks:(NSMutableArray *) newDecks;

@end
