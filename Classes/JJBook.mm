//
//  JJBook.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <vector>
#import "JJBook.h"
#import "JJLine.h"
#import <chardetect.h>
#include <sys/xattr.h>

#define kLastReadPages @"lastReadPages"

@interface NSString (DetectEncoding)
- (NSStringEncoding) detectedEncodingAtPath;
@end

@implementation NSString (DetectEncoding)

#define BUFSIZE 4096

- (NSStringEncoding) detectedEncodingAtPath
{
    chardet_t chardetContext;
    FILE     *fp;
    char      buf[BUFSIZE], charset[CHARDET_MAX_ENCODING_NAME];
    int       ret, len;

    CFStringEncoding cfenc;
    CFStringRef      charsetStr;

    chardet_create(&chardetContext);

    chardet_reset(chardetContext);
    fp = fopen([self fileSystemRepresentation], "r");
    if (! fp)
		return NSUTF8StringEncoding;

    do
    {
        len = fread(buf, 1, sizeof(buf), fp);
        ret = chardet_handle_data(chardetContext, buf, len);
    } while (ret == CHARDET_RESULT_OK && (feof(fp) == 0));

    fclose(fp);
    chardet_data_end(chardetContext);

    ret = chardet_get_charset(chardetContext, charset, CHARDET_MAX_ENCODING_NAME);
    if (ret != CHARDET_RESULT_OK)
        return NSUTF8StringEncoding;

    // NSLog(@"charset: %s\n", charset);
    charsetStr = CFStringCreateWithCString(NULL, charset, kCFStringEncodingUTF8);
    cfenc = CFStringConvertIANACharSetNameToEncoding(charsetStr);
    CFRelease(charsetStr);

    chardet_destroy(chardetContext);

    return CFStringConvertEncodingToNSStringEncoding(cfenc);
}

@end

@implementation JJBook

@synthesize path, title, author, pages, estimatedPages;

- (id) initWithPath: (NSString *) thePath
{
    if (self = [super init]) {
        self.path = thePath;
        self.title = [[thePath lastPathComponent] stringByDeletingPathExtension];
        author = nil;
        pages = nil;
        contents = NULL;
        estimatedPages = totalCharacters = lastReadPage = 0;
        lastReadPage = [self lastReadPageForPath: thePath];
    }
    return self;
}

- (NSUInteger) lastReadPageForPath: (NSString *) thePath
{
    NSUInteger num;
    if (getxattr([self.path fileSystemRepresentation],
                 "lastReadPage", &num, sizeof(num), 0, 0) == sizeof(num))
        return num;
    else
        return 0;
}

- (NSUInteger) lastReadPage
{
    return lastReadPage;
}

- (void) setLastReadPage: (NSUInteger) num
{
    lastReadPage = num;
    setxattr([self.path fileSystemRepresentation],
             "lastReadPage", &num, sizeof(num), 0, 0);
}

- (NSString *) description
{
    return self.title;
}

#define kCharsPerPage   1024

// Load book from local storage
- (JJPage *) loadPage: (NSUInteger) pageNum
       withAttributes: (NSDictionary *) attributes
                frame: (CGRect) frame
{
    // NSLog(@"Loading page %d from book %@", pageNum, self.path);
    if (! contents)
    {
        NSStringEncoding encoding = [self.path detectedEncodingAtPath];
        NSLog(@"Loading contents from %@, %d", self.path, encoding);
        NSString *text = [NSString stringWithContentsOfFile: self.path
                                                   encoding: encoding
                                                      error: NULL];
        if (! text)
        {
            NSLog(@"Failed to load");
            return nil;
        }

        // Convert DOS line endings with UNIX line endings
        text = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        contents = CFAttributedStringCreate(0, (CFStringRef) text, (CFDictionaryRef) attributes);
    }
    if (! pages)
        pages = [[NSMutableArray alloc] initWithCapacity: 1024];

    CFRange range = CFRangeMake(0, kCharsPerPage);
    JJPage *page, *lastPage = [pages lastObject];
    CFIndex length = CFAttributedStringGetLength(contents);

    if (lastPage)
        range.location = lastPage.textRange.location + lastPage.textRange.length;

    if (range.location + range.length > length)
        range.length = length - range.location;

    // NSLog(@"%d pages", [pages count]);

    for (; [pages count] <= pageNum && range.location < length;
         range.location += page.textRange.length)
    {
        range.length = (length - range.location) > kCharsPerPage ? kCharsPerPage : length - range.location;
        page = [[JJPage alloc] initWithContents: contents
                                        atRange: range
                                        inFrame: frame];
        totalCharacters += page.textRange.length;
        [pages addObject: page];
        [page release];
        // NSLog(@"%d pages created, range = %d, %d.", [pages count], page.textRange.location, page.textRange.length);
    }

    estimatedPages = totalCharacters < length ? length / (totalCharacters / pages.count)
                                              : pages.count;
    return pageNum < pages.count ? [pages objectAtIndex: pageNum] : nil;
}

- (void) releaseAllPages
{
    if (contents)
        CFRelease(contents);
    contents = NULL;
    [pages removeAllObjects];
}

- (void) dealloc
{
    NSLog(@"Unloading book %@", self.path);
    [pages release];
    if (contents)
        CFRelease(contents);
    [path release];
    [title release];
    [author release];
    [super dealloc];
}

@end
