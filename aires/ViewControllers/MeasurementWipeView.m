//
//  MeasurementWipeView.m
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "MeasurementWipeView.h"
#import "SampleMeasurement.h"
#import "AiresSingleton.h"
#import "MeasurementFields.h"
#import <QuartzCore/QuartzCore.h>

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface MeasurementWipeView ()
{
    UIPopoverController *popover;
    BOOL editingOnTime;
}
@end

@implementation MeasurementWipeView

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
    
    UIColor *grayColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f];
    UIFont *font14px = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    UIFont *font26px = [UIFont fontWithName:@"ProximaNova-Regular" size:26.0f];
    UIFont *fontBold18px = [UIFont fontWithName:@"ProximaNova-Bold" size:18.0f];
    UIFont *fontBold14px = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    
    _controlsView.layer.borderColor = [UIColor blackColor].CGColor;
    _controlsView.layer.borderWidth = 1.0f;
    _controlsView.layer.cornerRadius = 5.0f;
    
    _editView.layer.borderColor = grayColor.CGColor;
    _editView.layer.borderWidth = 1.0f;
    _editView.layer.cornerRadius = 5.0f;
    _editView.layer.masksToBounds = YES;
    
    CALayer *grayLine12 = [CALayer layer];
    grayLine12.frame = CGRectMake(0, 30, _editView.bounds.size.width, 1.0f);
    grayLine12.backgroundColor = grayColor.CGColor;
    [_editView.layer addSublayer:grayLine12];
    
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
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_contact_bg.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:buttonImage.size.width/2 topCapHeight:buttonImage.size.height/2];
    [_deleteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [_cancelButton.titleLabel setFont:fontBold14px];
    [_doneButton.titleLabel setFont:fontBold14px];
    [_deleteButton.titleLabel setFont:font14px];
    
    _titleLabel.font = fontBold18px;
    _areaField.font = font26px;
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [_areaField becomeFirstResponder];
}

#pragma mark - Keyboard

-(void)keyboardWillShow
{
    // move controls up only for comments and note
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect frame = _controlsView.frame;
                         frame.origin.y -= _editMode?100.0f:54.0f;
                         _controlsView.frame = frame;
                     }];
}

-(void)keyboardWillHide
{
    // move controls up only for comments and note
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect frame = _controlsView.frame;
                         frame.origin.y += _editMode?100.0f:54.0f;
                         _controlsView.frame = frame;
                     }];
}

-(void)setSampleMeasurement:(SampleMeasurement *)sampleMeasurement
{
    _sampleMeasurement = sampleMeasurement;    
    _areaField.text = [_sampleMeasurement.sampleMeasurement_OnFlowRate stringValue];
}

-(void)setMeasurementFields:(MeasurementFields *)measurementFields
{
    _measurementFields = measurementFields;
    _areaField.text = [measurementFields.sampleMeasurement_OnFlowRate stringValue];
}

-(void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    if(!editMode)
    {
        _titleLabel. text = @"Create Measurement";
        [_deleteButton removeFromSuperview];
        CGRect frame = _controlsView.frame;
        frame.size.height = 164.0f;
        _controlsView.frame = frame;
    }
}

-(IBAction)donePressed:(id)sender
{
    if(_editMode)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(measurementWipeDonePressed:)])
        {
            [self endEditing:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            // TODO set area
            [_delegate measurementWipeDonePressed:_sampleMeasurement];
        }
    }
    else
    {
        if(_delegate && [_delegate respondsToSelector:@selector(measurementWipeAddPressed:)])
        {
            [self endEditing:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            // TODO set area
            [_delegate measurementWipeAddPressed:_measurementFields];
        }
    }
}

-(IBAction)cancelPressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(measurementWipeCancelPressed)])
    {
        [self endEditing:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_delegate measurementWipeCancelPressed];
    }
}

-(IBAction)deletePressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(measurementWipeDeletePressed:)])
    {
        [self endEditing:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_delegate measurementWipeDeletePressed:_sampleMeasurement];
    }
}

/*// Only override drawRect: if you perform custom drawing.
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
*/

@end
