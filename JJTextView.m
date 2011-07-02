//
//  JJTextView.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "JJTextView.h"
#import "DetailViewController.h"

@implementation JJTextView

@synthesize controller;

#define kPageHeight     400

- (CGSize) sizeForRenderingAtPoint: (CGPoint) point
{
    CGRect frame = self.frame;
    // round to page height
    frame.size.height = (point.y + frame.size.height + kPageHeight - 1) / kPageHeight * kPageHeight;
    [self setFrame: frame];
    return frame.size;
}

- (void) touchesEnded: (NSSet *) touches
            withEvent: (UIEvent *) event
{
    JJBook *book = controller.detailItem;

    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView: self];
        if (location.y < 256)
        {
            if (book.lastReadPage > 0)
            {
                book.lastReadPage -= 1;
                [controller hideAll];
                [self setNeedsDisplay];
            }
        }
        else if (location.y > 768)
        {
            book.lastReadPage += 1;
            [controller hideAll];
            [self setNeedsDisplay];
        }
        else
            [controller toggleAll];

        // NSLog(@"touched: %g, %g", location.x, location.y);
    }
}

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect: (CGRect) rect
{
    JJBook *book = controller.detailItem;

    // NSLog(@"drawRect: %@", NSStringFromCGRect(rect));

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *tile = [UIImage imageNamed: @"brushed_alu.png"];
    UIColor *color = [UIColor colorWithPatternImage: tile];
    [color setFill];
    // CGContextSetRGBFillColor(context, 1.0, 1.0, 0.85, 1.0);
    CGContextFillRect(context, rect);
    CGContextSetAllowsFontSmoothing(context, true);
    CGContextSetAllowsFontSubpixelPositioning(context, true);
    CGContextSetShouldSmoothFonts(context, true);
    CGContextSetShouldSubpixelPositionFonts(context, true);

    if (! book)
        return;

    if (! textAttributes)
    {
        NSLog(@"Preparing text attributes");
        CTFontRef font = CTFontCreateWithName(CFSTR("FZKai-Z03"), 26.0, NULL);
        CGFloat paragraphSpacing = 4.0;
        CGFloat lineSpacing = 8.0;
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

    CGSize inset = CGSizeMake(50, 20);
    CGRect pageFrame = CGRectMake(inset.width, inset.height,
                                  rect.size.width - 2 * inset.width,
                                  rect.size.height - 2 * inset.height);

    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    NSDate *currentTime = [NSDate date];
    JJPage *page = [book loadPage: book.lastReadPage
                   withAttributes: textAttributes
                            frame: pageFrame];
    NSTimeInterval interval = -[currentTime timeIntervalSinceNow];
    
    if (page)
    {
        // NSLog(@"Start drawing page %d", book.lastReadPage);

        CGContextSaveGState(context);
        CGContextConcatCTM(context, CGAffineTransformMakeScale(1, -1));
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(0, -(pageFrame.origin.y * 2 + pageFrame.size.height)));
        CTFrameDraw(page.textFrame, context);
        CGContextRestoreGState(context);
    } else {
        book.lastReadPage = book.pages.count - 1;
    }

    NSLog(@"used %g secs", interval);

    // NSLog(@"estimatedPages = %d, pages = %d", book.estimatedPages, book.pages.count);
    CGFloat seenWidth = rect.size.width * (book.lastReadPage + 1) / book.estimatedPages;

    CGContextSetRGBFillColor(context, 0.7, 0.7, 0.7, 1.0);
    CGContextFillRect(context, CGRectMake(0, rect.size.height - 5, seenWidth, 5));

    CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 1.0);
    CGContextFillRect(context, CGRectMake(seenWidth, rect.size.height - 5, rect.size.width - seenWidth, 5));
}

- (void) dealloc
{
    [textAttributes release];
    [super dealloc];
}


@end
