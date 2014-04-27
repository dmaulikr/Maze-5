//
//  BallView.m
//  Labyrinth
//
//  Created by Minh Luu on 4/26/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "BallView.h"

@implementation BallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [[UIColor redColor] set];
    [path fill];
    
     
}


@end
