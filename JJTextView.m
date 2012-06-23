//
//  JJTextView.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//

#import "JJTextView.h"
#import "JJScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JJTextView

@synthesize pageFrame, pageNum;

- (id)initWithFrame:(CGRect)frame andPage:(NSUInteger)page {
    if ((self = [super initWithFrame:frame])) {
        CGSize inset = CGSizeMake(70, 80);
        pageFrame = CGRectMake(inset.width, inset.height,
                               [UIScreen mainScreen].bounds.size.width - 2 * inset.width,
                               frame.size.height - 2 * inset.height);
        pageNum = page;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void) drawRect:(CGRect)rect
{
    // NSLog(@"drawRect: %@", NSStringFromCGRect(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIImage *tile = [UIImage imageNamed: @"brushed_alu.png"];
    UIColor *color = [UIColor colorWithPatternImage: tile];
    [color setFill];

    // CGContextSetRGBFillColor(context, 1.0, 1.0, 0.85, 1.0);
    CGContextFillRect(context, rect);
    
    CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 1.0);
    CGContextFillRect(context, CGRectMake(0, 0, 3.0, 1024));

    JJBook *book = ((JJScrollView *) self.superview).book;

    CGContextSetAllowsFontSmoothing(context, true);
    CGContextSetAllowsFontSubpixelPositioning(context, true);
    CGContextSetShouldSmoothFonts(context, true);
    CGContextSetShouldSubpixelPositionFonts(context, true);

    if (! book)
        return;

    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    // NSDate *currentTime = [NSDate date];
    JJPage *page = [book loadPage: pageNum
                   withAttributes: ((JJScrollView *) self.superview).textAttributes
                            frame: pageFrame];

    if (page)
    {
        // NSLog(@"draw page %d", pageNum);
        CGContextSaveGState(context);
        CGContextConcatCTM(context, CGAffineTransformMakeScale(1, -1));
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(0, -(pageFrame.origin.y * 2 + 20 + pageFrame.size.height)));
        CGRect lineBounds = CTLineGetImageBounds(book.titleLine, context);
        CGContextSetTextPosition(context, (rect.size.width - lineBounds.size.width) / 2 - 10, pageFrame.origin.y + pageFrame.size.height + 35);
        CTLineDraw(book.titleLine, context);
        CTFrameDraw(page.textFrame, context);
        CGContextRestoreGState(context);
    } else {
        book.lastReadPage = book.pages.count - 1;
    }

    JJScrollView *scrollView = (JJScrollView *) self.superview;
    CGSize size = scrollView.contentSize;
    NSLog(@"pages: %d", book.pages.count);
    if (size.width < self.frame.size.width * (book.pages.count + 1)) {
        size.width = self.frame.size.width * (book.pages.count + 1);
        scrollView.contentSize = size;
    }
    // NSTimeInterval interval = -[currentTime timeIntervalSinceNow];
    // NSLog(@"used %g ms", interval * 1000);
}

- (void) dealloc
{
    NSLog(@"dealloc page view %d", pageNum);
    [super dealloc];
}

@end
