//
//  MeasurementAddEditView.m
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "MeasurementAddEditView.h"
#import "SampleMeasurement.h"
#import "AiresSingleton.h"
#import <QuartzCore/QuartzCore.h>

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@implementation MeasurementFields

@end

@interface MeasurementAddEditView ()
{
    UIPopoverController *popover;
    BOOL editingOnTime;
}
@end

@implementation MeasurementAddEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControls];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initControls];
}

-(void)initControls
{
    _onTimeDictionary = [[NSMutableDictionary alloc] init];
    _offTimeDictionary = [[NSMutableDictionary alloc] init];
    // Initialization code
    
    UIColor *grayColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f];
    UIFont *font14px = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    UIFont *font26px = [UIFont fontWithName:@"ProximaNova-Regular" size:26.0f];
    UIFont *fontBold18px = [UIFont fontWithName:@"ProximaNova-Bold" size:18.0f];
    UIFont *fontBold14px = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    _editView.layer.borderColor = grayColor.CGColor;
    _editView.layer.borderWidth = 1.0f;
    _editView.layer.cornerRadius = 5.0f;
    _editView.layer.masksToBounds = YES;
    
    CALayer *grayLine9 = [CALayer layer];
    grayLine9.frame = CGRectMake(220, 0, 1.0f, _editView.bounds.size.height);
    grayLine9.backgroundColor = grayColor.CGColor;
    [_editView.layer addSublayer:grayLine9];
    
    CALayer *grayLine10 = [CALayer layer];
    grayLine10.frame = CGRectMake(441, 0, 1.0f, _editView.bounds.size.height);
    grayLine10.backgroundColor = grayColor.CGColor;
    [_editView.layer addSublayer:grayLine10];
    
    CALayer *grayLine11 = [CALayer layer];
    grayLine11.frame = CGRectMake(662, 0, 1.0f, _editView.bounds.size.height);
    grayLine11.backgroundColor = grayColor.CGColor;
    [_editView.layer addSublayer:grayLine11];
    
    CALayer *grayLine12 = [CALayer layer];
    grayLine12.frame = CGRectMake(0, 30, _editView.bounds.size.width, 1.0f);
    grayLine12.backgroundColor = grayColor.CGColor;
    [_editView.layer addSublayer:grayLine12];
    
    UIImage *bgimage = [UIImage imageNamed:@"btn_navbar_nor.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_doneButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"btn_navbar_pressed.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_doneButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    bgimage = [UIImage imageNamed:@"navbar_back_nor.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_cancelButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"navbar_back_pressed.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_cancelButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_contact_bg.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:buttonImage.size.width/2 topCapHeight:buttonImage.size.height/2];
    [_deleteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [_cancelButton.titleLabel setFont:fontBold14px];
    [_doneButton.titleLabel setFont:fontBold14px];
    [_deleteButton.titleLabel setFont:font14px];
    
    _titleLabel.font = fontBold18px;
    
    _onTimeLabel.font = fontBold14px;
    _offTimeLabel.font = fontBold14px;
    _onFlowRateLabel.font = fontBold14px;
    _offFlowRateLabel.font = fontBold14px;
    
    _onTimeValueLabel.font = font26px;
    _offTimeValueLabel.font = font26px;
    _onFlowRateField.font = font26px;
    _offFlowRateField.font = font26px;
    
    _onTimeValueLabel.userInteractionEnabled = YES;
    _offTimeValueLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *onTimeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTimeTapped)];
    [_onTimeValueLabel addGestureRecognizer:onTimeTapGesture];
    
    UITapGestureRecognizer *offTimeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offTimeTapped)];
    [_offTimeValueLabel addGestureRecognizer:offTimeTapGesture];
}

