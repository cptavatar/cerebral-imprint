//
//  PreferencesController.m
//  $Id: PreferencesController.m 17 2009-06-23 18:02:59Z cptavatar $
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
//  This class handles interactions with the Preferences Panel used to set
//  application preferences.
//
#import "PreferencesController.h"

@implementation PreferencesController

- (void) awakeFromNib 
{    
    pref = [Preferences instance];
    [self updateView];
    
    [[NSFontPanel sharedFontPanel] setAccessoryView:fontAccView];
    [[NSFontPanel sharedFontPanel] setDelegate:self]; 
}

- (void) updateView 
{
    [txtMinViewing setIntValue:[pref knownMinViewings]];
    [txtMinWorkSet setIntValue:[pref workingSetSize]];
    [txtPercentCorrect setIntValue:[pref knownMinPercent]];
    [txtRecentWeight setIntValue:[pref knownRecentWeight]];
    [txtWorkingWeight setIntValue:[pref workingSetPreference]];
    [txtMcPause setIntValue:[pref mcPauseDuration]];
}

// delegate for panel - shut down app on window close
- (void) windowWillClose:(NSNotification *)aNotification 
{
    [[NSUserDefaultsController sharedUserDefaultsController] save:self];
    [NSApp stopModal];  
}

// IBAction Handlers ///////////////////////
// reset the preferences 
- (IBAction) resetPreferences:(id)sender
{
    if(NSAlertDefaultReturn == NSRunAlertPanel(@"Reset Preferences", @"Set all preferences to default values?",@"Yes", @"No", nil)){
        [[NSUserDefaultsController sharedUserDefaultsController] revertToInitialValues:sender];
        [self updateView];
    }
}

// open the font window
- (IBAction) openFontWindow:(id)sender
{
    BOOL large = TRUE;
    NSFont * font;
    if(sender == btnChngSmallFont){
        large = FALSE;
        font = [pref smallFont];
    }
    else{
        font = [pref largeFont];
    }
    
    doFontUpdate = FALSE;
    
    NSFontPanel * fontPanel = [NSFontPanel sharedFontPanel];
    [fontPanel setPanelFont:font isMultiple:NO];
    [NSApp runModalForWindow:fontPanel];
    if(doFontUpdate){
        font = [fontPanel panelConvertFont:font];       
        if(large)
            [pref setLargeFont:font];
        else
            [pref setSmallFont:font];
        [self updateView];
        [[NSUserDefaultsController sharedUserDefaultsController] commitEditing];
    }
}

// Handler called by our font accessory view
- (IBAction) closeFontWindow:(id)sender
{
    if(sender == fontAccViewSave) {
        doFontUpdate = TRUE;
    }
    [[NSFontPanel sharedFontPanel] close];
}

- (IBAction) showPreferencePanel:(id) sender 
{
    [NSApp runModalForWindow:prefPanel];
}

// Getters and Setters /////////////////////
- (id) panel
{
    return prefPanel;
}


@end
