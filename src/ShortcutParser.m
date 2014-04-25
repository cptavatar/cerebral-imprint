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
    return self;
}

- (NSArray *) parse:(NSString*)input {
    BOOL emacsMode = [self startsWith:input array:[EMACS allKeys]];
    NSMutableArray * shortcuts = [[NSMutableArray alloc] init];
    
    return [self parse:input shortcuts:shortcuts  isEmacs:emacsMode];
}

- (NSArray *) parse:(NSString *)input shortcuts:(NSMutableArray*)shortcuts isEmacs:(BOOL)isEmacs  {
    if(input == nil || ([input length] == 0)){
        return shortcuts;
    }
    
    NSMutableSet* modifiers = [[NSMutableSet alloc]init];
    NSString * postModifers = [self findSpecial:input state:modifiers map:(isEmacs ? EMACS : APPLE)];
    
    if ([postModifers length] > 0){
        NSString * key = [postModifers substringToIndex:1];
        if(! isEmacs){
            key = [key lowercaseString];
        }
        if(! [key isEqualToString:@" "]){
            [shortcuts addObject:[self createShortcut:key state:modifiers]];
        }
    }
    
    if ([postModifers length] > 1){
        return [self parse:[postModifers substringFromIndex:1] shortcuts:shortcuts isEmacs:isEmacs];
    } else {
        return shortcuts;
    }
    
}


- (NSString *) findSpecial:(NSString *)input state:(NSMutableSet*)state map:(NSDictionary*)map {
    for(NSString * key in [map allKeys]){
        if([input hasPrefix:key]){
            [state addObject:[map objectForKey:key]];
            return [self findSpecial:[input substringFromIndex:[key length]] state:state map:map];
        }
    }
    return input;
}

- (ShortcutElement*) createShortcut:(NSString*)input state:(NSMutableSet*)state {
    return [[ShortcutElement alloc]init:input
            shift:[state containsObject:SHIFT]
            cmd:[state containsObject:CMD]
            alt:[state containsObject:ALT]
            ctl:[state containsObject:CTL]];
}

- (BOOL) startsWith:(NSString *)input array:(NSArray *)array {
    for (int i= 0; i<[array count]; i++) {
        if ([input hasPrefix:[array objectAtIndex:i]]) {
            return true;
        }
    }
    return false;
}
@end
