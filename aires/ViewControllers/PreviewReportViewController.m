//
//  PreviewReportViewController.m
//  aires
//
//  Created by Gautham on 01/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "PreviewReportViewController.h"
#import "PreviewReportCell.h"
#import "Sample.h"
#import "AiresSingleton.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface PreviewReportViewController ()

@end

@implementation PreviewReportViewController
@synthesize currentProject;

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
    if(!font12Regular)
        font12Regular = [[UIFont alloc] init];
    font12Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    if(!font14Regular)
        font14Regular = [[UIFont alloc] init];
    font14Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    if(!font14Bold)
        font14Bold = [[UIFont alloc] init];
    font14Bold = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    if(!font16Regular)
        font16Regular = [[UIFont alloc] init];
    font16Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:16.0f];
    if(!font16Bold)
        font16Bold = [[UIFont alloc] init];
    font16Bold = [UIFont fontWithName:@"ProximaNova-Bold" size:16.0f];
    if(!font28Bold)
        font28Bold = [[UIFont alloc] init];
    font28Bold = [UIFont fontWithName:@"ProximaNova-Bold" size:28.0f];
    if(!font48Bold)
        font48Bold = [[UIFont alloc] init];
    font48Bold = [UIFont fontWithName:@"ProximaNova-Bold" size:48.0f];
    
    UIImage *buttonNorImage = [[UIImage imageNamed:@"btn_navbar_nor"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 15)];
    UIImage *buttonSelImage = [[UIImage imageNamed:@"btn_navbar_pressed"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 15)];
    
    if(!self.closeButton)
        self.closeButton = [[UIButton alloc] init];
    [self.closeButton setBackgroundImage:buttonNorImage forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:buttonSelImage forState:UIControlStateHighlighted];
    [self.closeButton.titleLabel setFont:font14Bold];
    
    if(!self.unlockButton)
        self.unlockButton = [[UIButton alloc] init];
    [self.unlockButton setBackgroundImage:buttonNorImage forState:UIControlStateNormal];
    [self.unlockButton setBackgroundImage:buttonSelImage forState:UIControlStateHighlighted];
    [self.unlockButton.titleLabel setFont:font14Bold];
    
    if(!self.sendMailButton)
        self.sendMailButton = [[UIButton alloc] init];
    [self.sendMailButton setBackgroundImage:buttonNorImage forState:UIControlStateNormal];
    [self.sendMailButton setBackgroundImage:buttonSelImage forState:UIControlStateHighlighted];
    
    if(!self.dateLabel)
        self.dateLabel = [[UILabel alloc] init];
    [self.dateLabel setFont:font48Bold];
    if(!self.dayLabel)
        self.dayLabel = [[UILabel alloc] init];
    [self.dayLabel setFont:font16Bold];
    if(!self.monthLabel)
        self.monthLabel = [[UILabel alloc] init];
    [self.monthLabel setFont:font16Regular];
    if(!self.TTLabel)
        self.TTLabel = [[UILabel alloc] init];
    [self.TTLabel setFont:font12Regular];
    if(!self.labLabel)
        self.labLabel = [[UILabel alloc] init];
    [self.labLabel setFont:font12Regular];
    if(!self.qcLabel)
        self.qcLabel = [[UILabel alloc] init];
    [self.qcLabel setFont:font12Regular];
    if(!self.cpLabel)
        self.cpLabel = [[UILabel alloc] init];
    [self.cpLabel setFont:font12Regular];
    if(!self.ttValuelabel)
        self.ttValuelabel = [[UILabel alloc] init];
    [self.ttValuelabel setFont:font14Bold];
    if(!self.labValueLabel)
        self.labValueLabel = [[UILabel alloc] init];
    [self.labValueLabel setFont:font14Bold];
    if(!self.qcValueLabel)
        self.qcValueLabel = [[UILabel alloc] init];
    [self.qcValueLabel setFont:font14Bold];
    if(!self.qpValueLabel)
        self.qpValueLabel = [[UILabel alloc] init];
    [self.qpValueLabel setFont:font14Bold];
    if(!self.projectNameLabel)
        self.projectNameLabel = [[UILabel alloc] init];
    [self.projectNameLabel setFont:font28Bold];
    if(!self.projectDescLabel)
        self.projectDescLabel = [[UILabel alloc] init];
    [self.projectDescLabel setFont:font14Regular];
    
    [self updateReport:currentProject];

    // Do any additional setup after loading the view from its nib.
}

