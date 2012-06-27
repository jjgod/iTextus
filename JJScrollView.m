//
//  JJScrollView.m
//  iTextus
//
//  Created by Jiang Jiang on 3/27/12.
//

#import "JJScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JJScrollView

@synthesize textAttributes;
@dynamic book;

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        // Initialization code
        NSLog(@"initialize: %@", NSStringFromCGRect(frame));

        views = [[NSMutableArray alloc] initWithCapacity: 3];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer: singleTap];
        [singleTap release];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        CTFontRef font = CTFontCreateWithName((CFStringRef) [defaults stringForKey: @"fontName"],
                                              [defaults floatForKey: @"fontSize"], NULL);
        textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                          (id) font, (NSString *) kCTFontAttributeName, nil];
        CFRelease(font);

        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentSize = self.frame.size;
        self.pagingEnabled = YES;
        self.bounces = YES;
        self.alwaysBounceHorizontal = YES;
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (JJTextView *) loadTextView: (NSInteger) pageNum
{
    CGRect pageFrame = CGRectMake(pageNum * self.bounds.size.width, 0,
                                  self.bounds.size.width,
                                  self.bounds.size.height);
    // NSLog(@"loadTextView: %d, %@", pageNum, NSStringFromCGRect(pageFrame));
    JJTextView *view = [[JJTextView alloc] initWithFrame: pageFrame andPage: pageNum];
    [self addSubview: view];
    [view release];
    return view;
}

- (void) populateViews
{
    int n = self.contentOffset.x / self.frame.size.width;
    bool hasPrevView, hasCurrentView, hasNextView;

    hasPrevView = hasCurrentView = hasNextView = NO;

    NSMutableArray *viewsToRemove = [[NSMutableArray alloc] initWithCapacity: 3];
    for (JJTextView *view in views) {
        int pageNum = view.pageNum;
        if (pageNum < n - 1 || pageNum > n + 1) {
            [viewsToRemove addObject: view];
        } else {
            if (pageNum == n)
                hasCurrentView = YES;
            else if (pageNum == n - 1)
                hasPrevView = YES;
            else if (pageNum == n + 1)
                hasNextView = YES;
        }
    }

    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (n > 0 && ! hasPrevView)
            [views addObject: [self loadTextView: n - 1]];
        if (! hasCurrentView)
            [views addObject: [self loadTextView: n]];
        if (! hasNextView)
            [views addObject: [self loadTextView: n + 1]];

        for (JJTextView *view in viewsToRemove)
        {
            [view removeFromSuperview];
            [views removeObject: view];
        }

        [viewsToRemove release];
    });
}

- (void) layoutSubviews
{
    [self populateViews];
}

- (void) handleSingleTap: (UITapGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationOfTouch: 0 inView: self];
        int x = (int) location.x % (int) self.frame.size.width;
        if (x > 600 || x < 150) {
            CGFloat nextX = location.x - x;
            if (x > 600)
                nextX += self.frame.size.width;
            else
                nextX -= self.frame.size.width;
            if (nextX < 0)
                return;
            [self setContentOffset: CGPointMake(nextX, 0)
                          animated: YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarHidden: ![[UIApplication sharedApplication] isStatusBarHidden]
                                                    withAnimation: UIStatusBarAnimationSlide];
        }
    }
}

- (void) setBook:(JJBook *)_book
{
    if (![book.path isEqualToString: _book.path]) {
        book = _book;
        // NSLog(@"setBook: %@", book);
        for (JJTextView *view in views)
            [view removeFromSuperview];
        [views removeAllObjects];
        [self populateViews];
    }
}

- (JJBook *) book
{
    return book;
}

- (void)dealloc
{
	// Clean up
    [views release];
    [super dealloc];
}

@end
