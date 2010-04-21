//
//  JJTextView.h
//  iTextus
//
//  Created by Jiang Jiang on 1/29/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "JJBook.h"

@interface JJTextView : UIView {
    CTFramesetterRef framesetter;
    JJBook *book;
    NSDictionary *textAttributes;
    NSUInteger currentPage;
}

@property (retain) JJBook *book;
- (CGSize) sizeForRenderingAtPoint: (CGPoint) point;

@end