-(void)updateReport:(Project *)project
{
    if(!samplesArray)
        samplesArray = [[NSArray alloc] init];
    
    samplesArray = [[mSingleton getPersistentStoreManager] getSampleforProject:currentProject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *stringFromDate = [formatter stringFromDate:currentProject.project_DateOnsite];
    
    [self.dateLabel setText:nil];
    [self.dayLabel setText:nil];
    [self.monthLabel setText:nil];
    
    stringFromDate = [formatter stringFromDate:currentProject.project_TurnAroundTime];
    [self.ttValuelabel setText:stringFromDate];
    [self.labValueLabel setText:currentProject.project_LabName];
    [self.qcValueLabel setText:currentProject.project_QCPerson];
    [self.qpValueLabel setText:[NSString stringWithFormat:@"%@ %@",currentProject.project_ContactFirstName,currentProject.project_ContactLastName]];
    [self.projectNameLabel setText:currentProject.project_ProjectNumber];
    [self.projectDescLabel setText:currentProject.project_ProjectDescription];
    [self.projectDetailsTable reloadData];
}

- (IBAction)onSendEmail:(id)sender
{
    
}

- (IBAction)onClosePreview:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onUnlockProject:(id)sender
{
    
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ([samplesArray count] + 15);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"PreviewReportCell";
	
	PreviewReportCell *cell = (PreviewReportCell *)[tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PreviewReportCell"owner:self options:nil];
        cell = (PreviewReportCell *)[topLevelObjects objectAtIndex:0];
	}
    
    UIColor *textColor = [UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1];
    [cell setCellTextColor:textColor];
    
    if (indexPath.row == 0)
    {
        UIColor *cellColor = [UIColor colorWithRed:0 green:138.0f/255.0f blue:1.0f alpha:1];
        [cell setCellBackground:cellColor];
        textColor = [UIColor whiteColor];
        [cell setCellTextColor:textColor];
    }
    else if (indexPath.row%2 == 0)
    {
        UIColor *cellColor = [UIColor colorWithRed:227.0f/255.0f green:241.0f/255.0f blue:255.0f/255.0f alpha:1];
        [cell setCellBackground:cellColor];
    }
    
    if (indexPath.row != 0) {
        Sample *currentSample = [samplesArray objectAtIndex:indexPath.row];
        cell.SampleID.text = [currentSample.sample_SampleId stringValue];
        cell.DateSampled.text = nil;
        cell.SampleType.text = nil;
        cell.DeviceType.text = currentSample.sample_DeviceTypeName;
        cell.AirVolume.text = [currentSample.airesSampleTotalMeasurement.sampleTotalMeasurement_TotalVolume stringValue];
        cell.PassiveMonitors.text = [currentSample.airesSampleTotalMeasurement.sampleTotalMeasurement_TotalMinutes stringValue];
        cell.Area.text = [currentSample.airesSampleTotalMeasurement.sampleTotalMeasurement_TotalArea stringValue];
        cell.AnalysisRequested.text = nil;
    }
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCloseButton:nil];
    [self setUnlockButton:nil];
    [self setSendMailButton:nil];
    [self setBaseScrollView:nil];
    [self setDateLabel:nil];
    [self setDayLabel:nil];
    [self setMonthLabel:nil];
    [self setTTLabel:nil];
    [self setLabLabel:nil];
    [self setQcLabel:nil];
    [self setCpLabel:nil];
    [self setTtValuelabel:nil];
    [self setLabValueLabel:nil];
    [self setQcValueLabel:nil];
    [self setQpValueLabel:nil];
    [self setProjectNameLabel:nil];
    [self setProjectDescLabel:nil];
    [self setProjectDetailsTable:nil];
    [super viewDidUnload];
}
@end