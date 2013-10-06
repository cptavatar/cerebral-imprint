//
//  PreferencesController.h
//  $Id: PreferencesController.h 15 2009-06-22 22:18:38Z cptavatar $
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
#import <Cocoa/Cocoa.h>
#import "Preferences.h"

@interface PreferencesController : NSObject
{
// References to the panel and its widgets
    IBOutlet id btnChngSmallFont;
    IBOutlet id chkDoUpdate;
    IBOutlet id chkEnterAnswersQuestion;
    IBOutlet id fontLarge;
    IBOutlet id fontSmall;
    
    IBOutlet id txtMinViewing;
    IBOutlet id txtMinWorkSet;
    IBOutlet id txtPercentCorrect;
    IBOutlet id txtRecentWeight;
    IBOutlet id txtWorkingWeight;
    IBOutlet id txtMcPause;
    
    IBOutlet id prefPanel;

// References to the accessory view used for 
// modifing fonts and its save button
    IBOutlet id fontAccView;
    IBOutlet id fontAccViewSave;

// Convenience reference to pref object
    Preferences * pref;
    
// status indicator that the fonts have changed
    BOOL doFontUpdate;
}

// Handler for the reset preferences button - asks NSUserDefaults to
// reset preferences
- (IBAction) resetPreferences:(id)sender;

// Handler for the large/small font buttons. Opens a font window with our
// own accessory view attached.
- (IBAction) openFontWindow:(id)sender;

// Handler to close the font window. Using the sender
// and fontAccViewSave figure out if we need to update our font 
- (IBAction) closeFontWindow:(id)sender;

// Handler to show our preference panel
- (IBAction) showPreferencePanel:(id)sender;

// Update the state of the user interface to reflect the model. Currently used
// to set the rounded off integer text fields for most of the sliders
- (void) updateView;

// return a refence to the preference panel
- (id) panel;

@end
