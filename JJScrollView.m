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

@synthesize book;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        // Initialization code
        NSLog(@"initialize: %@", NSStringFromCGRect(frame));

        CGRect contentFrame = frame;
        contentFrame.size.width = frame.size.width * 2;
        textView = [[JJTextView alloc] initWithFrame: contentFrame];
        textView.contentMode = UIViewContentModeRedraw;
		[self addSubview: textView];
        self.contentSize = contentFrame.size;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.delegate = self;
    }
    return self;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGSize size = self.contentSize;
    size.width = (book.pages.count + 1) * self.bounds.size.width;
    if (size.width <= self.contentSize.width)
        return;
    self.contentSize = size;
    CGRect frame = textView.frame;
    frame.size = size;
    textView.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];

    // center the image as it becomes smaller than the size of the screen

    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = textView.frame;

    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;

    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;

    textView.frame = frameToCenter;

	// to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
	// tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
	// which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
	textView.contentScaleFactor = 1.0;
}

- (void)dealloc
{
	// Clean up
    [textView release];
    [super dealloc];
}

@end
