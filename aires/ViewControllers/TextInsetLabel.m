//
//  TextInsetLabel.m
//  aires
//
//  Created by Mani on 5/15/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "TextInsetLabel.h"

@implementation TextInsetLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 8, 0, 8};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
