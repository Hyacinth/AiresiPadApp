//
//  LoginFieldsView.h
//  aires
//
//  Created by Mani on 4/25/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginFieldsDelegate;

@interface LoginFieldsView : UIView <UITextFieldDelegate>
{
    CALayer *midlineLayer;
    UITextField *userField;
    UITextField *passField;
    UIActivityIndicatorView *spinner;
    UILabel *messageLabel;
    id<LoginFieldsDelegate> delegate;
}

@property(nonatomic) id<LoginFieldsDelegate> delegate;

-(void)setUserFieldText:(NSString *)user;
-(void)setPassFieldText:(NSString *)pass;
-(NSString*)getUserFieldText;
-(NSString*)getPassFieldText;
-(void)showLoadingMessage:(NSString*)message;
-(void)hideLoadingMessage;
-(void)changeLoadingMessage:(NSString*)message;
@end

@protocol LoginFieldsDelegate <NSObject>
-(void)keyboardReturnedOnPasswordField;
@end
