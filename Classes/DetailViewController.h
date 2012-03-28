//
//  DetailViewController.h
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright Jjgod Jiang 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "JJBook.h"
#import "JJScrollView.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    UIPopoverController *popoverController;

    JJBook *detailItem;
    JJScrollView *scrollView;
}

@property (nonatomic, retain) UIPopoverController *popoverController;

@property (nonatomic, retain) JJBook *detailItem;

- (void) hideAll;
- (void) showAll;
- (void) toggleAll;

@end
