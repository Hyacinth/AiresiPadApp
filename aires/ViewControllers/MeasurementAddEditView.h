//
//  MeasurementAddEditView.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerViewController.h"
#import "TextInsetLabel.h"

@protocol MeasurementAddEditProtocol;

@interface MeasurementFields : NSObject

@property (nonatomic, retain) NSNumber * sampleMeasurement_OffFlowRate;
@property (nonatomic, retain) NSString * sampleMeasurement_OffTime;
@property (nonatomic, retain) NSNumber * sampleMeasurement_OnFlowRate;
@property (nonatomic, retain) NSString * sampleMeasurement_OnTime;

@end

@class SampleMeasurement;

@interface MeasurementAddEditView : UIView<UIPopoverControllerDelegate, TimePickerProtocol>

@property (nonatomic) BOOL editMode;

@property (retain, nonatomic) NSMutableDictionary *onTimeDictionary;
@property (retain, nonatomic) NSMutableDictionary *offTimeDictionary;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
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
@property (weak, nonatomic) IBOutlet TextInsetLabel *onTimeValueLabel;
@property (weak, nonatomic) IBOutlet TextInsetLabel *offTimeValueLabel;

@property (nonatomic, retain) id<MeasurementAddEditProtocol> delegate;
@property (nonatomic, retain) SampleMeasurement *sampleMeasurement;
@property (nonatomic, retain) MeasurementFields *measurementFields;
@property (nonatomic, retain) NSString *deviceType;

@end

@protocol MeasurementAddEditProtocol <NSObject>

-(void)measurementsAddPressed:(MeasurementFields*)measurement;
-(void)measurementsDonePressed:(SampleMeasurement*)measurement;
-(void)measurementsCancelPressed;
-(void)measurementsDeletePressed:(SampleMeasurement*)measurement;

@end
