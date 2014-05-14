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

- (void) updateView {
    [statusLabel setStringValue:@""];
}

- (void) windowDidLoad {
    NSLog(@"Loading shortcut controller");
}

- (void) failureCallback:(NSTimer*)timer {
    [statusLabel setStringValue:@""];
    [currentTest nextCard:FALSE];
    waiting = FALSE;
    [self updateShortcuts];
}

- (void) launchFailureTimer {
    waiting = TRUE;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5
                                             target: self
                                           selector: @selector(failureCallback:)
                                           userInfo: nil
                                            repeats: NO];
    
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSModalPanelRunLoopMode];
    
}

- (void) updateShortcuts {
    
    shortcuts = [NSMutableArray arrayWithArray:[parser parse:[currentTest answer]]];
    if(shortcuts == NULL || [shortcuts count] == 0){
        //NSLog([NSString stringWithFormat:@"Error parsing %@",[currentTest answer]]);
        [statusLabel setStringValue:[NSString stringWithFormat:@"Error parsing %@",[currentTest answer]]];
        [self launchFailureTimer];
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
    waiting = FALSE;
    currentTest = test;
    if (test != nil) {
        [self updateView];
    }
    NSEvent* (^handler)(NSEvent*) = ^(NSEvent *theEvent) {
        [self keyDown:theEvent];
        return (NSEvent*)nil;
    };
    [self updateShortcuts];
    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:handler];
}

- (void)keyDown:(NSEvent *)event {
    if(! waiting) {
        ShortcutElement * element = [shortcuts objectAtIndex:0];
        [shortcuts removeObject:element];
        if ([self compare:element event:event]) {
            if([shortcuts count] == 0){
                [currentTest nextCard:TRUE];
                [self updateShortcuts];
            }
        }else {
            [statusLabel setStringValue:[currentTest answer]];
            [self launchFailureTimer];
        }
    }
    
}

- (BOOL) compare:(ShortcutElement*)element event:(NSEvent*)event {
    NSUInteger eventFlags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    NSUInteger desiredFlags = 0;
    
    if ([element isShift]) {
        NSLog(@"isShift");
        desiredFlags = desiredFlags | NSShiftKeyMask;
    }
    if ([element isAlt]) {
        NSLog(@"isAlt");
        desiredFlags = desiredFlags | NSAlternateKeyMask;
    }
    if ([element isCmd]) {
        NSLog(@"isCmd");
        desiredFlags = desiredFlags | NSCommandKeyMask;
    }
    if ([element isCtl]) {
        NSLog(@"isCtl");
        desiredFlags = desiredFlags | NSControlKeyMask;
    }
    if(desiredFlags != eventFlags){
        //NSLog(@"Flags don't match %@ %@ %@",desiredFlags, eventFlags,NSControlKeyMask);
        
        return false;
    }
    
    NSLog([NSString stringWithFormat:@"Event characters: %@",[event charactersIgnoringModifiers]]);
    return([[element character] isEqualToString:[event charactersIgnoringModifiers]]);
}

@end
