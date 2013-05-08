//
//  TextEditView.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextEditProtocol;

@interface TextEditView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, retain) id<TextEditProtocol> delegate;

-(void)setText:(NSString*)text;
-(void)setTitle:(NSString*)title;

@end

@protocol TextEditProtocol <NSObject>

-(void)textEditDonePressed:(NSString*)text;
-(void)textEditCancelPressed;

@end
