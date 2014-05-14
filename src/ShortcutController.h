//
//  ShortcutController.h
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/9/14.
//
//

#import <Foundation/Foundation.h>
#import "CardDeckTest.h"
#import "ShortcutParser.h"

@interface ShortcutController : NSObject
{
    IBOutlet id statusLabel;
    IBOutlet id questionLabel;
    IBOutlet id scPanel;
    id eventMonitor;
    
    // The current test we are testing
    CardDeckTest * currentTest;
    ShortcutParser * parser;
    NSMutableArray* shortcuts;
    NSTimer * timer;
    BOOL waiting;
}

- (void) updateView;
- (void) quit;
- (void) setCurrentTest:(CardDeckTest *)test;

@end
