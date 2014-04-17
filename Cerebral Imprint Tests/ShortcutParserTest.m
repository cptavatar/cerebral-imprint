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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)basicEmacsStyleTest
{
    NSArray * results = [parser parse:@"C-x Super-M-b cat"];
    XCTAssertEqual(5,[results count]);
    
    
}
- (void)basicAppleShortcuts{
    NSArray * results = [parser parse:@"⌘c"];
    XCTAssertEqual(1,[results count]);
    results = [parser parse:@"⌘c"];
    XCTAssertEqual(1,[results count]);
    results = [parser parse:@"⌃⌥x"];
    XCTAssertEqual(1,[results count]);
}

//- (void) assertKey:(ShortcutElement *)element expectedChar:(
@end
