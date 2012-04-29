//
//  JJScrollView.h
//  iTextus
//
//  Created by Jiang Jiang on 3/27/12.
//  Copyright (c) 2012 Nokia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJTextView.h"
#import "JJBook.h"

@interface JJScrollView : UIScrollView <UIScrollViewDelegate> {
    NSMutableArray *views;
    JJBook *book;
    NSDictionary *textAttributes;
}

@property (assign) JJBook *book;
@property (readonly) NSDictionary *textAttributes;

- (void) populateViews;

@end
