//
//  iTextusAppDelegate.h
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright Jjgod Jiang 2010. All rights reserved.
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
