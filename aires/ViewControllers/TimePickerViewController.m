//
//  TimePickerViewController.m
//  aires
//
//  Created by Mani on 5/7/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "TimePickerViewController.h"

@interface TimePickerViewController ()

@end

@implementation TimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return 12;
        }
            break;
            
        case 1:
        {
            return 60;
        }
            break;
            
        case 2:
        {
            return 2;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return [NSString stringWithFormat:@"%d", row+1];
        }
            break;
            
        case 1:
        {
            return [NSString stringWithFormat:@"%d", row+1];
        }
            break;
            
        case 2:
        {
            return row==0?@"AM":@"PM";
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *hour = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
    NSString *minute = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:1] forComponent:1];
    NSString *meridian = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:2] forComponent:2];
    
    if(_delegate && [_delegate respondsToSelector:@selector(timePickerChanged:)])
    {
        [_delegate timePickerChanged:[NSString stringWithFormat:@"%@:%@%@ %@", hour, [minute intValue]<10?@"0":@"", minute, meridian]];
    }
}

@end