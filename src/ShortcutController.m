//
//  ShortcutController.m
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/9/14.
//
//

#import "ShortcutController.h"

@implementation ShortcutController

- (void) windowDidLoad {
    NSLog(@"Loading shortcut controller");
}

- (void) updateView {
    [statusLabel setStringValue:@"status"];
    [questionLabel setStringValue:@"question"];
}

- (void) quit {
    [scPanel close];
}

// delegate method for panel - end modal on panel close
- (void) windowWillClose:(NSNotification *)aNotification {
    [NSEvent removeMonitor:eventMonitor];
    [NSApp stopModal];
}

//handler for end test button
- (IBAction) quit:(id)sender {
    [self quit];
}

- (void) setCurrentTest:(CardDeckTest *)test {
    currentTest = test;
    if (test != nil) {
        [self updateView];
    }
    NSEvent* (^handler)(NSEvent*) = ^(NSEvent *theEvent) {
        [self keyDown:theEvent];
        return theEvent;
    };
    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:handler];
}

- (void)keyDown:(NSEvent *)event {
    [statusLabel setStringValue:[event characters]];
}

@end
