//
//  DANavigationBar.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 12/01/2012.
//  Copyright (c) 2012 log.OSCON. All rights reserved.
//

#import "DANavigationBar.h"

@implementation DANavigationBar : UINavigationBar

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"BackgroundNavigation.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end

