//
//  JJTextView.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "JJTextView.h"

@implementation JJTextView

@synthesize book;

- (id) initWithFrame: (CGRect) frame
                book: (JJBook *) theBook
{
    if (self = [super initWithFrame:frame])
    {
        framesetter = NULL;
        self.book = theBook;
    }
    return self;
}

#define kPageHeight     400

- (CGSize) sizeForRenderingAtPoint: (CGPoint) point
{
    CGRect frame = self.frame;
    // round to page height
    frame.size.height = (point.y + frame.size.height + kPageHeight - 1) / kPageHeight * kPageHeight;
    [self setFrame: frame];
    return frame.size;
}

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect: (CGRect) rect
{
    NSLog(@"drawRect: %@", NSStringFromCGRect(rect));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, rect);

    if (book)
    {
        if (! textAttributes)
        {
            NSLog(@"Preparing text attributes");
            CTFontRef font = CTFontCreateWithName(CFSTR("FZKai-Z03"), 24.0, NULL);
            CGFloat paragraphSpacing = 0.0;
            CGFloat lineSpacing = 3.0;
            CTParagraphStyleSetting settings[] = {
                { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing },
                { kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing },
            };
            CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, ARRSIZE(settings));
            textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                              (id) font, (NSString *) kCTFontAttributeName, 
                              (id) paragraphStyle, (NSString *) kCTParagraphStyleAttributeName, nil];
            CFRelease(font);
        }

        NSUInteger start = rect.origin.y / kPageHeight;
        NSUInteger end = (rect.origin.y + rect.size.height) / kPageHeight;
        CGRect pageFrame = rect;
        pageFrame.size.height = kPageHeight;
        
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);

        for (NSUInteger i = start; i <= end;
             i++, pageFrame.origin.y += pageFrame.size.height)
        {
            JJPage *page = [book loadPage: i
                           withAttributes: textAttributes
                                    frame: pageFrame];
            if (! page)
                break;

            NSLog(@"Start drawing page %d", i);

            CGContextSaveGState(context);
            CGContextConcatCTM(context, CGAffineTransformMakeScale(1, -1));
            CGContextConcatCTM(context, CGAffineTransformMakeTranslation(0, -(pageFrame.origin.y * 2 + pageFrame.size.height)));
            CTFrameDraw(page.textFrame, context);
            CGContextRestoreGState(context);
        }
    }
}

- (void) dealloc
{
    if (framesetter)
        CFRelease(framesetter);
    
    [book release];

    [textAttributes release];
    [super dealloc];
}


@end
