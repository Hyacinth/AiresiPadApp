//
//  MeasurementActiveView.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerViewController.h"

@protocol MeasurementActiveProtocol;

@class SampleMeasurement;
@class MeasurementFields;

@interface MeasurementActiveView : UIView<UIPopoverControllerDelegate, TimePickerProtocol, UITextFieldDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel *onTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *offTimeValueLabel;

@property (nonatomic, retain) id<MeasurementActiveProtocol> delegate;
@property (nonatomic, retain) SampleMeasurement *sampleMeasurement;
@property (nonatomic, retain) MeasurementFields *measurementFields;

@end

@protocol MeasurementActiveProtocol <NSObject>

-(void)measurementActiveAddPressed:(MeasurementFields*)measurement;
-(void)measurementActiveDonePressed:(SampleMeasurement*)measurement;
-(void)measurementActiveCancelPressed;
-(void)measurementActiveDeletePressed:(SampleMeasurement*)measurement;

@end