-(void)setSampleMeasurement:(SampleMeasurement *)sampleMeasurement
{
    _sampleMeasurement = sampleMeasurement;
    
    NSDictionary *onTimeComponents = [mSingleton getDateComponentsforString:_sampleMeasurement.sampleMeasurement_OnTime];
    NSString *onTimeString = [NSString stringWithFormat:@"%@:%@ %@", [onTimeComponents valueForKey:@"hour"], [onTimeComponents valueForKey:@"minute"], [onTimeComponents valueForKey:@"meridian"]];
    
    NSDictionary *offTimeComponents = [mSingleton getDateComponentsforString:_sampleMeasurement.sampleMeasurement_OffTime];
    NSString *offTimeString = [NSString stringWithFormat:@"%@:%@ %@", [offTimeComponents valueForKey:@"hour"], [offTimeComponents valueForKey:@"minute"], [onTimeComponents valueForKey:@"meridian"]];
    
    _onTimeValueLabel.text = onTimeString;
    _offTimeValueLabel.text = offTimeString;
    _onFlowRateField.text = [_sampleMeasurement.sampleMeasurement_OnFlowRate stringValue];
    _offFlowRateField.text = [_sampleMeasurement.sampleMeasurement_OffFlowRate stringValue];
    
    [_onTimeDictionary removeAllObjects];
    [_onTimeDictionary addEntriesFromDictionary:onTimeComponents];
    [_offTimeDictionary removeAllObjects];
    [_offTimeDictionary addEntriesFromDictionary:offTimeComponents];
}

-(void)setMeasurementFields:(MeasurementFields *)measurementFields
{
    _measurementFields = measurementFields;
    
    NSDictionary *onTimeComponents = [mSingleton getDateComponentsforString:_measurementFields.sampleMeasurement_OnTime];
    NSString *onTimeString = [NSString stringWithFormat:@"%@:%@ %@", [onTimeComponents valueForKey:@"hour"], [onTimeComponents valueForKey:@"minute"], [onTimeComponents valueForKey:@"meridian"]];
    
    NSDictionary *offTimeComponents = [mSingleton getDateComponentsforString:_measurementFields.sampleMeasurement_OffTime];
    NSString *offTimeString = [NSString stringWithFormat:@"%@:%@ %@", [offTimeComponents valueForKey:@"hour"], [offTimeComponents valueForKey:@"minute"], [onTimeComponents valueForKey:@"meridian"]];
    
    _onTimeValueLabel.text = onTimeString;
    _offTimeValueLabel.text = offTimeString;
    _onFlowRateField.text = [measurementFields.sampleMeasurement_OnFlowRate stringValue];
    _offFlowRateField.text = [measurementFields.sampleMeasurement_OffFlowRate stringValue];
}

