//
//  TabularColumnView.m
//  aires
//
//  Created by Mani on 5/8/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "TabularColumnView.h"
#import <QuartzCore/QuartzCore.h>

@interface TabularColumnView ()
{
    CALayer *horizontalLine;
    NSMutableArray *verticalLines;
}
@end

@implementation TabularColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateDividerLines
{
    UIColor *grayColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f];
    
    if(!horizontalLine)
    {
        horizontalLine = [CALayer layer];
        horizontalLine.backgroundColor = grayColor.CGColor;
        horizontalLine.frame = CGRectMake(0, _horizontalLineYPos, self.bounds.size.width, 1.0f);
        [self.layer addSublayer:horizontalLine];
    }
    
    if(!verticalLines)
    {
        verticalLines = [[NSMutableArray alloc] initWithCapacity:_numberOfColumns];
    }
    
    for(CALayer *layer in verticalLines)
    {
        [layer removeFromSuperlayer];
    }
    
    for(int i=1; i<_numberOfColumns; i++)
    {
        CALayer *verticalLine = [CALayer layer];
        verticalLine.backgroundColor = grayColor.CGColor;
        verticalLine.frame = CGRectMake((_numberOfColumns-i)*(self.frame.size.width)/_numberOfColumns, 0, 1.0f, self.frame.size.height);
        [self.layer addSublayer:verticalLine];
        [verticalLines addObject:verticalLine];
    }
}

@end
