//
//  MeasurementAddEditView.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerViewController.h"

@protocol MeasurementAddEditProtocol;

@interface MeasurementAddEditView : UIView<UIPopoverControllerDelegate, TimePickerProtocol>

@property (nonatomic) BOOL editMode;

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *onTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *offTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *onFlowRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *offFlowRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *onFlowRateField;
@property (weak, nonatomic) IBOutlet UITextField *offFlowRateField;
@property (weak, nonatomic) IBOutlet UILabel *onTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *offTimeValueLabel;

@property (nonatomic, retain) id<MeasurementAddEditProtocol> delegate;

@end

@protocol MeasurementAddEditProtocol <NSObject>

-(void)measurementsDonePressed;
-(void)measurementsCancelPressed;
-(void)measurementsDeletePressed;

@end
