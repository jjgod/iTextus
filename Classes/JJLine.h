//
//  JJLine.h
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJLine : NSObject {
    NSUInteger start;
}

@property (assign) NSUInteger start;

- (id) initWithStart: (NSUInteger) start;

@end
