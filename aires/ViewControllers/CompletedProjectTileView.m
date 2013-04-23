//
//  CompletedProjectTileView.m
//  AiresConsulting
//
//  Created by Mani on 4/16/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import "CompletedProjectTileView.h"

@interface CompletedProjectTileView ()
{
    UIFont *dateFont;
    UIFont *projectFont;
    UIFont *clientFont;
    UIImage *lockImage;
    BOOL selected;
}
@end

@implementation CompletedProjectTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        dateFont = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0];
        projectFont = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0];
        clientFont = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0];
        lockImage = [UIImage imageNamed:@"lock.png"];
        selected = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    // Get the current context so we can draw.
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    [lockImage drawInRect:CGRectMake(9, 30, 18, 18)];
    
	// Set the fill color to white.
	CGContextSetFillColorWithColor(context, selected ?
                                   [[UIColor colorWithRed:0 green:138.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor] : [[UIColor whiteColor] CGColor]);
   
	[@"Mar 26th, 2013" drawInRect:CGRectMake(35, 30, 210, 20)
                         withFont:dateFont
                    lineBreakMode:UILineBreakModeTailTruncation
                        alignment:UITextAlignmentLeft];
    
    [@"Building Material Review for Aires Consulting" drawInRect:CGRectMake(35, 48, 210, 20)
                                                        withFont:projectFont
                                                   lineBreakMode:UILineBreakModeTailTruncation
                                                       alignment:UITextAlignmentLeft];
    
    [@"EFG Industries" drawInRect:CGRectMake(35, 70, 210, 20)
                         withFont:clientFont
                    lineBreakMode:UILineBreakModeTailTruncation
                        alignment:UITextAlignmentLeft];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    selected = YES;
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    selected = NO;
    [self setNeedsDisplay];
}

@end