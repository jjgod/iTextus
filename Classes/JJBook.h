//
//  JJBook.h
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJPage.h"

@interface JJBook : NSObject {
    NSString *path;
    NSString *title;
    NSString *author;
    CFAttributedStringRef contents;
    NSMutableArray *pages;
    NSUInteger lastReadPage;
    NSUInteger estimatedPages;
    NSUInteger totalCharacters;
    CTLineRef titleLine;
}

- (id) initWithPath: (NSString *) thePath;
- (NSString *) description;
- (JJPage *) loadPage: (NSUInteger) pageNum
       withAttributes: (NSDictionary *) attributes
                frame: (CGRect) frame;
- (NSUInteger) lastReadPageForPath: (NSString *) thePath;
- (NSUInteger) lastReadPage;
- (void) setLastReadPage: (NSUInteger) num;
- (void) releaseAllPages;

@property (retain) NSString *path, *title, *author;
@property (retain) NSMutableArray *pages;
@property (readonly) NSUInteger estimatedPages;
@property (readonly) CTLineRef titleLine;

@end
