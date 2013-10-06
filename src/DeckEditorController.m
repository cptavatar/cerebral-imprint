//
//  DeckEditorController.m
//  $Id: DeckEditorController.m 15 2009-06-22 22:18:38Z cptavatar $
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
#import "DeckEditorController.h"
#import "DeckManager.h"

/*
 * Deck Editor controller handles interaction with the panel
 * used in deck editing.
 * 
 * TODO - See if we can rip out the updateView with a little more cocoa binding magic
 */
@implementation DeckEditorController

- (void) awakeFromNib
{    
    [cards addObserver:self
            forKeyPath:@"selection"
               options: (NSKeyValueObservingOptionNew |
                         NSKeyValueObservingOptionOld)
               context:NULL];

    
}

// Delegate method for the panel - end modal on close
- (void) windowWillClose:(NSNotification *)aNotification 
{
    [NSApp stopModal];
}

// KVO obvserver method
- (void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object 
                        change:(NSDictionary *)change
                       context:(void *)context 
{
       [self updateView];
}

// Update the user interface to reflect the current state of the model
- (void) updateView 
{
    NSArray * selectedObjects = [cards selectedObjects];
    if([selectedObjects count] > 0) {
        FlashCard * card = [selectedObjects objectAtIndex:0];
        
        [recentPercent setStringValue:[NSString stringWithFormat:@"%.0f%%",[card recentPercentage]]];
        [totalPercent setStringValue:[NSString stringWithFormat:@"%d%%",[card calculatedPercentage]]];
        [totalViews setStringValue:[NSString stringWithFormat:@"%d",[card total]]];
        if([card known]) {
            [isKnown setTextColor:[NSColor greenColor]];
            [isKnown setStringValue:@"Yes"];
        }
        else {
            [isKnown setTextColor:[NSColor redColor]];
            [isKnown setStringValue:@"No"];
        }
    }
    else {
        [isKnown setTextColor:[NSColor blackColor]];
        [recentPercent setStringValue:@"N/A"];
        [totalPercent setStringValue:@"N/A"];
        [totalViews setStringValue:@"N/A"];
        [isKnown setStringValue:@"N/A"];
    }
}

// IBAction Handlers //////////////////////////////

// Back button handler
- (IBAction) backButton:(id)sender 
{
    [editorPanel close];
}

// Delete button handler
- (IBAction) deleteButton:(id)sender 
{
    int selectedIndex = [cards selectionIndex]; 
    
    if(selectedIndex != NSNotFound) {
        if(NSAlertDefaultReturn == NSRunAlertPanel(@"Delete card ... ", @"Are you sure?",@"Yes", @"No", nil)) {
            [cards removeObjects:[cards selectedObjects]];
        }
    }
}


// Getters and Setters ////////////////////

// little more complicated than the standard setter due to the KVO...
-(void) setCurrentDeck:(CardDeck *)deck 
{
    [self willChangeValueForKey:@"currentDeck"];
    currentDeck = deck;      
    [self didChangeValueForKey:@"currentDeck"];
    [self updateView];
    
}

- (CardDeck*) currentDeck 
{
    return currentDeck;
}


@end
