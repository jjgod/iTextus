//
//  JJLine.h
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface JJLine : NSObject {
    CTLineRef line;
    CGFloat origin;
}

@property (assign) CGFloat origin;
@property (readonly) CTLineRef line;

- (id) initWithLine: (CTLineRef) line origin: (CGFloat) origin;

@end
