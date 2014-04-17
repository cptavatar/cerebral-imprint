//
//  ShortcutParser.h
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/16/14.
//
//

#import <Foundation/Foundation.h>
#import "ShortcutElement.h"

@interface ShortcutParser : NSObject
- (NSArray *) parse:(NSString *)input;
@end
