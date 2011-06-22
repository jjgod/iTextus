//
//  MasterViewController.m
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright Jjgod Jiang 2010. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "JJBook.h"

@implementation MasterViewController

@synthesize detailViewController;


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Size for popover
// The size the view should be when presented in a popover.
- (CGSize)contentSizeForViewInPopoverView {
    return CGSizeMake(320.0, 600.0);
}


#pragma mark -
#pragma mark View lifecycle

- (NSString *) documentsDirectory
{
#if TARGET_IPHONE_SIMULATOR
    NSString *documentsDirectory = @"/Users/jjgod/Downloads/Downloads/Novels";
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex: 0];
#endif

    return documentsDirectory;
}

- (void) loadBooks
{
    NSString *documentsDirectory = [self documentsDirectory];
    NSString *file;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath: documentsDirectory];

    if (! books)
        books = [[NSMutableArray alloc] initWithCapacity: 100];
    else
        [books removeAllObjects];

    while (file = [dirEnum nextObject]) {
        // NSLog(@"%@", file);
        if ([[file pathExtension] isEqualToString: @"txt"]) {
            JJBook *book = [[JJBook alloc] initWithPath: [documentsDirectory stringByAppendingPathComponent: file]];
            [books addObject: book];
            [book release];
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.documentsDirectory lastPathComponent];
    [self loadBooks];
}

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
/*
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
 */

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [books count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";

	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    // Get the object to display and set the value in the cell.
    cell.textLabel.text = [[books objectAtIndex: indexPath.row] description];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    detailViewController.detailItem = [books objectAtIndex: indexPath.row];
}


#pragma mark -
#pragma mark Memory management

- (void) releaseAllPages
{
    for (JJBook *book in books)
        if (! [book isEqual: detailViewController.detailItem])
            [book releaseAllPages];
}

- (void)dealloc {
    [books release];
    [detailViewController release];
    [super dealloc];
}

@end
