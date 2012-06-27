//
//  JJLine.m
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "JJLine.h"

@implementation JJLine

@synthesize origin, line;

- (id) initWithLine:(CTLineRef) theLine origin: (CGFloat) theOrigin
{
    if (self = [super init]) {
        line = CFRetain(theLine);
        origin = theOrigin;
    }
    return self;
}

- (void) dealloc
{
    CFRelease(line);
    line = NULL;
    [super dealloc];
}

@end
