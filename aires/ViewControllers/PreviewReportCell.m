//
//  PreviewReportCell.m
//  aires
//
//  Created by Gautham on 02/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "PreviewReportCell.h"

@implementation PreviewReportCell
@synthesize SampleID;
@synthesize DateSampled;
@synthesize SampleType;
@synthesize DeviceType;
@synthesize AirVolume;
@synthesize PassiveMonitors;
@synthesize Area;
@synthesize AnalysisRequested;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        font12Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
        [SampleID setFont:font12Regular];
        [DateSampled setFont:font12Regular];
        [SampleType setFont:font12Regular];
        [DeviceType setFont:font12Regular];
        [AirVolume setFont:font12Regular];
        [PassiveMonitors setFont:font12Regular];
        [Area setFont:font12Regular];
        [AnalysisRequested setFont:font12Regular];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCellBackground:(UIColor *)color
{
    [SampleID setBackgroundColor:color];
    [DateSampled setBackgroundColor:color];
    [SampleType setBackgroundColor:color];
    [DeviceType setBackgroundColor:color];
    [AirVolume setBackgroundColor:color];
    [PassiveMonitors setBackgroundColor:color];
    [Area setBackgroundColor:color];
    [AnalysisRequested setBackgroundColor:color];

}

-(void) setCellTextColor:(UIColor *)color
{
    [SampleID setTextColor:color];
    [DateSampled setTextColor:color];
    [SampleType setTextColor:color];
    [DeviceType setTextColor:color];
    [AirVolume setTextColor:color];
    [PassiveMonitors setTextColor:color];
    [Area setTextColor:color];
    [AnalysisRequested setTextColor:color];
    
}

@end
