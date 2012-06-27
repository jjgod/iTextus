//
//  JJPage.h
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#define JJ_CUSTOM_FRAMESETTER 1

@interface JJPage : NSObject {
    CGRect frame;
    CFRange textRange;
#ifndef JJ_CUSTOM_FRAMESETTER
    CTFrameRef textFrame;
#else
    NSMutableArray *lines;
#endif
}

- (id) initWithContents: (CFAttributedStringRef) contents atRange: (CFRange) initialRange inFrame: (CGRect) theFrame;

@property (readonly) CFRange textRange;
#ifndef JJ_CUSTOM_FRAMESETTER
@property (readonly) CTFrameRef textFrame;
#else
@property (readonly) NSMutableArray *lines;
#endif

@end
