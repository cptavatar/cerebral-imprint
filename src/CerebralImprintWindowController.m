//
//  CerebralImprintWindowController.m
//  $Id: CerebralImprintWindowController.m 20 2009-06-23 21:02:16Z cptavatar $
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
//  This class represents a flash card test
//
#import "CerebralImprintWindowController.h"
#import "TextImportController.h"
#import "Preferences.h"

@implementation CerebralImprintWindowController
-(id) init 
{ 
    self = [super initWithWindowNibName:@"CerebralImprintDocument"];
    return self; 
} 


// return true if only a single deck is selected.
- (BOOL) singleDeckSelected 
{
    int selectedIndex = [arrayController selectionIndex];  
    return ( selectedIndex != NSNotFound && [[arrayController selectedObjects] count] == 1);
}

// IBAction Handlers ////////////////////////////////

// Handler for import text file menu item
- (IBAction) importTextFile:(id)sender
{
    int result;
    NSArray *fileTypes = [NSArray arrayWithObjects:@"txt",@"rtf",@"rtfd",nil];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    
    [oPanel setAllowsMultipleSelection:NO];
    result = [oPanel runModalForDirectory:NSHomeDirectory()
                                     file:nil types:fileTypes];
    if (result == NSOKButton) {
     NSArray *filesToOpen = [oPanel filenames];
     NSString *aFile = [filesToOpen objectAtIndex:0];
     [importController setFile:aFile];
     [NSApp runModalForWindow:importPanel];
     [[self document] saveDocument:self];
    }
}

// Hander for send feedback menu item
- (IBAction) sendFeedback:(id)sender 
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:cerebral.imprint@alexrose.net"]];
}

// Edit button handler
- (IBAction) editButton:(id)sender
{
    if([self singleDeckSelected]) {
            [deckEditorController setCurrentDeck:[[arrayController selectedObjects] objectAtIndex:0]];
        [NSApp runModalForWindow:editorPanel];
        [[self document] saveDocument:self];
        [[NSGarbageCollector defaultCollector] collectIfNeeded];
    }
}

// Delete button handler
- (IBAction) deleteButton:(id)sender
{
    int selectedIndex = [arrayController selectionIndex]; 
    if( selectedIndex != NSNotFound) {
        if(NSAlertDefaultReturn == NSRunAlertPanel(@"Delete Selected Decks", @"Are you sure?",@"Yes", @"No", nil)){
            [arrayController removeObjects:[arrayController selectedObjects]];
            [[self document] saveDocument:self];
            [[NSGarbageCollector defaultCollector] collectIfNeeded];
            
        }
    }
}

// handler for start quiz button
- (IBAction) startTest:(id)sender 
{
    int testMode = [testModeRadio selectedRow];
    int deckMode = [deckModeRadio selectedRow];
    int cardMode = [cardModeRadio selectedRow];
    
    NSMutableArray * selectedDecks = [arrayController selectedObjects];
    
    if([selectedDecks count] == 0) {
        return;
    }
    
    CardDeckTest * cdt; 
    if(deckMode == DECK_LEARN)
        cdt = [[LearningTest alloc]init:cardMode decks:selectedDecks];
    else
        cdt = [[CardDeckTest alloc]init:cardMode deckDirection:deckMode decks:selectedDecks];
    
    
    //NSLog([NSString stringWithFormat:@"Test with %d cards",[cdt count]]);
    
    IBOutlet id controller;
    IBOutlet id panel;
    
    switch(testMode) {
            //flash card test
        case 0:
            controller = fcTestController;
            panel = fcTestPanel;
            break;
            
            //multiple choice test
        case 1:
            controller = mcTestController;
            panel = mcTestPanel;
            if([cdt count] < 4)
            {
                NSRunAlertPanel(@"Sorry...", @"You must have at least 4 cards for a multiple choice test", @"OK", nil,nil);
                return;
            }
            break;
            
            //short answer test 
        case 2:
            controller = fitbTestController;
            panel = fitbTestPanel;
            break;
        
        default:
            return;
    }
    
    [controller setCurrentTest:cdt];
    [self setCurrentTest:cdt];
    [NSApp runModalForWindow:panel];
    [[self document] saveDocument:self];
    
    [controller setCurrentTest:nil];
    [self setCurrentTest:nil];
    [[NSGarbageCollector defaultCollector] collectIfNeeded];
    
}

// Handler for the export decks menu item
- (IBAction) exportDecks:(id)sender
{
    int runResult;
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    NSArray *fileTypes = [NSArray arrayWithObjects:@"txt",@"csv",nil];
    [savePanel setAccessoryView:exportView];
    [savePanel setAllowedFileTypes:fileTypes];
    [savePanel setTitle:@"Export Decks to File"];
    
    runResult = [savePanel runModal];
    
    if(runResult == NSOKButton) {
        NSStringEncoding encoding;
        switch ([exportEncoding indexOfSelectedItem]) {
            case 1:
                encoding = NSUTF16StringEncoding;
                break;
            case 2:
                encoding = NSUTF16LittleEndianStringEncoding;
                break;
            case 3:
                encoding = NSUTF16BigEndianStringEncoding;
                break;
            case 4: 
                encoding = NSMacOSRomanStringEncoding;
                break;
            default:
                encoding = NSUTF8StringEncoding;
        }
        
        [[self document] exportDecks:[savePanel filename] selectedIndexes:[arrayController selectionIndexes] mode:([exportMode indexOfSelectedItem] == 0) encodingType:encoding];
    }
}
// Getters and Setters //////////////////////////

- (NSMutableArray *) decks 
{
    return [[self document] decks];
}

- (CardDeckTest*) currentTest 
{
    return currentTest;
}

- (void) setDecks:(NSMutableArray*) newDecks
{
    [[self document] setDecks:newDecks];
    [[self document] saveDocument:self];
}

- (void) setCurrentTest:(CardDeckTest*)newTest 
{
    [self willChangeValueForKey:@"currentTest"];   
    currentTest = newTest;
    [self didChangeValueForKey:@"currentTest"];
}



@end
