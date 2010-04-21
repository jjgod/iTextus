//
//  JJPage.h
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface JJPage : NSObject {
    CGRect frame;
    CFRange textRange;
    CTFrameRef textFrame;
}

- (id) initWithContents: (CFAttributedStringRef) contents atRange: (CFRange) initialRange inFrame: (CGRect) theFrame;

@property (readonly) CFRange textRange;
@property (readonly) CTFrameRef textFrame;

@end
