//
//  MasterViewController.h
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright Jjgod Jiang 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController {
    DetailViewController *detailViewController;
    NSMutableArray *books;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
