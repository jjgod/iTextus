//
//  JJLine.m
//  iTextus
//
//  Created by Jiang Jiang on 1/31/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "JJLine.h"

@implementation JJLine

@synthesize start;

- (id) initWithStart:(NSUInteger)theStart
{
    if (self = [super init]) {
        start = theStart;
    }
    return self;
}

@end
