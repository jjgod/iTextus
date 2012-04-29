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
        views = [[NSMutableArray alloc] initWithCapacity: 3];
        [self populateViews];

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

- (JJTextView *) loadTextView: (NSInteger) pageNum
{
    CGRect pageFrame = CGRectMake(pageNum * self.frame.size.width, 0,
                                  self.frame.size.width,
                                  self.frame.size.height);
    JJTextView *view = [[JJTextView alloc] initWithFrame: pageFrame andPage: pageNum];
    [self addSubview: view];
    [view release];
    return view;
}

- (void) populateViews
{
    NSInteger n = self.contentOffset.x / self.frame.size.width;
    bool hasPrevView, hasCurrentView, hasNextView;

    hasPrevView = hasCurrentView = hasNextView = NO;

    NSMutableArray *viewsToRemove = [[NSMutableArray alloc] initWithCapacity: 3];
    for (JJTextView *view in views) {
        if (view.pageNum < n - 1 || view.pageNum > n + 1) {
            [viewsToRemove addObject: view];
        } else {
            if (view.pageNum == n)
                hasCurrentView = YES;
            else if (view.pageNum == n - 1)
                hasPrevView = YES;
            else if (view.pageNum == n + 1)
                hasNextView = YES;
        }
    }

    for (JJTextView *view in viewsToRemove)
    {
        [view removeFromSuperview];
        [views removeObject: view];
    }

    [viewsToRemove release];

    CGSize size = self.contentSize;
    if (size.width < self.frame.size.width * (book.pages.count + 1)) {
        size.width = self.frame.size.width * (book.pages.count + 1);
        self.contentSize = size;
    }

    if (n > 0 && ! hasPrevView)
        [views addObject: [self loadTextView: n - 1]];
    if (! hasCurrentView)
        [views addObject: [self loadTextView: n]];
    if (! hasNextView)
        [views addObject: [self loadTextView: n + 1]];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self populateViews];
}

- (void)dealloc
{
	// Clean up
    [views release];
    [super dealloc];
}

@end
