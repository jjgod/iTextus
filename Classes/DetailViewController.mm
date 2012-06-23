//
//  DetailViewController.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "JJScrollView.h"

@implementation DetailViewController

@synthesize popoverController, detailItem;

#pragma mark -
#pragma mark Managing the popover controller

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(JJBook *)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        [[NSUserDefaults standardUserDefaults] setObject: detailItem.path
                                                  forKey: @"lastReadPath"];
        scrollView.book = detailItem;
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
}

- (void) hideAll
{
    [[UIApplication sharedApplication] setStatusBarHidden: YES
                                            withAnimation: UIStatusBarAnimationFade];
}

- (void) toggleAll
{
    if ([[UIApplication sharedApplication] isStatusBarHidden])
        [self showAll];
    else
        [self hideAll];
}

- (void) showAll
{
    [[UIApplication sharedApplication] setStatusBarHidden: NO
                                            withAnimation: UIStatusBarAnimationFade];
}

#pragma mark -
#pragma mark Split view support

- (void) splitViewController: (UISplitViewController*) svc
      willHideViewController: (UIViewController *) aViewController
           withBarButtonItem: (UIBarButtonItem *) barButtonItem
        forPopoverController: (UIPopoverController *) pc
{
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void) splitViewController: (UISplitViewController *) svc
      willShowViewController: (UIViewController *) aViewController
   invalidatingBarButtonItem: (UIBarButtonItem *) barButtonItem
{
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"didRotateFromInterfaceOrientation: %d", fromInterfaceOrientation);
    // [self.view setNeedsDisplay];
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)loadView {
    [self setWantsFullScreenLayout: YES];
	// Create our PDFScrollView and add it to the view controller.
    NSLog(@"%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
	scrollView = [[JJScrollView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    scrollView.autoresizesSubviews = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = scrollView;
}

- (void)viewDidLoad {
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [detailItem release];
    [super dealloc];
}

@end
