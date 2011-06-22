//
//  JJPage.m
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "JJPage.h"

@implementation JJPage

@synthesize textRange, textFrame;

- (id) initWithContents: (CFAttributedStringRef) contents
                atRange: (CFRange) initialRange
                inFrame: (CGRect) theFrame
{
    if (self = [super init]) {
        // NSLog(@"Creating page with range: %d, %d", initialRange.location, initialRange.length);
        CFAttributedStringRef substring = CFAttributedStringCreateWithSubstring(0, contents, initialRange);

        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(substring);
        CFRelease(substring);

        frame = theFrame;
        if (framesetter) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, frame);
            textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);

            CFRelease(path);
            textRange = CTFrameGetVisibleStringRange(textFrame);
            // NSLog(@"textRange: %d, %d", textRange.location, textRange.length);
            textRange.location = initialRange.location;
        }

        CFRelease(framesetter);
    }
    return self;
}

- (void) dealloc
{
    if (textFrame)
        CFRelease(textFrame);
    [super dealloc];
}

@end
