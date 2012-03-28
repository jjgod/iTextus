//
//  JJTextView.h
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class DetailViewController;

@interface JJTextView : UIView {
    CGRect pageFrame;
    NSUInteger pageNum;
}

- (id)initWithFrame:(CGRect)frame andPage: (NSUInteger) page;

@property (readonly) CGRect pageFrame;
@property (readonly) NSUInteger pageNum;

@end
