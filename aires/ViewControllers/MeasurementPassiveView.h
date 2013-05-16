//
//  MeasurementPassiveView.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerViewController.h"

@protocol MeasurementPassiveProtocol;

@class SampleMeasurement;
@class MeasurementFields;

@interface MeasurementPassiveView : UIView<UIPopoverControllerDelegate, TimePickerProtocol>

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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *onTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *offTimeValueLabel;

@property (nonatomic, retain) id<MeasurementPassiveProtocol> delegate;
@property (nonatomic, retain) SampleMeasurement *sampleMeasurement;
@property (nonatomic, retain) MeasurementFields *measurementFields;

@end

@protocol MeasurementPassiveProtocol <NSObject>

-(void)measurementPassiveAddPressed:(MeasurementFields*)measurement;
-(void)measurementPassiveDonePressed:(SampleMeasurement*)measurement;
-(void)measurementPassiveCancelPressed;
-(void)measurementPassiveDeletePressed:(SampleMeasurement*)measurement;

@end