-(void)onTimeTapped
{
    editingOnTime = YES;
    
    TimePickerViewController *timePickerVC = [[TimePickerViewController alloc] initWithNibName:@"TimePickerViewController" bundle:nil];
    timePickerVC.delegate = self;
    
    if(!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:timePickerVC];
    else
        [popover setContentViewController:timePickerVC];
    
    [popover setPopoverContentSize:CGSizeMake(200, 216)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:_onTimeValueLabel.bounds inView:_onTimeValueLabel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

    [timePickerVC updatePicker:_onTimeDictionary];
}

-(void)offTimeTapped
{
    editingOnTime = NO;
    
    TimePickerViewController *timePickerVC = [[TimePickerViewController alloc] initWithNibName:@"TimePickerViewController" bundle:nil];
    timePickerVC.delegate = self;
    
    if(!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:timePickerVC];
    else
        [popover setContentViewController:timePickerVC];
    
    [popover setPopoverContentSize:CGSizeMake(200, 216)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:_offTimeValueLabel.bounds inView:_offTimeValueLabel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    [timePickerVC updatePicker:_offTimeDictionary];
}

-(void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    if(!editMode)
    {
        _titleLabel. text = @"Create Measurement";
        [_deleteButton removeFromSuperview];
        CGRect frame = self.frame;
        frame.size.height = 164.0f;
        self.frame = frame;
        self.center = self.superview.center;
    }
}

-(IBAction)donePressed:(id)sender
{
    if(_editMode)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(measurementsDonePressed:)])
        {
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
            
            NSUInteger hour = [[_onTimeDictionary objectForKey:@"hour"] integerValue];
            hour = [[_onTimeDictionary objectForKey:@"meridian"] isEqualToString:@"PM"]? hour+12:hour;
            [components setHour:hour];
            [components setMinute:[[_onTimeDictionary objectForKey:@"minute"] integerValue]];
            NSDate *localDate = [calendar dateFromComponents:components];
            NSString *dateStr = [self getUTCFormateDate:localDate];            
            _sampleMeasurement.sampleMeasurement_OnTime = dateStr;
            
            hour = [[_offTimeDictionary objectForKey:@"hour"] integerValue];
            hour = [[_offTimeDictionary objectForKey:@"meridian"] isEqualToString:@"PM"]? hour+12:hour;
            [components setHour:hour];
            [components setMinute:[[_offTimeDictionary objectForKey:@"minute"] integerValue]];
            localDate = [calendar dateFromComponents:components];
            dateStr = [self getUTCFormateDate:localDate];
            _sampleMeasurement.sampleMeasurement_OffTime = dateStr;
            
            _sampleMeasurement.sampleMeasurement_OnFlowRate = [NSNumber numberWithInt:[_onFlowRateField.text intValue]];
            _sampleMeasurement.sampleMeasurement_OffFlowRate = [NSNumber numberWithInt:[_offFlowRateField.text intValue]];
            
            [_delegate measurementsDonePressed:_sampleMeasurement];
        }
    }
    else
    {
        if(_delegate && [_delegate respondsToSelector:@selector(measurementsAddPressed:)])
        {
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
            
            [components setHour:[[_onTimeDictionary objectForKey:@"hour"] integerValue]];
            [components setMinute:[[_onTimeDictionary objectForKey:@"minute"] integerValue]];
            NSDate *localDate = [calendar dateFromComponents:components];
            NSString *dateStr = [self getUTCFormateDate:localDate];
            _measurementFields.sampleMeasurement_OnTime = dateStr;
            
            [components setHour:[[_offTimeDictionary objectForKey:@"hour"] integerValue]];
            [components setMinute:[[_offTimeDictionary objectForKey:@"minute"] integerValue]];
            localDate = [calendar dateFromComponents:components];
            dateStr = [self getUTCFormateDate:localDate];
            _measurementFields.sampleMeasurement_OffTime = dateStr;

            _measurementFields.sampleMeasurement_OnFlowRate = [NSNumber numberWithInt:[_onFlowRateField.text intValue]];
            _measurementFields.sampleMeasurement_OffFlowRate = [NSNumber numberWithInt:[_offFlowRateField.text intValue]];
            
            [_delegate measurementsAddPressed:_measurementFields];
        }
    }
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

-(IBAction)cancelPressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(measurementsCancelPressed)])
    {
        [_delegate measurementsCancelPressed];
    }
}

-(IBAction)deletePressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(measurementsDeletePressed:)])
    {
        [_delegate measurementsDeletePressed:_sampleMeasurement];
    }
}

#pragma mark - TimePickerProtocol

-(void)timePickerChanged:(NSDictionary*)timeDict
{
    NSString *hour = [timeDict objectForKey:@"hour"];
    NSString *minute = [timeDict objectForKey:@"minute"];
    NSString *meridian = [timeDict objectForKey:@"meridian"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@%@ %@", hour, [minute intValue]<10?@"0":@"", minute, meridian];
    
    if(editingOnTime)
    {
        _onTimeValueLabel.text= timeStr;
        [_onTimeDictionary removeAllObjects];
        [_onTimeDictionary addEntriesFromDictionary:timeDict];
    }
    else
    {
        _offTimeValueLabel.text= timeStr;
        [_offTimeDictionary removeAllObjects];
        [_offTimeDictionary addEntriesFromDictionary:timeDict];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Create thegradient
    CGFloat colors [] = {
        1.0f, 1.0f, 1.0f, 1.0f,
        227.0f/255.0f, 241.0f/255.0f, 251.0f/255.0f, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // Get the current context so we can draw.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Set the fill color to white.
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f].CGColor);
}


@end
