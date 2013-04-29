//
//  LoginFieldsView.m
//  aires
//
//  Created by Mani on 4/25/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "LoginFieldsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginFieldsView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 8.0f;
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        layer.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, 1.0f);
        [self.layer addSublayer:layer];
        
        userField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
        userField.backgroundColor = [UIColor blackColor];
        [userField setPlaceholder:@"Username"];
        [userField setUserInteractionEnabled:TRUE];
        [userField setDelegate:self];
        [userField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [userField setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0f]];
        [userField setReturnKeyType:UIReturnKeyNext];
        [self addSubview:userField];
        
        passField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2)];
        passField.backgroundColor = [UIColor blackColor];
        [passField setSecureTextEntry:TRUE];
        [passField setPlaceholder:@"Password"];
        [passField setUserInteractionEnabled:TRUE];
        [passField setDelegate:self];
        [passField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [passField setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0f]];
        [passField setReturnKeyType:UIReturnKeyGo];
        [self addSubview:passField];
    }
    return self;
}

-(void)awakeFromNib
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    
    midlineLayer = [CALayer layer];
    midlineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    midlineLayer.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, 1.0f);
    [self.layer addSublayer:midlineLayer];
    
    userField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height/2)];
    [userField setPlaceholder:@"Username"];
    [userField setDelegate:self];
    [userField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userField setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:16.0f]];
    [userField setReturnKeyType:UIReturnKeyNext];
    [userField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    userField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self addSubview:userField];
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2, self.frame.size.width-20, self.frame.size.height/2)];
    [passField setSecureTextEntry:TRUE];
    [passField setPlaceholder:@"Password"];
    [passField setDelegate:self];
    [passField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passField setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:16.0f]];
    [passField setReturnKeyType:UIReturnKeyGo];
    [passField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    passField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self addSubview:passField];
}

-(void)setUserFieldText:(NSString *)user
{
    [userField setText:user];
}

-(void)setPassFieldText:(NSString *)pass
{
    [passField setText:pass];
}

-(NSString*)getUserFieldText
{
    return userField.text;
}

-(NSString*)getPassFieldText
{
    return passField.text;
}

-(void)showLoadingMessage:(NSString*)message
{
    [UIView animateWithDuration:0.15
                     animations:^{
                         midlineLayer.hidden = YES;
                         userField.alpha = 0;
                         passField.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                         spinner.frame = CGRectMake(20, (self.frame.size.height/2)-12, 24, 24);
                         [spinner startAnimating];
                         [self addSubview:spinner];
                         
                         messageLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(60, 0, self.frame.size.width-30, self.frame.size.height) ];
                         messageLabel.backgroundColor = [UIColor clearColor];
                         messageLabel.textAlignment =  UITextAlignmentLeft;
                         messageLabel.textColor = [UIColor blackColor];
                         messageLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:(18.0f)];
                         messageLabel.text = message;
                         [self addSubview:messageLabel];
                     }];
}

-(void)hideLoadingMessage
{
    [spinner removeFromSuperview];
    [messageLabel removeFromSuperview];
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         midlineLayer.hidden = NO;
                         userField.alpha = 1.0f;
                         passField.alpha = 1.0f;
                     }];
}

-(void)changeLoadingMessage:(NSString*)message
{
    if(messageLabel)
    {
        messageLabel.text = message;
    }
}

#pragma mark-
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userField)
    {
        [passField becomeFirstResponder];
    }
    else
    {
        if(delegate && [delegate respondsToSelector:@selector(keyboardReturnedOnPasswordField)])
        {
            [delegate keyboardReturnedOnPasswordField];
        }
    }
    return TRUE;
}

@end