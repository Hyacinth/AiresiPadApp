//
//  PreviewReportCell.h
//  aires
//
//  Created by Gautham on 02/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewReportCell : UITableViewCell
{
    UIFont *font12Regular;
    IBOutlet UILabel *SampleID;
    IBOutlet UILabel *DateSampled;
    IBOutlet UILabel *SampleType;
    IBOutlet UILabel *DeviceType;
    IBOutlet UILabel *AirVolume;
    IBOutlet UILabel *PassiveMonitors;
    IBOutlet UILabel *Area;
    IBOutlet UILabel *AnalysisRequested;
}

@property(nonatomic, strong) UILabel *SampleID;
@property(nonatomic, strong) UILabel *DateSampled;
@property(nonatomic, strong) UILabel *SampleType;
@property(nonatomic, strong) UILabel *DeviceType;
@property(nonatomic, strong) UILabel *AirVolume;
@property(nonatomic, strong) UILabel *PassiveMonitors;
@property(nonatomic, strong) UILabel *Area;
@property(nonatomic, strong) UILabel *AnalysisRequested;

-(void) setCellBackground:(UIColor *)color;
-(void) setCellTextColor:(UIColor *)color;

@end
