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
    _controlsView.layer.borderColor = [UIColor blackColor].CGColor;
    _controlsView.layer.borderWidth = 1.0f;
    _controlsView.layer.cornerRadius = 5.0f;
    //_controlsView.layer.masksToBounds = YES;
    
    UIColor *colorOne = [UIColor whiteColor];
    UIColor *colorTwo = [UIColor colorWithRed:(227/255.0)  green:(241/255.0)  blue:(251/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    [_controlsView.layer insertSublayer:headerLayer atIndex:0];
    
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
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [_textView becomeFirstResponder];
}

#pragma mark - Keyboard

-(void)keyboardWillShow
{
    // move controls up only for comments and notes
    if(_textDetailType != Edit_Comments && _textDetailType != Edit_Notes)
        return;

    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect frame = _controlsView.frame;
                         frame.origin.y -= 65.0f;
                         _controlsView.frame = frame;
                     }];
}

-(void)keyboardWillHide
{
    // move controls up only for comments and note
    if(_textDetailType != Edit_Comments && _textDetailType != Edit_Notes)
        return;

    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.y += 65.0f;
                         _controlsView.frame = frame;
                     }];
}

-(void)setTextDetailType:(TextDetailType)textDetailType
{
    _textDetailType = textDetailType;
    
    NSString* title = @"";
    CGFloat height = 0;
        
    switch (textDetailType) {
        case Edit_EmployeeName:
        {
            title = @"Edit Employee Name";
            height = 100.0f;
        }
            break;
        case Edit_EmployeeJob:
        {
            title = @"Edit Employee Job";
            height = 100.0f;
        }
            break;
        case Edit_OperationalArea:
        {
            title = @"Edit Operational Area";
            height = 100.0f;
        }
            break;
        case Edit_Notes:
        {
            title = @"Edit Notes";
            height = 164.0f;
        }
            break;
        case Edit_Comments:
        {
            title = @"Edit Comments";
            height = 164.0f;
        }
            break;
            
        default:
            break;
    }
    
    [self setTitle:title];
    
    CGRect frame = _controlsView.frame;
    frame.size.height = height;
    _controlsView.frame = frame;
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
    if(_delegate && [_delegate respondsToSelector:@selector(textEditDonePressed:forDetailType:)])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_delegate textEditDonePressed:_textView.text forDetailType:_textDetailType];
    }
}

-(IBAction)cancelPressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(measurementsCancelPressed)])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_delegate textEditCancelPressed];
    }
}

@end