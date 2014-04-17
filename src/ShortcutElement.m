//
//  ShortcutElement.m
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/13/14.
//
//

#import "ShortcutElement.h"

@implementation ShortcutElement

- (id) init:(NSString *)theChar shift:(BOOL)isShift cmd:(BOOL)isCmd alt:(BOOL)isAlt ctl:(BOOL)isCtl {
    if (!(self = [super init])) return nil;
    character = theChar;
    shft = isShift;
    cmd = isCmd;
    alt = isAlt;
    ctl = isCtl;
    
    return self;
}

- (NSString *) character {
    return character;
}
- (BOOL) isShift {
    return shft;
}
- (BOOL) isCmd {
    return cmd;
}
- (BOOL) isAlt {
    return alt;
}
- (BOOL) isCtl {
    return ctl;
}
@end
