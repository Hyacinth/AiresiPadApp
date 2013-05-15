//
//  TextEditView.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextEditProtocol;

typedef enum TEXT_DETAIL_TYPE
{
    Edit_EmployeeName,
    Edit_EmployeeJob,
    Edit_OperationalArea,
    Edit_Notes,
    Edit_Comments,
}TextDetailType;

@interface TextEditView : UIView

@property (nonatomic) TextDetailType textDetailType;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, retain) id<TextEditProtocol> delegate;

-(void)setText:(NSString*)text;
-(void)setTitle:(NSString*)title;

@end

@protocol TextEditProtocol <NSObject>

-(void)textEditDonePressed:(NSString*)text forDetailType:(TextDetailType)detailType;
-(void)textEditCancelPressed;

@end
