//
//  JJTextView.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "JJTextView.h"
#import "JJScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JJTextView

@synthesize textAttributes, pageFrame;

+ (Class) layerClass {
	return [CATiledLayer class];
}

#if 0
- (void) touchesEnded: (NSSet *) touches
            withEvent: (UIEvent *) event
{
    JJBook *book = ((JJScrollView *) self.superview).book;

    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView: self];
        if (location.y < 256)
        {
            if (book.lastReadPage > 0)
            {
                book.lastReadPage -= 1;
                // [controller hideAll];
                [self setNeedsDisplay];
            }
        }
        else if (location.y > 768)
        {
            book.lastReadPage += 1;
            // [controller hideAll];
            [self setNeedsDisplay];
        }

        // NSLog(@"touched: %g, %g", location.x, location.y);
    }
}
#endif

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 1;
		tiledLayer.levelsOfDetailBias = 0;
        NSLog(@"contentScaleFactor: %g", self.contentScaleFactor);
		tiledLayer.tileSize = CGSizeMake(768, frame.size.height);
        CGSize inset = CGSizeMake(70, 80);
        pageFrame = CGRectMake(inset.width, inset.height,
                               tiledLayer.tileSize.width - 2 * inset.width,
                               frame.size.height - 2 * inset.height);
    }
    return self;
}

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"drawRect: %@, %@, %@", NSStringFromCGRect(rect), NSStringFromCGAffineTransform(CGContextGetCTM(context)), [NSThread currentThread]);

#if 0
    UIImage *tile = [UIImage imageNamed: @"brushed_alu.png"];
    UIColor *color = [UIColor colorWithPatternImage: tile];
    [color setFill];
#endif

    CGContextSetRGBFillColor(context, 1.0, 1.0, 0.85, 1.0);
    CGContextFillRect(context, rect);

    JJBook *book = ((JJScrollView *) self.superview).book;

    CGContextSetAllowsFontSmoothing(context, true);
    CGContextSetAllowsFontSubpixelPositioning(context, true);
    CGContextSetShouldSmoothFonts(context, true);
    CGContextSetShouldSubpixelPositionFonts(context, true);

    if (! book)
        return;

    if (! textAttributes)
    {
        CTFontRef font = CTFontCreateWithName(CFSTR("FZShuSong-Z01"), 24.0, NULL);
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

    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    NSDate *currentTime = [NSDate date];
    NSUInteger pageNum = rect.origin.x / 768;
    JJPage *page = [book loadPage: pageNum
                   withAttributes: textAttributes
                            frame: pageFrame];

    if (page)
    {
        CGContextSaveGState(context);
        CGContextConcatCTM(context, CGAffineTransformMakeScale(1, -1));
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(768 * pageNum, -(pageFrame.origin.y * 2 + 20 + pageFrame.size.height)));
        // CGRect lineBounds = CTLineGetImageBounds(book.titleLine, context);
        // CGContextSetTextPosition(context, (rect.size.width - lineBounds.size.width) / 2 - 10, pageFrame.origin.y + pageFrame.size.height + 35);
        // CTLineDraw(book.titleLine, context);
        CTFrameDraw(page.textFrame, context);
        CGContextRestoreGState(context);
    } else {
        book.lastReadPage = book.pages.count - 1;
    }

    NSTimeInterval interval = -[currentTime timeIntervalSinceNow];
    NSLog(@"used %g ms", interval * 1000);

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
