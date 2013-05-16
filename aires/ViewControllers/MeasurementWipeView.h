//
//  MeasurementWipeView.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeasurementWipeProtocol;

@class SampleMeasurement;
@class MeasurementFields;

@interface MeasurementWipeView : UIView<UITextFieldDelegate>

@property (nonatomic) BOOL editMode;

@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *areaField;

@property (nonatomic, retain) id<MeasurementWipeProtocol> delegate;
@property (nonatomic, retain) SampleMeasurement *sampleMeasurement;
@property (nonatomic, retain) MeasurementFields *measurementFields;

@end

@protocol MeasurementWipeProtocol <NSObject>

-(void)measurementWipeAddPressed:(MeasurementFields*)measurement;
-(void)measurementWipeDonePressed:(SampleMeasurement*)measurement;
-(void)measurementWipeCancelPressed;
-(void)measurementWipeDeletePressed:(SampleMeasurement*)measurement;

@end
