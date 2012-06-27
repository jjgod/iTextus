//
//  JJPage.m
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "JJPage.h"
#import "JJLine.h"

@implementation JJPage

@synthesize textRange,
#ifndef JJ_CUSTOM_FRAMESETTER
textFrame
#else
lines
#endif
;

- (id) initWithContents: (CFAttributedStringRef) contents
                atRange: (CFRange) initialRange
                inFrame: (CGRect) theFrame
{
    if (self = [super init]) {
        // NSLog(@"Creating page with range: %d, %d", initialRange.location, initialRange.length);
        CFAttributedStringRef substring = CFAttributedStringCreateWithSubstring(0, contents, initialRange);
        frame = theFrame;
#ifdef JJ_CUSTOM_FRAMESETTER
        lines = [[NSMutableArray alloc] initWithCapacity: 50];
        CFStringRef str = CFAttributedStringGetString(substring);
        CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(substring);
        CFIndex start, length = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        float fontSize = [defaults floatForKey: @"fontSize"];
        float lineSpacing = [defaults floatForKey: @"lineSpacing"];
        float paragraphSpacing = [defaults floatForKey: @"paragraphSpacing"];
        float remainWidth = MAX(theFrame.size.width - floor(theFrame.size.width / fontSize) * fontSize, fontSize);
        CGFloat origin = 0;

        for (start = 0; start < initialRange.length; start += length) {
            length = CTTypesetterSuggestLineBreak(typesetter, start, theFrame.size.width);
            if (length == 1 && CFStringGetCharacterAtIndex(str, start) == '\n')
                continue;
            CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, length));

#if 1 /* Hanging punctuation */
            CFIndex secondCharInNextLineIndex = start + length + 1;
            if (secondCharInNextLineIndex < initialRange.length) {
                UniChar ch = CFStringGetCharacterAtIndex(str, secondCharInNextLineIndex);
                double offset = CTLineGetPenOffsetForFlush(line, 1.0, theFrame.size.width);
                if ((ch == 0xFF0C /* ， */ || ch == 0x3002 /* 。 */ ||
                     ch == 0x3001 /* 、 */ || ch == 0xFF01 /* ！ */ ||
                     ch == 0xFF1A /* ： */ || ch == 0xFF1B /* ； */ ||
                     ch == 0x201D /* ” */) &&
                    offset > remainWidth) {
                    CFRelease(line);
                    length += 2;
                    if (secondCharInNextLineIndex + 1 < initialRange.length &&
                        CFStringGetCharacterAtIndex(str, secondCharInNextLineIndex + 1) == 0x201D /* ” */)
                        length += 1;
                    line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, length));
                }
            }
#endif

            CGFloat ascent, descent, leading;
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            origin += ascent;
            if (origin + descent + leading > theFrame.size.height) {
                CFRelease(line);
                break;
            }
            JJLine *pline = [[JJLine alloc] initWithLine: line origin: origin];
            CFRelease(line);
            [lines addObject: pline];
            origin += descent + leading + lineSpacing;

            // TODO: paragraphSpacing handling
            if (CFStringGetCharacterAtIndex(str, start + length) == '\n')
                origin += paragraphSpacing * fontSize;
        }
        textRange = CFRangeMake(initialRange.location, start);
#else
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(substring);
        CFRelease(substring);

        if (framesetter) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, frame);
            textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);

            CFRelease(path);
            textRange = CTFrameGetVisibleStringRange(textFrame);
            // NSLog(@"textRange: %d, %d", textRange.location, textRange.length);
            textRange.location = initialRange.location;
            CFRelease(framesetter);
        }
#endif
    }
    return self;
}

- (void) dealloc
{
#ifndef JJ_CUSTOM_FRAMESETTER
    if (textFrame)
        CFRelease(textFrame);
#else
    [lines release];
#endif
    [super dealloc];
}

@end
