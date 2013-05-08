//
//  TextEditView.m
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "TextEditView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControls];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initControls];
}

-(void)initControls
{
    // Initialization code
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    UIImage *bgimage = [UIImage imageNamed:@"btn_navbar_nor.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_doneButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"btn_navbar_pressed.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_doneButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    bgimage = [UIImage imageNamed:@"navbar_back_nor.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_cancelButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"navbar_back_pressed.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_cancelButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    UIFont *fontBold14px = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    UIImage *buttonImage = [UIImage imageNamed:@"btn_contact_bg.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:buttonImage.size.width/2 topCapHeight:buttonImage.size.height/2];
    [_cancelButton.titleLabel setFont:fontBold14px];
    [_doneButton.titleLabel setFont:fontBold14px];
    
    _titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18.0f];
    _textView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.0f];
    
    [_textView becomeFirstResponder];
}

-(void)setText:(NSString*)text
{
    _textView.text = text;
}

-(void)setTitle:(NSString*)title
{
    _titleLabel.text = title;
}

-(IBAction)donePressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(textEditDonePressed:)])
    {
        [_delegate textEditDonePressed:_textView.text];
    }
}

-(IBAction)cancelPressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(measurementsCancelPressed)])
    {
        [_delegate textEditCancelPressed];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Create thegradient
    CGFloat colors [] = {
        1.0f, 1.0f, 1.0f, 1.0f,
        227.0f/255.0f, 241.0f/255.0f, 251.0f/255.0f, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // Get the current context so we can draw.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Set the fill color to white.
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f].CGColor);
}

@end
