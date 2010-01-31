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

@class JJTextView;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {

    UIPopoverController *popoverController;
    UINavigationBar *navigationBar;

    JJBook *detailItem;
    UIScrollView *scrollView;
    JJTextView *textView;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) JJBook *detailItem;
@property (nonatomic, retain) JJTextView *textView;

@end
