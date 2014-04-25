//
//  ShortcutController.m
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/9/14.
//
//

#import "ShortcutController.h"

@implementation ShortcutController
- (void) awakeFromNib {
 parser = [[ShortcutParser alloc]init];
}

- (void) windowDidLoad {
    
    NSLog(@"Loading shortcut controller");
}

- (void) updateView {
    [statusLabel setStringValue:@""];
    //[questionLabel setStringValue:@"question"];
    
}

- (void) updateShortcuts {
    
    shortcuts = [NSMutableArray arrayWithArray:[parser parse:[currentTest answer]]];
    if(shortcuts == NULL || [shortcuts count] == 0){
        NSLog([NSString stringWithFormat:@"Error parsing %@",[currentTest answer]]);
        [statusLabel setStringValue:[NSString stringWithFormat:@"Error parsing %@",[currentTest answer]]];
        [NSThread sleepForTimeInterval:5.0f];
        [statusLabel setStringValue:@""];
        [currentTest nextCard:FALSE];
        [self updateShortcuts];
    }
        
    
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
    [self updateShortcuts];
    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:handler];
}

- (void)keyDown:(NSEvent *)event {
    //event characters]
    //[statusLabel setStringValue:@""];
    ShortcutElement * element = [shortcuts objectAtIndex:0];
    [shortcuts removeObject:element];
    if ([self compare:element event:event]) {
        if([shortcuts count] == 0){
            [currentTest nextCard:TRUE];
            [self updateShortcuts];
        }
    }else {
        [statusLabel setStringValue:[currentTest answer]];
        [NSThread sleepForTimeInterval:5.0f];
        [statusLabel setStringValue:@""];
        [currentTest nextCard:FALSE];
        [self updateShortcuts];
    }
    
}

- (BOOL) compare:(ShortcutElement*)element event:(NSEvent*)event {
    
    return([[element character] isEqualToString:[event characters]]);
}

@end
