//
//  iTextusAppDelegate.h
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//

#import <UIKit/UIKit.h>

@class MasterViewController;
@class DetailViewController;

@interface iTextusAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;

    UISplitViewController *splitViewController;

    MasterViewController *masterViewController;
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet MasterViewController *masterViewController;
@property (nonatomic,retain) IBOutlet DetailViewController *detailViewController;

@end
