//
//  DetailViewController.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright Jjgod Jiang 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "JJTextView.h"

@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, textView;

#pragma mark -
#pragma mark Managing the popover controller

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(JJBook *)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];

        // [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
        // Update the view.
        // navigationBar.topItem.title = [detailItem description];

        [[NSUserDefaults standardUserDefaults] setObject: detailItem.path
                                                  forKey: @"lastReadPath"];
        [textView setController: self];
        [textView setContentMode: UIViewContentModeTopLeft];
        [textView setNeedsDisplay];
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
}

- (void) hideAll
{
    [[UIApplication sharedApplication] setStatusBarHidden: YES
                                            withAnimation: UIStatusBarAnimationFade];
    [toolbar setHidden: YES];
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
    [toolbar setHidden: NO];
}

#pragma mark -
#pragma mark Split view support

- (void) splitViewController: (UISplitViewController*) svc
      willHideViewController: (UIViewController *) aViewController
           withBarButtonItem: (UIBarButtonItem *) barButtonItem
        forPopoverController: (UIPopoverController *) pc
{
    barButtonItem.title = aViewController.title;
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void) splitViewController: (UISplitViewController *) svc
      willShowViewController: (UIViewController *) aViewController
   invalidatingBarButtonItem: (UIBarButtonItem *) barButtonItem
{
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
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
    [self.view setNeedsDisplay];
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
    [toolbar release];
    [textView release];
    [popoverController release];
    [detailItem release];
    [super dealloc];
}

@end
