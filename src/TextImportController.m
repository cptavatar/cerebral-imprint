//
//  TextImportController.m
//  $Id: TextImportController.m 15 2009-06-22 22:18:38Z cptavatar $
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
//  This class is used to handle interaction with the TextImportPanel used to
//  import text files and convert them to card decks. 
//
#import "TextImportController.h"
#import "DeckManager.h"


/*
 * Controller for text import panel
 */
@implementation TextImportController

// Attempt to build a deck from a file
- (CardDeck *) buildDeckFromFile:(NSString *) file deckName:(NSString *)deck cardDelimiter:(NSString *)cardDelimiter sideDelimiter:(NSString *)sideDelimiter
{
    CardDeck * retval = nil;

    NSString *fileContents = nil;

    if ([[file pathExtension] isEqualToString:@"rtfd"]) 
    {
        NSData *rtfData = [NSData dataWithContentsOfFile:file];
        NSAttributedString * rtfString = [[NSAttributedString alloc]initWithRTFD:rtfData documentAttributes:nil];
        fileContents = [rtfString string];
    } 
    else if([[file pathExtension]isEqualToString:@"rtf"]) 
    {
        NSData *rtfData = [NSData dataWithContentsOfFile:file];
        NSAttributedString * rtfString = [[NSAttributedString alloc]initWithRTF:rtfData documentAttributes:nil];
        fileContents = [rtfString string];
    } 
    else 
    {
        fileContents = [NSString stringWithContentsOfFile:file];
    }   

    if(fileContents == nil)
        return nil;

    retval = [[CardDeck alloc] init];
    [retval setName:deck];

    NSArray * cards = [fileContents componentsSeparatedByString:cardDelimiter];

    int i = 0;
    FlashCard * tempCard;
    for(; i < [cards count]; i ++)
    {
        NSString * temp = [cards objectAtIndex:i];
        if([sideDelimiter compare:cardDelimiter] != NSOrderedSame) {
            NSArray * sides = [temp componentsSeparatedByString:sideDelimiter];
            tempCard = [[FlashCard alloc] init];
            [retval appendCard:tempCard];
            [tempCard setFront:[sides objectAtIndex:0]];
            if([sides count] > 1) 
                [tempCard setBack:[sides objectAtIndex:1]];

        }
        else {
            if(i%2 == 0)
            {
                tempCard = [[FlashCard alloc] init];
                [retval appendCard:tempCard];
                [tempCard setFront:temp];
            }
            else
            {
                [tempCard setBack:temp];
            }
        }

    }


    return retval;
}

// replace end of line and tabs
- (NSString*) replaceCommonSubstrings:(NSString *)input
{
    NSString* temp = [input stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return [temp stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
}

// update the view with the filename
- (void) updateView 
{
    NSArray * tokens = [importFile componentsSeparatedByString:@"/"];
    NSString * fileNameMinusPath = [NSString stringWithString:[tokens lastObject]];
    [fileName setStringValue:fileNameMinusPath];
    NSRange  range = [fileNameMinusPath rangeOfString:@"." options:NSBackwardsSearch];
    if(range.location != NSNotFound)
        [deckName setStringValue:[fileNameMinusPath substringToIndex:range.location]];
    else
        [deckName setStringValue:fileNameMinusPath];
}

// delegate - shut down app on window close
- (void) windowWillClose:(NSNotification *)aNotification 
{
    [NSApp stopModal];
}

// IBAction Handlers ///////////////////////////////

//handler for cancel button
- (IBAction) cancelButton:(id)sender
{
    [importPanel close];
}

// handler for import button
- (IBAction) importButton:(id)sender 
{
    NSString * name = nil;
    NSString * sideDel = nil;
    NSString * cardDel = nil;
    
    name = [deckName stringValue];
    if(name == nil || [name length] < 1){
        NSRunAlertPanel(@"Sorry...", @"You must choose a deck name.", @"OK", nil,nil);
        return;
    }
    
    switch([radioCard selectedRow]) {
        case 0:
            cardDel = @"\n";
            break;
        case 1:
            cardDel = @"\t";
            break;
        default:
            cardDel = [delimiterCard stringValue];
    }

    switch([radioSide selectedRow]) {
        case 0:
            sideDel = @"\n";
            break;
        case 1:
            sideDel = @"\t";
            break;
        default:
            sideDel = [delimiterSide stringValue];
    }
        
    cardDel = [self replaceCommonSubstrings:cardDel];
    sideDel = [self replaceCommonSubstrings:sideDel];

    if(cardDel == nil || [cardDel length] < 1 || sideDel == nil || [sideDel length] < 1)
        NSRunAlertPanel(@"Sorry...", @"You must enter the characters that separate the card sides.", @"OK", nil,nil);
    else{
        CardDeck * newDeck = [self buildDeckFromFile:importFile deckName:name cardDelimiter:cardDel sideDelimiter:sideDel];
        if(newDeck != nil)
            [arrayController addObject:newDeck];
        
        [importPanel close];
    }
        
    
}

// Getters and Setters ////////////////////////////
// set the file name
- (void) setFile:(NSString *)newFileName 
{   
    [fileName setStringValue:@""];
    importFile = [NSString stringWithString:newFileName];
    [self updateView];
}

//return a handle to the import panel
- (id)importPanel 
{
    return importPanel;
}

@end
