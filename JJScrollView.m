//
//  JJScrollView.m
//  iTextus
//
//  Created by Jiang Jiang on 3/27/12.
//  Copyright (c) 2012 Nokia. All rights reserved.
//

#import "JJScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JJScrollView

@synthesize book, textAttributes;

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        // Initialization code
        NSLog(@"initialize: %@", NSStringFromCGRect(frame));

        CGRect contentFrame = frame;
        contentFrame.size.width = frame.size.width * 2;
        currentView = [[JJTextView alloc] initWithFrame: frame andPage: 0];
        [self addSubview: currentView];
        [currentView release];

        frame.origin.x += frame.size.width;
        nextView = [[JJTextView alloc] initWithFrame: frame andPage: 1];
        [self addSubview: nextView];
        [nextView release];

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

        self.contentSize = contentFrame.size;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger nextPageNum = self.contentOffset.x / self.frame.size.width + 1;
    NSLog(@"endDecelerating: x = %g, w = %g, pn = %d", self.contentOffset.x, self.frame.size.width, nextPageNum);
    if (nextView.pageNum < nextPageNum) {
        previousView = currentView;
        currentView = nextView;
        CGRect pageFrame = currentView.frame;
        pageFrame.origin.x += self.frame.size.width;
        nextView = [[JJTextView alloc] initWithFrame: pageFrame andPage: nextPageNum];
        [self addSubview: nextView];
        [nextView release];
        CGSize size = self.contentSize;
        if (size.width < self.frame.size.width * (book.pages.count + 1)) {
            size.width = self.frame.size.width * (book.pages.count + 1);
            self.contentSize = size;
        }
    }
}

- (void)dealloc
{
	// Clean up
    [currentView release];
    [super dealloc];
}

@end
