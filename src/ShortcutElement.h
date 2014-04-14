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
    NSString * chr;
}

@end
