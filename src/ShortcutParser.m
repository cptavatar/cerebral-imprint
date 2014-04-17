//
//  ShortcutParser.m
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/16/14.
//
//

#import "ShortcutParser.h"

NSString *const EMACS_CTL = @"C-";
NSString *const EMACS_ALT = @"M-";
NSString *const EMACS_CMD = @"Super-";

NSString *const APPLE_CTL = @"⌃";
NSString *const APPLE_ALT = @"⌥";
NSString *const APPLE_CMD = @"⌘";
NSString *const APPLE_SHIFT = @"⇧";

NSString *const CTL = @"CTL";
NSString *const ALT = @"ALT";
NSString *const CMD = @"CMD";
NSString *const SHIFT = @"SHIFT";

NSDictionary * EMACS;
NSDictionary * APPLE;

@implementation ShortcutParser

- (id) init {
    //lets create a map of 
    EMACS = [[NSDictionary alloc] initWithObjects:[[NSArray alloc]initWithObjects:ALT,CMD,CTL, nil]
        forKeys:[[NSArray alloc]initWithObjects:EMACS_ALT,EMACS_CMD,EMACS_CTL, nil]];
    APPLE = [[NSDictionary alloc] initWithObjects:[[NSArray alloc]initWithObjects:CTL,ALT,CMD,SHIFT, nil]
                                          forKeys:[[NSArray alloc]initWithObjects:APPLE_CTL,APPLE_ALT,APPLE_CMD,APPLE_SHIFT, nil]];
    ;
    return self;
}

- (NSArray *) parse:(NSString*)input {
    if([self startsWith:input array:EMACS]){
        
    }
}

- (NSArray *) parse:(NSString *)input state:(NSMutableDictionary *)keyState mode:(SEL)parseMode {
    
}

- (NSString *) findEmacsSpecial:(NSString *)input state:(NSMutableDictionary*)dict{
    return [self findSpecial:input state:input array:EMACS];
}

- (NSString *) findSpecial:(NSString *)input state:(NSMutableArray*)dict array:(NSArray*)array {
    for(int i = 0; i < )
}
- (BOOL) startsWith:(NSString *)input array:(NSArray *)array {
    for (int i= 0; i<[array count]; i++) {i
        if ([input hasPrefix:[array objectAtIndex:i]]) {
            return true;
        }
    }
    return false;
}
@end
