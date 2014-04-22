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
    BOOL emacsMode = [self startsWith:input array:EMACS];
    NSMutableArray * shortcuts = [[NSMutableArray alloc] init];
    
    
    return shortcuts;
}

- (NSArray *) parse:(NSString *)input shortcuts:(NSMutableArray*)shortcuts isEmacs:(BOOL)isEmacs  {
    if(input == nil || ([input length] == 0)){
        return shortcuts;
    }
    NSString * previous = input;
    do {
    
    while()
}


- (NSString *) findSpecial:(NSString *)input state:(NSMutableDictionary*)state map:(NSDictionary*)map {
    for(NSString * key in [map allKeys]){
        if([input hasPrefix:key]){
            [state setValue:[NSNumber numberWithBool:true]];
            return [self findSpecial:[input substringFromIndex:[key length]] state:state map:map];
        }
    }
    return input;
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
