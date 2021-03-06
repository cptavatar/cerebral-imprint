//
//  ShortcutElement.h
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/13/14.
//
//

#import <Foundation/Foundation.h>

@interface ShortcutElement : NSObject
{
    BOOL shft;
    BOOL cmd;
    BOOL alt;
    BOOL ctl;
    NSString * character;
}

- (id) init:(NSString *)theChar shift:(BOOL)isShift cmd:(BOOL)isCmd alt:(BOOL)isAlt ctl:(BOOL)isCtl;
- (NSString *) character;
- (BOOL) isShift;
- (BOOL) isCmd;
- (BOOL) isAlt;
- (BOOL) isCtl;
@end
