//
//  ShortcutParserTest.m
//  Cerebral Imprint
//
//  Created by Alex Rose on 4/16/14.
//
//

#import <XCTest/XCTest.h>
#import "ShortcutParser.h"

@interface ShortcutParserTest : XCTestCase
{
    ShortcutParser * parser;
}

@end

@implementation ShortcutParserTest

- (void)setUp
{
    [super setUp];
    parser = [[ShortcutParser alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBasicEmacsCX {
     NSArray * results = [parser parse:@"C-x"];
    XCTAssertEqual(1,[results count]);
    [self assertKey:[results objectAtIndex:0] expectedChar:@"x" isShift:false isCtrl:true isCmd:false isAlt:false];
    
}

- (void)testBasicEmacsCMX {
    NSArray * results = [parser parse:@"C-M-x"];
    XCTAssertEqual(1,[results count]);
    [self assertKey:[results objectAtIndex:0] expectedChar:@"x" isShift:false isCtrl:true isCmd:false isAlt:true];
}

- (void)testBasicEmacsMXCmd {
    NSArray * results = [parser parse:@"M-x help"];
    XCTAssertEqual(5,[results count]);
    [self assertKey:[results objectAtIndex:0] expectedChar:@"x" isShift:false isCtrl:false isCmd:false isAlt:true];
    [self assertKey:[results objectAtIndex:1] expectedChar:@"h" isShift:false isCtrl:false isCmd:false isAlt:false];
    [self assertKey:[results objectAtIndex:2] expectedChar:@"e" isShift:false isCtrl:false isCmd:false isAlt:false];
    [self assertKey:[results objectAtIndex:3] expectedChar:@"l" isShift:false isCtrl:false isCmd:false isAlt:false];
    [self assertKey:[results objectAtIndex:4] expectedChar:@"p" isShift:false isCtrl:false isCmd:false isAlt:false];
    
}

- (void)testComplicatedEmacsStyle {
    
    
    NSArray * results = [parser parse:@"C-x Super-M-b cat"];
    XCTAssertEqual(5,[results count]);
    [self assertKey:[results objectAtIndex:0] expectedChar:@"x" isShift:false isCtrl:true isCmd:false isAlt:false];
    [self assertKey:[results objectAtIndex:1] expectedChar:@"b" isShift:false isCtrl:false isCmd:true isAlt:true];
    [self assertKey:[results objectAtIndex:2] expectedChar:@"c" isShift:false isCtrl:false isCmd:false isAlt:false];
    [self assertKey:[results objectAtIndex:3] expectedChar:@"a" isShift:false isCtrl:false isCmd:false isAlt:false];
    [self assertKey:[results objectAtIndex:4] expectedChar:@"t" isShift:false isCtrl:false isCmd:false isAlt:false];
    
}
- (void)testBasicAppleShortcutsTest {
    NSArray * results = [parser parse:@"⌘c"];
    XCTAssertEqual(1,[results count]);
    [self assertKey:[results objectAtIndex:0] expectedChar:@"c" isShift:false isCtrl:false isCmd:true isAlt:false];
    results = [parser parse:@"⌘c"];
    XCTAssertEqual(1,[results count]);
    results = [parser parse:@"⌃⌥x"];
    [self assertKey:[results objectAtIndex:0] expectedChar:@"x" isShift:false isCtrl:true isCmd:false isAlt:true];
    XCTAssertEqual(1,[results count]);
}

- (void) assertKey:(ShortcutElement *) element expectedChar:(NSString *)chars isShift:(BOOL)isShift isCtrl:(BOOL)isCtrl isCmd:(BOOL)isCmd isAlt:(BOOL)isAlt {
    XCTAssertEqualObjects(chars, [element character]);
    XCTAssertEqual(isAlt, [element isAlt]);
    XCTAssertEqual(isCmd, [element isCmd]);
    XCTAssertEqual(isCtrl, [element isCtl]);
    XCTAssertEqual(isShift, [element isShift]);
}
@end
