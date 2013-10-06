//
//  CerebralImprintDocument.m
//  $Id: CerebralImprintDocument.m 20 2009-06-23 21:02:16Z cptavatar $
//
//  Cerebral Imprint
//  http://www.alexrose.net/code/cerebral-imprint/
//
//  Copyright (C) 2004-2009 Alex Rose
//
//  Licensed under the GPL, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.gnu.org/licenses/gpl-2.0.html
//
//  This class is the NSDocument subclass for our document based application
//
#import "CerebralImprintDocument.h"
#import "CerebralImprintWindowController.h"
#import <Foundation/Foundation.h>

@implementation CerebralImprintDocument

- (id)init
{
    self = [super init];
    if (self) {
        deckManager =[[DeckManager alloc]init];
    }
    return self;
}

- (void) finalize 
{
    deckManager = nil;
    [super finalize];
}

// Subclass Overrides ////////////////

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
}


- (void)makeWindowControllers 
{ 
    CerebralImprintWindowController *controller = [[CerebralImprintWindowController alloc] init];
    [controller autorelease];
    [self addWindowController:controller]; 
} 

// Persistance Methods //////////////////

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:deckManager];
    
    if ( outError != NULL ) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    
    DeckManager *tempManager =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [deckManager setDecks:[tempManager decks]];
    
    if ( outError != NULL ) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    
    NSArray * docs = [[NSDocumentController sharedDocumentController] documents];

    //If we have a default open document open go ahead and close it.
    if([docs count] == 1) {
        CerebralImprintDocument* doc = [docs objectAtIndex:0];

        if([@"Untitled" compare:[doc displayName]] == NSOrderedSame && [[doc decks] count] ==0)
            [doc close];
    }   
    
    return YES;
}

// Export the contents of the selected decks to a file
-(void) exportDecks:(NSString*)absolutePath selectedIndexes:(NSIndexSet*)indices mode:(BOOL)isCSV encodingType:(NSStringEncoding)encoding
{
    NSLog(@"Exporting to %@", absolutePath);

    [[NSFileManager defaultManager] createFileAtPath:absolutePath contents:nil attributes:nil];
    NSFileHandle * file = [NSFileHandle fileHandleForWritingAtPath:absolutePath];
    NSMutableArray * cards = [[NSMutableArray alloc] init];
    int indexBuffer[[indices count]];
    int bufferSize = [indices getIndexes:&indexBuffer maxCount:[indices count] inIndexRange:nil];
    
    for(int i = 0; i < bufferSize ; i ++) {
        [cards addObjectsFromArray:[[[deckManager decks]objectAtIndex:indexBuffer[i]] cards]];
    }
    
    NSString * temp;
    for (int j = 0; j < [cards count]; j ++) { 
        if(isCSV) {
            NSString * front  = [[[cards objectAtIndex:j] front] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
            NSString * back = [[[cards objectAtIndex:j] back] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
            temp = [NSString stringWithFormat:@"\"%@\",\"%@\"\n", front , back] ;
        }else 
            temp = [NSString stringWithFormat:@"%@\n%@\n", [[cards objectAtIndex:j] front], [[cards objectAtIndex:j] back]];
        [file writeData:[temp dataUsingEncoding:encoding allowLossyConversion:TRUE]];
    }
    
    [file synchronizeFile];
    [file closeFile];
}

// Getters & Setters ///////////////

- (NSMutableArray*) decks 
{
    return [deckManager decks];
}

- (void) setDecks:(NSMutableArray *) newDecks
{   
    [deckManager setDecks:newDecks];
}
@end
