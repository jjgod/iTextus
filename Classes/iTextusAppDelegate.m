//
//  iTextusAppDelegate.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright Jjgod Jiang 2010. All rights reserved.
//

#import "iTextusAppDelegate.h"


#import "MasterViewController.h"
#import "DetailViewController.h"


@implementation iTextusAppDelegate

@synthesize window, splitViewController, masterViewController, detailViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
    // Override point for customization after app launch
    masterViewController = [[MasterViewController alloc] initWithStyle: UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: masterViewController];

    detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    masterViewController.detailViewController = detailViewController;

    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects: navigationController, detailViewController, nil];
	splitViewController.delegate = detailViewController;

    // Add the split view controller's view to the window and display.
    [window addSubview: splitViewController.view];
    [window makeKeyAndVisible];

    NSMutableArray *books = masterViewController.books;
    NSString *lastReadPath = [[NSUserDefaults standardUserDefaults] stringForKey: @"lastReadPath"];

    if (lastReadPath && books && books.count) {
        for (JJBook *book in books)
            if ([book.path isEqualToString: lastReadPath])
            {
                [detailViewController setDetailItem: book];
                break;
            }
    }

    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}

#pragma mark -
#pragma mark Memory management

- (void) applicationDidReceiveMemoryWarning: (UIApplication *) application
{
    [masterViewController releaseAllPages];
}

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

