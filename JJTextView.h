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
    NSDictionary *textAttributes;
    CGRect pageFrame;
}

- (id)initWithFrame:(CGRect)frame;

@property (readonly) NSDictionary *textAttributes;
@property (readonly) CGRect pageFrame;

@end
