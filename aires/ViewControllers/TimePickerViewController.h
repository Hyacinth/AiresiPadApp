//
//  TimePickerViewController.h
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePickerProtocol;

@interface TimePickerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) id<TimePickerProtocol> delegate;

-(void)updatePicker:(NSDictionary*)dict;

@end

@protocol TimePickerProtocol <NSObject>

-(void)timePickerChanged:(NSDictionary*)timeDict;

@end
