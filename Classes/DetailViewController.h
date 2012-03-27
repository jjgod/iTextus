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

    JJBook *detailItem;
    JJTextView *textView;
}

@property (nonatomic, retain) UIPopoverController *popoverController;

@property (nonatomic, retain) JJBook *detailItem;
@property (nonatomic, retain) IBOutlet JJTextView *textView;

- (void) hideAll;
- (void) showAll;
- (void) toggleAll;

@end
