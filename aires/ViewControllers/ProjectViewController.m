//
//  ProjectViewController.m
//  AiresConsulting
//
//  Created by Mani on 4/22/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectDetailView.h"
#import "SampleTileView.h"
#import "Sample.h"
#import "AiresSingleton.h"
#import "ChemicalsListViewController.h"
#import "PPEListViewController.h"
#import "TextInsetLabel.h"
#import "MeasurementFields.h"

#define FADE_VIEW_TAG 999

#define MEASUREMENT_ONTIME_TAG  1000
#define MEASUREMENT_OFFTIME_TAG  1001
#define MEASUREMENT_ONFLOWRATE_TAG  1002
#define MEASUREMENT_OFFFLOWRATE_TAG  1003

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface ProjectViewController ()
{
    BOOL bProjectDetailsVisible;
    BOOL bSampleDetailsCollapsed;
    NSUInteger selectedSampleNumber;
    NSUInteger numberOfVisibleSamples;
    iCarousel *samplesCarousel;
    UIPopoverController *popover;
    Sample *currentSample;
}

@end

@implementation ProjectViewController
@synthesize currentProject;

#pragma mark - View loading methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _projectTitleLabel.text = currentProject.project_ProjectNumber;
    
    _projectDetailView.project = currentProject;
    
    [_homeButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:12.0]];
    [_samplesLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0]];
    
    UIImage *bgimage = [UIImage imageNamed:@"btn_navbar_nor.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_reportButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"btn_navbar_pressed.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_reportButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    bgimage = [UIImage imageNamed:@"navbar_back_nor.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_homeButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"navbar_back_pressed.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_homeButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    bProjectDetailsVisible = YES;
    
    _samplesArray = [[NSMutableArray alloc] init];
    [_samplesArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleforProject:currentProject]];
    
    selectedSampleNumber = 1;
    numberOfVisibleSamples = 14;
    
    samplesCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(300, 88, 724, 53)];
    samplesCarousel.backgroundColor = [UIColor clearColor];
    samplesCarousel.type = iCarouselTypeLinear;
    samplesCarousel.bounceDistance = 0.25f;
    samplesCarousel.scrollSpeed = 0.75f;
    samplesCarousel.dataSource = self;
    samplesCarousel.delegate = self;
    [self.view  insertSubview:samplesCarousel belowSubview:_projectDetailView];
    
    UIFont *font14px = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    UIFont *fontBold14px = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    UIFont *fontBold12px = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0f];
    
    _sampleDetailsLabel.font = fontBold14px;
    _sampleIdLabel.font = font14px;
    _meaurementsLabel.font = fontBold14px;
    
    _samplesScrollView.contentSize = CGSizeMake(712, 700);
    
    // top blue line
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(0, 0, 1012, 6.0f);
    blueLayer.backgroundColor = [UIColor colorWithRed:0 green:138.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    [_sampleDetailsView.layer insertSublayer:blueLayer atIndex:0];
    _sampleDetailsView.layer.masksToBounds = YES;
    _sampleMeasurementsView.layer.masksToBounds = YES;
    
    UIColor *grayColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f];
    _sampleTypeView.layer.borderColor = grayColor.CGColor;
    _sampleTypeView.layer.borderWidth = 1.0f;
    _sampleTypeView.layer.cornerRadius = 5.0f;
    //_sampleTypeView.layer.masksToBounds = YES;
    _operationalAreaView.layer.borderColor = grayColor.CGColor;
    _operationalAreaView.layer.borderWidth = 1.0f;
    _operationalAreaView.layer.cornerRadius = 5.0f;
    //_operationalAreaView.layer.masksToBounds = YES;
    _notesView.layer.borderColor = grayColor.CGColor;
    _notesView.layer.borderWidth = 1.0f;
    _notesView.layer.cornerRadius = 5.0f;
    _notesView.layer.masksToBounds = YES;
    _commentsView.layer.borderColor = grayColor.CGColor;
    _commentsView.layer.borderWidth = 1.0f;
    _commentsView.layer.cornerRadius = 5.0f;
    _commentsView.layer.masksToBounds = YES;
    
    _chemicalPPEView.layer.borderColor = grayColor.CGColor;
    _chemicalPPEView.layer.borderWidth = 1.0f;
    _chemicalPPEView.layer.cornerRadius = 5.0f;
    
    _chemicalPPEView.horizontalLineYPos = 44.0f;
    _chemicalPPEView.numberOfColumns = 2;
    
    _measurementsView.layer.borderColor = grayColor.CGColor;
    _measurementsView.layer.borderWidth = 1.0f;
    _measurementsView.layer.cornerRadius = 5.0f;
    
    _measurementsView.horizontalLineYPos = 30.0f;
    _measurementsView.numberOfColumns = 4;
    
    _sampleTypeLabel.font = fontBold12px;;
    _sampleTypeValueLabel.font = font14px;
    _employeeNameLabel.font = fontBold12px;
    _employeeNameValueLabel.font = font14px;
    _deviceTypeLabel.font = fontBold12px;
    _deviceTypeValueLabel.font = font14px;
    _employeeJobLabel.font = fontBold12px;
    _employeeJobValueLabel.font = font14px;
    _operationalAreaLabel.font = fontBold12px;
    _operationalAreaValueLabel.font = font14px;
    _notesLabel.font = fontBold12px;
    _notesValueLabel.font = font14px;
    _commentsLabel.font = fontBold12px;
    _commentsValueLabel.font = font14px;
    _labelTWA.font = fontBold14px;
    _labelSTEL.font = fontBold14px;
    _labelCieling.font = fontBold14px;
    _onTimeLabel.font = fontBold12px;
    _offTimeLabel.font = fontBold12px;
    _onFlowRateLabel.font = fontBold12px;
    _offFlowRateLabel.font = fontBold12px;
    
    _notesLabel.layer.borderColor = grayColor.CGColor;
    _notesLabel.layer.borderWidth = 1.0f;
    
    _commentsLabel.layer.borderColor = grayColor.CGColor;
    _commentsLabel.layer.borderWidth = 1.0f;
    
    CALayer *grayLine = [CALayer layer];
    grayLine.frame = CGRectMake(0, _sampleTypeView.bounds.size.height/2, _sampleTypeView.bounds.size.width, 1.0f);
    grayLine.backgroundColor = grayColor.CGColor;
    [_sampleTypeView.layer addSublayer:grayLine];
    
    CALayer *grayLine1 = [CALayer layer];
    grayLine1.frame = CGRectMake(112, 0, 1.0f, _sampleTypeView.bounds.size.height);
    grayLine1.backgroundColor = grayColor.CGColor;
    [_sampleTypeView.layer insertSublayer:grayLine1 atIndex:0];
    
    CALayer *grayLine2 = [CALayer layer];
    grayLine2.frame = CGRectMake(340, 0, 1.0f, _sampleTypeView.bounds.size.height);
    grayLine2.backgroundColor = grayColor.CGColor;
    [_sampleTypeView.layer insertSublayer:grayLine2 atIndex:0];
    
    CALayer *grayLine3 = [CALayer layer];
    grayLine3.frame = CGRectMake(453, 0, 1.0f, _sampleTypeView.bounds.size.height);
    grayLine3.backgroundColor = grayColor.CGColor;
    [_sampleTypeView.layer insertSublayer:grayLine3 atIndex:0];
    
    CALayer *grayLine4 = [CALayer layer];
    grayLine4.frame = CGRectMake(112, 0, 1.0f, _operationalAreaView.bounds.size.height);
    grayLine4.backgroundColor = grayColor.CGColor;
    [_operationalAreaView.layer insertSublayer:grayLine4 atIndex:0];
    
    _chemicalsArray = [[NSMutableArray alloc] init];
    _ppeArray = [[NSMutableArray alloc] init];
    _deviceTypesArray = [[NSMutableArray alloc] init];
    _sampleTypesArray = [[NSMutableArray alloc] init];
    
    UIImage *addMeasurementImage = [UIImage imageNamed:@"btn_contact_bg.png"];
    addMeasurementImage = [addMeasurementImage stretchableImageWithLeftCapWidth:addMeasurementImage.size.width/2 topCapHeight:addMeasurementImage.size.height/2];
    [_addMesaurementButton setBackgroundImage:addMeasurementImage forState:UIControlStateNormal];
    [_addMesaurementButton.titleLabel setFont:font14px];
    
    _measurementsArray = [[NSMutableArray alloc] init];
    //[self updateMeasurementTable];
    
    [_btnTWACheck setSelected:NO];
    [_btnSTELCheck setSelected:NO];
    [_btnCielingCheck setSelected:NO];
    
    [self updateSampleNumber:0 animate:NO];
    
    UITapGestureRecognizer *empNameTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(empNameTapped)];
    [_employeeNameValueLabel addGestureRecognizer:empNameTapGesture];
    
    UITapGestureRecognizer *empJobTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(empJobTapped)];
    [_employeeJobValueLabel addGestureRecognizer:empJobTapGesture];
    
    UITapGestureRecognizer *opAreaTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(operationalAreaTapped)];
    [_operationalAreaValueLabel addGestureRecognizer:opAreaTapGesture];
    
    UITapGestureRecognizer *notesTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notesTapped)];
    [_notesValueLabel addGestureRecognizer:notesTapGesture];
    
    UITapGestureRecognizer *commentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentsTapped)];
    [_commentsValueLabel addGestureRecognizer:commentTapGesture];
    
    
    UITapGestureRecognizer *deviceTypeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deviceTypeTapped)];
    [_deviceTypeValueLabel addGestureRecognizer:deviceTypeTapGesture];
    
    UITapGestureRecognizer *sampleTypeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sampleTypeTapped)];
    [_sampleTypeValueLabel addGestureRecognizer:sampleTypeTapGesture];
    
    //Imp. KVO for req objects
    [_sampleTypeValueLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [_deviceTypeValueLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [_btnTWACheck addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [_btnSTELCheck addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [_btnCielingCheck addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillShow)
     name:UIKeyboardWillShowNotification
     object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillHide)
     name:UIKeyboardWillHideNotification
     object:nil];*/
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)showTextEditViewForDetailType:(TextDetailType)detailType
{
    /*UIView *fadeTextEditView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
     fadeTextEditView.tag = FADE_VIEW_TAG;
     fadeTextEditView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
     fadeTextEditView.alpha = 0;
     [self.view addSubview:fadeTextEditView];*/
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TextEditView"owner:self options:nil];
    TextEditView *textEditView = (TextEditView *)[topLevelObjects objectAtIndex:0];
    textEditView.tag = FADE_VIEW_TAG;
    textEditView.alpha = 0;
    textEditView.delegate = self;
    textEditView.textDetailType = detailType;
    
    NSString* text = @"";
    switch (detailType) {
        case Edit_EmployeeName:
        {
            text = _employeeNameValueLabel.text;
        }
            break;
        case Edit_EmployeeJob:
        {
            text = _employeeJobValueLabel.text;
        }
            break;
        case Edit_OperationalArea:
        {
            text = _operationalAreaValueLabel.text;
        }
            break;
        case Edit_Notes:
        {
            text = _notesValueLabel.text;
        }
            break;
        case Edit_Comments:
        {
            text = _commentsValueLabel.text;
        }
            break;
            
        default:
            break;
    }
    
    [textEditView setText:text];
    [self.view addSubview:textEditView];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         textEditView.alpha = 1.0f;
                     }];
}

-(void)removeTextEditView
{
    TextEditView *textEditView = (TextEditView*)[self.view viewWithTag:FADE_VIEW_TAG];
    if(!textEditView)
        return;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         textEditView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [textEditView removeFromSuperview];
                     }];
}

#pragma mark - Button actions

-(IBAction)homeButtonPressed:(id)sender
{
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    [UIView transitionFromView:self.view
                        toView:vc.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished){
                        /* do something on animation completion */
                    }];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)addSample:(id)sender
{
    User *user = [[mSingleton getPersistentStoreManager] getAiresUser];
    
    NSMutableDictionary *sampleDict = [[NSMutableDictionary alloc] init];
    NSNumber *sampleId = [[mSingleton getPersistentStoreManager] generateIDforNewSample];
    NSString *sampleNumber = [[mSingleton getPersistentStoreManager] generateNumberforNewSample];
    [sampleDict setValue:sampleId forKey:@"SampleId"]; // new field
    [sampleDict setValue:sampleNumber forKey:@"SampleNumber"]; // new field
    [sampleDict setValue:user.user_FirstName forKey:@"EmployeeName"];
    [sampleDict setValue:@"Engineer" forKey:@"EmployeeJob"];
    [sampleDict setValue:@"N/A" forKey:@"OperationArea"];
    [sampleDict setValue:currentProject.projectID forKey:@"ProjectId"];
    [sampleDict setValue:[self getUTCFormateDate:[NSDate date]] forKey:@"CreatedOn"];
    
    [[mSingleton getPersistentStoreManager] storeSampleDetails:[NSArray arrayWithObject:sampleDict] forProject:currentProject];
    
    [_samplesArray removeAllObjects];
    [_samplesArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleforProject:currentProject]];
    selectedSampleNumber = _samplesArray.count;
    [samplesCarousel reloadData];
    [samplesCarousel scrollToItemAtIndex:samplesCarousel.numberOfItems-1 animated:YES];
    [self updateSampleNumber:_samplesArray.count-1 animate:NO];
}

-(IBAction)adjustSamplesArea:(id)sender
{
    return;
    [UIView animateWithDuration:0.25
                     animations:^{
                         _projectDetailView.frame = CGRectMake(bProjectDetailsVisible?-300.0f:0, 44.0f, 300.0f, 704.0f);
                         _sampleSubHeaderView.frame = CGRectMake(bProjectDetailsVisible?0:301.0f, 44.0f, bProjectDetailsVisible?1024.0f:724.0f, 44.0f);
                         _adjustSampleAreaButton.frame = CGRectMake(bProjectDetailsVisible?3.0f:303.0f, 45.0f, 50.0f, 32.0f);
                         _samplesLabel.frame = CGRectMake(bProjectDetailsVisible?466.0f:616.0f, 50.0f, 93.0f, 21.0f);
                         samplesCarousel.frame = CGRectMake(bProjectDetailsVisible?0:300.0f, 88.0f, bProjectDetailsVisible?1024.0f:724.0f, 53.0f);
                         samplesCarousel.alpha = 0;
                         
                         _sampleDetailsView.frame = CGRectMake(bProjectDetailsVisible?6:306.0f, 141.0f, bProjectDetailsVisible?1012.0f:712.0f, 523.0f);
                         _sampleDetailsCollapseButton.frame = CGRectMake(bProjectDetailsVisible?966:666.0f, 6.0f, 46.0f, 42.0f);
                         _sampleMeasurementsView.frame = CGRectMake(bProjectDetailsVisible?6:306.0f, 670.0f, bProjectDetailsVisible?1012.0f:712.0f, 44.0f);
                         _addMesaurementButton.frame = CGRectMake(bProjectDetailsVisible?927:627.0f, 6.0f, 70.0f, 35.0f);
                     }
                     completion:^(BOOL finished) {
                         numberOfVisibleSamples = bProjectDetailsVisible?20:14;
                         [samplesCarousel removeFromSuperview];
                         samplesCarousel = nil;
                         
                         samplesCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(bProjectDetailsVisible?0:300.0f, 88.0f, bProjectDetailsVisible?1024.0f:724.0f, 53.0f)];
                         samplesCarousel.backgroundColor = [UIColor clearColor];
                         samplesCarousel.type = iCarouselTypeLinear;
                         samplesCarousel.bounceDistance = 0.25f;
                         samplesCarousel.scrollSpeed = 0.75f;
                         samplesCarousel.dataSource = self;
                         samplesCarousel.delegate = self;
                         samplesCarousel.alpha = 0;
                         [self.view  insertSubview:samplesCarousel belowSubview:_projectDetailView];
                         [samplesCarousel reloadData];
                         
                         [UIView animateWithDuration:0.25 animations:^{
                             samplesCarousel.alpha = 1.0f;
                         }];
                         
                         bProjectDetailsVisible = !bProjectDetailsVisible;
                         
                         NSUInteger curIndex = selectedSampleNumber/numberOfVisibleSamples;
                         [samplesCarousel scrollToItemAtIndex:curIndex animated:NO];
                     }];
}

-(IBAction)sampleDetailsCollapse:(id)sender
{
    [self collapseSampleDetail:!bSampleDetailsCollapsed];
}

-(void)collapseSampleDetail:(BOOL)collapse
{
    CGFloat alpha = 0;
    CGRect sampleDetailsFrame = _sampleDetailsView.frame;
    CGRect _sampleMeasurementsFrame = _sampleMeasurementsView.frame;
    CGFloat angle = 0;
    if(collapse)
    {
        sampleDetailsFrame.size.height = 48.0f;
        _sampleMeasurementsFrame.origin.y = 195.0f;
        _sampleMeasurementsFrame.size.height = 519.0f;
        angle = M_PI;
        alpha = 0;
        [UIView animateWithDuration:0.2
                         animations:^{
                             _samplesScrollView.alpha = alpha;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5
                                              animations:^{
                                                  _measurementsScrollView.alpha = 1.0f;
                                              }];
                         }];
    }
    else
    {
        sampleDetailsFrame.size.height = 523.0f;
        _sampleMeasurementsFrame.origin.y = 670.0f;
        _sampleMeasurementsFrame.size.height = 44.0f;
        angle = 0;
        alpha = 1.0f;
        
        [UIView animateWithDuration:0.1
                         animations:^{
                             _measurementsScrollView.alpha = 0;
                         }];
        
        [UIView animateWithDuration:0.2
                              delay:0.2f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _samplesScrollView.alpha = alpha;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
    [UIView animateWithDuration:0.3
                          delay:alpha==0?0.1f:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _sampleDetailsCollapseButton.transform = CGAffineTransformMakeRotation(-angle);
                         _sampleDetailsView.frame = sampleDetailsFrame;
                         _sampleMeasurementsView.frame = _sampleMeasurementsFrame;
                         _measurementsScrollView.frame = CGRectMake(0, 57, 712, 452);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    bSampleDetailsCollapsed = collapse;
}

-(IBAction)addChemical:(id)sender
{
    ChemicalsListViewController * chemicalListVC = [[ChemicalsListViewController alloc] initWithNibName:@"ChemicalsListViewController" bundle:nil];
    chemicalListVC.listContent = [[mSingleton getPersistentStoreManager] getChemicalList];
    chemicalListVC.selectedContent = _chemicalsArray;
    chemicalListVC.delegate = self;
    
    if(!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:chemicalListVC];
    else
        [popover setContentViewController:chemicalListVC];
    
    [popover setPopoverContentSize:CGSizeMake(320, 500)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:_chemicalsTableView.bounds inView:_chemicalsTableView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(IBAction)addPPE:(id)sender
{
    PPEListViewController * ppeListVC = [[PPEListViewController alloc] initWithNibName:@"PPEListViewController" bundle:nil];
    ppeListVC.listContent = [[mSingleton getPersistentStoreManager] getProtectionEquipmentList];
    ppeListVC.selectedContent = _ppeArray;
    ppeListVC.delegate = self;
    
    if(!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:ppeListVC];
    else
        [popover setContentViewController:ppeListVC];
    
    [popover setPopoverContentSize:CGSizeMake(320, 500)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:_ppeTableView.bounds inView:_ppeTableView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

-(IBAction)addMeasurement:(id)sender
{
    if(!bSampleDetailsCollapsed)
    {
        [self collapseSampleDetail:YES];
    }
    MeasurementFields *measurement = [[MeasurementFields alloc] init];
    measurement.sampleMeasurement_OffTime = [self getUTCFormateDate:[NSDate date]];
    measurement.sampleMeasurement_OnTime = [self getUTCFormateDate:[NSDate date]];
    measurement.sampleMeasurement_OnFlowRate = [NSNumber numberWithInt:0];
    measurement.sampleMeasurement_OffFlowRate = [NSNumber numberWithInt:0];
    [self showMeasurementEditAddView:NO forMeasurement:measurement];
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

-(void)showMeasurementEditAddView:(BOOL)editMode forMeasurement:(id)measurement
{
    if([currentSample.deviceType isEqualToString:@"Active"])
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MeasurementActiveView"owner:self options:nil];
        MeasurementActiveView *measurementView = (MeasurementActiveView *)[topLevelObjects objectAtIndex:0];
        measurementView.tag = FADE_VIEW_TAG;
        measurementView.delegate = self;
        measurementView.editMode = editMode;
        
        if(editMode)
            measurementView.sampleMeasurement = (SampleMeasurement*)measurement;
        else
            measurementView.measurementFields =(MeasurementFields*)measurement;
        
        [self.view addSubview:measurementView];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             measurementView.alpha = 1.0f;
                         }];
    }
    else if([currentSample.deviceType isEqualToString:@"Passive"])
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MeasurementPassiveView"owner:self options:nil];
        MeasurementPassiveView *measurementView = (MeasurementPassiveView *)[topLevelObjects objectAtIndex:0];
        measurementView.tag = FADE_VIEW_TAG;
        measurementView.delegate = self;
        measurementView.editMode = editMode;
        
        if(editMode)
            measurementView.sampleMeasurement = (SampleMeasurement*)measurement;
        else
            measurementView.measurementFields =(MeasurementFields*)measurement;
        
        [self.view addSubview:measurementView];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             measurementView.alpha = 1.0f;
                         }];
    }
    else if([currentSample.deviceType isEqualToString:@"Wipe"])
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MeasurementWipeView"owner:self options:nil];
        MeasurementWipeView *measurementView = (MeasurementWipeView *)[topLevelObjects objectAtIndex:0];
        measurementView.tag = FADE_VIEW_TAG;
        measurementView.delegate = self;
        measurementView.editMode = editMode;
        
        if(editMode)
            measurementView.sampleMeasurement = (SampleMeasurement*)measurement;
        else
            measurementView.measurementFields =(MeasurementFields*)measurement;
        
        [self.view addSubview:measurementView];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             measurementView.alpha = 1.0f;
                         }];
    }
    else if([currentSample.deviceType isEqualToString:@"Bulk"])
    {
       
    }
    else
    {
        // shouldn't reach here
    }
}

-(IBAction)checkButtonPressed:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [button setSelected:!button.isSelected];
    
    if(button == _btnCielingCheck)
        [[mSingleton getPersistentStoreManager] updateSampleChemical:nil inSample:currentSample forField:FIELD_SAMPLECHEMICAL_CFlag withValue:[NSNumber numberWithBool:button.isSelected]];
    else if(button == _btnSTELCheck)
        [[mSingleton getPersistentStoreManager] updateSampleChemical:nil inSample:currentSample forField:FIELD_SAMPLECHEMICAL_STELFlag withValue:[NSNumber numberWithBool:button.isSelected]];
    else if(button == _btnTWACheck)
        [[mSingleton getPersistentStoreManager] updateSampleChemical:nil inSample:currentSample forField:FIELD_SAMPLECHEMICAL_TWAFlag withValue:[NSNumber numberWithBool:button.isSelected]];
    
}

- (IBAction)onGeneratePreview:(id)sender
{
    for (Sample *mSample in _samplesArray) {
        if (![self isvalidForSample:mSample]) {
            UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Incomplete" message:@"There are certain samples incomplete.\nUpdate all samples in order to generate report." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [noNetworkAlert show];
            return;
        }
    }
    if(!mPreviewReportViewController)
        mPreviewReportViewController = [[PreviewReportViewController alloc] initWithNibName:@"PreviewReportViewController" bundle:nil];
    [mPreviewReportViewController setCurrentProject:currentProject];
    
    [self.navigationController pushViewController:mPreviewReportViewController animated:NO];
    [UIView transitionFromView:self.view
                        toView:mPreviewReportViewController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished){
                        /* do something on animation completion */
                    }];
    
}

#pragma mark - Sample Detail Editting actions

-(void)empNameTapped
{
    [self showTextEditViewForDetailType:Edit_EmployeeName];
}

-(void)empJobTapped
{
    [self showTextEditViewForDetailType:Edit_EmployeeJob];
}

-(void)operationalAreaTapped
{
    [self showTextEditViewForDetailType:Edit_OperationalArea];
}

-(void)notesTapped
{
    [self showTextEditViewForDetailType:Edit_Notes];
}

-(void)commentsTapped
{
    [self showTextEditViewForDetailType:Edit_Comments];
}

-(void)sampleTypeTapped
{
    SampleTypesListViewController * sampleTypeListVC = [[SampleTypesListViewController alloc] initWithNibName:@"SampleTypesListViewController" bundle:nil];
    sampleTypeListVC.listContent = _sampleTypesArray;
    sampleTypeListVC.selectedSampleType = nil;
    sampleTypeListVC.delegate = self;
    
    if(!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:sampleTypeListVC];
    else
        [popover setContentViewController:sampleTypeListVC];
    
    [popover setPopoverContentSize:CGSizeMake(320, 244)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:_sampleTypeValueLabel.bounds inView:_sampleTypeValueLabel permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


-(void)deviceTypeTapped
{
    DeviceTypesListViewController * deviceTypeListVC = [[DeviceTypesListViewController alloc] initWithNibName:@"DeviceTypesListViewController" bundle:nil];
    deviceTypeListVC.listContent = _deviceTypesArray;
    deviceTypeListVC.selectedDeviceType = nil;
    deviceTypeListVC.delegate = self;
    
    if(!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:deviceTypeListVC];
    else
        [popover setContentViewController:deviceTypeListVC];
    
    [popover setPopoverContentSize:CGSizeMake(320, 244)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:_deviceTypeValueLabel.bounds inView:_deviceTypeValueLabel permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - Samples, Chemicals, PPEs and Measurements updates

-(void)updateSampleNumber:(NSUInteger)index animate:(BOOL)anim
{
    if(anim)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = index>selectedSampleNumber?kCATransitionFromRight:kCATransitionFromLeft;
        transition.delegate = self;
        [_sampleDetailsView.layer addAnimation:transition forKey:nil];
        [_sampleMeasurementsView.layer addAnimation:transition forKey:nil];
    }
    Sample *sample = nil;
    if([_samplesArray count] >0)
        sample = [_samplesArray objectAtIndex:index];
    else
    {
        //Handle no sample condition
        [self addSample:nil];
        return;
    }
    currentSample = sample;
    _sampleIdLabel.text = sample.sample_SampleNumber;
    _sampleTypeValueLabel.text = sample.airesSampleType.sampleTypeName;
    _deviceTypeValueLabel.text = sample.deviceType;
    _employeeNameValueLabel.text = sample.sample_EmployeeName;
    _employeeJobValueLabel.text = sample.sample_EmployeeJob;
    _operationalAreaValueLabel.text = sample.sample_OperationArea;
    _notesValueLabel.text = sample.sample_Notes;
    _commentsValueLabel.text = sample.sample_Comments;
    
    [_chemicalsArray removeAllObjects];
    [_chemicalsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleChemicalforSample:sample]];
    
    [_ppeArray removeAllObjects];
    [_ppeArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleProtectionEquipmentforSample:sample]];
    
    [_measurementsArray removeAllObjects];
    [_measurementsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleMeasurementforSample:sample]];
    
    [_sampleTypesArray removeAllObjects];
    [_sampleTypesArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleyTypeList]];
    
    [_deviceTypesArray removeAllObjects];
    [_deviceTypesArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getDeviceTypeList]];
    
    [_chemicalsTableView reloadData];
    [_ppeTableView reloadData];
    [_measurementsTableView reloadData];
    
    [self updateChemicalPPETable];
    [self updateMeasurementTable];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

//KVO method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *status = [self isvalidField];
    [_sampleTypeLabel setTextColor:[UIColor blackColor]];
    [_deviceTypeLabel setTextColor:[UIColor blackColor]];
    [_meaurementsLabel setTextColor:[UIColor blackColor]];
    
    _labelTWA.textColor = [UIColor blackColor];
    _labelSTEL.textColor = [UIColor blackColor];
    _labelCieling.textColor = [UIColor blackColor];
    [_sampleChemicalsLabel setTextColor:[UIColor blackColor]];
    [_ppelabel setTextColor:[UIColor blackColor]];
    
    if([status isEqualToString:KVO_SAMPLE_VALID])
    {
        [samplesCarousel reloadData];
    }
    else if([status isEqualToString:KVO_SAMPLE_INVALID])
    {
        
    }
    else if([status isEqualToString:KVO_SAMPLE_INVALID_FLAG])
    {
        _labelTWA.textColor = [UIColor redColor];
        _labelSTEL.textColor = [UIColor redColor];
        _labelCieling.textColor = [UIColor redColor];
    }
    else if([status isEqualToString:KVO_SAMPLE_SC])
    {
        [_sampleChemicalsLabel setTextColor:[UIColor redColor]];
    }
    else if([status isEqualToString:KVO_SAMPLE_PPE])
    {
        [_ppelabel setTextColor:[UIColor redColor]];
    }
    else if([status isEqualToString:KVO_SAMPLE_MEASUREMENT])
    {
        [_meaurementsLabel setTextColor:[UIColor redColor]];
    }
    else if([status isEqualToString:KVO_SAMPLE_SAMPLE_TYPE])
    {
        [_sampleTypeLabel setTextColor:[UIColor redColor]];
    }
    else if([status isEqualToString:KVO_SAMPLE_DEVICE_TYPE])
    {
        [_deviceTypeLabel setTextColor:[UIColor redColor]];
    }
}

-(void)updateNotes
{
    NSString *notes = _notesValueLabel.text;
    
    CGRect notesViewFrame = _notesView.frame;
    CGRect notesLabelFrame = _notesLabel.frame;
    CGRect notesValueLabelFrame = _notesValueLabel.frame;
    
    CGFloat height = ceilf([notes sizeWithFont:_notesValueLabel.font constrainedToSize:CGSizeMake(_notesValueLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    
    CGFloat viewHeight = ((height+20)<44)?44:(height+20);
    notesViewFrame.size.height = viewHeight;
    notesLabelFrame.size.height = viewHeight;
    CGFloat labelHeight = (height<24)?24:height;
    notesValueLabelFrame.size.height = labelHeight;
    
    _notesView.frame = notesViewFrame;
    _notesLabel.frame = notesLabelFrame;
    _notesValueLabel.frame = notesValueLabelFrame;
    
    CGRect commentsViewFrame = _commentsView.frame;
    commentsViewFrame.origin.y = notesViewFrame.origin.y + notesViewFrame.size.height + 15.0f;
    _commentsView.frame = commentsViewFrame;
    
    CGRect chemicalPPEFrame = _chemicalPPEView.frame;
    chemicalPPEFrame.origin.y = commentsViewFrame.origin.y + commentsViewFrame.size.height + 30.0f;
    _chemicalPPEView.frame = chemicalPPEFrame;
    
    CGRect flagsViewFrame = _flagsView.frame;
    flagsViewFrame.origin.y = chemicalPPEFrame.origin.y + chemicalPPEFrame.size.height + 20.0f;
    _flagsView.frame = flagsViewFrame;
    
    _samplesScrollView.contentSize = CGSizeMake(_samplesScrollView.frame.size.width, _samplesScrollView.frame.size.height + ( _flagsView.frame.origin.y + _flagsView.frame.size.height + 20.0f - _samplesScrollView.frame.size.height));
    
    [[mSingleton getPersistentStoreManager] updateSample:currentSample inProject:currentProject forField:FIELD_SAMPLE_NOTES withValue:notes];
}

-(void)updateComments
{
    NSString *comments = _commentsValueLabel.text;
    
    CGRect commentsViewFrame = _commentsView.frame;
    CGRect commentsLabelFrame = _commentsLabel.frame;
    CGRect commentsValueLabelFrame = _commentsValueLabel.frame;
    
    CGFloat height = ceilf([comments sizeWithFont:_commentsValueLabel.font constrainedToSize:CGSizeMake(_commentsValueLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    
    CGFloat viewHeight = ((height+20)<44)?44:(height+20);
    commentsViewFrame.size.height = viewHeight;
    commentsLabelFrame.size.height = viewHeight;
    CGFloat labelHeight = (height<24)?24:height;
    commentsValueLabelFrame.size.height = labelHeight;
    
    _commentsView.frame = commentsViewFrame;
    _commentsLabel.frame = commentsLabelFrame;
    _commentsValueLabel.frame = commentsValueLabelFrame;
    
    CGRect chemicalPPEFrame = _chemicalPPEView.frame;
    chemicalPPEFrame.origin.y = commentsViewFrame.origin.y + commentsViewFrame.size.height + 30.0f;
    _chemicalPPEView.frame = chemicalPPEFrame;
    
    CGRect flagsViewFrame = _flagsView.frame;
    flagsViewFrame.origin.y = chemicalPPEFrame.origin.y + chemicalPPEFrame.size.height + 20.0f;
    _flagsView.frame = flagsViewFrame;
    
    _samplesScrollView.contentSize = CGSizeMake(_samplesScrollView.frame.size.width, _samplesScrollView.frame.size.height + ( _flagsView.frame.origin.y + _flagsView.frame.size.height + 20.0f - _samplesScrollView.frame.size.height));
    
    [[mSingleton getPersistentStoreManager] updateSample:currentSample inProject:currentProject forField:FIELD_SAMPLE_COMMENTS withValue:comments];
}

-(void)updateChemicalPPETable
{
    NSUInteger chemicalsCount = _chemicalsArray.count;
    NSUInteger ppeCount = _ppeArray.count;
    NSUInteger moreCount = chemicalsCount>ppeCount?chemicalsCount:ppeCount;
    
    CGRect chemicalPPEFrame = _chemicalPPEView.frame;
    if(moreCount == 0)
        moreCount = 1;
    chemicalPPEFrame.size.height = 44.0f/*title*/ + (40.0f/*row height*/ * moreCount);
    _chemicalPPEView.frame = chemicalPPEFrame;
    
    CGRect flagsViewFrame = _flagsView.frame;
    flagsViewFrame.origin.y = _chemicalPPEView.frame.origin.y + _chemicalPPEView.frame.size.height + 20.0f;
    _flagsView.frame = flagsViewFrame;
    
    [_chemicalPPEView updateDividerLines];
    
    _samplesScrollView.contentSize = CGSizeMake(_samplesScrollView.frame.size.width, _samplesScrollView.frame.size.height + ( _flagsView.frame.origin.y + _flagsView.frame.size.height + 20.0f - _samplesScrollView.frame.size.height));
}

-(void)updateMeasurementTable
{
    [_measurementsTableView reloadData];
    
    CGRect measurementsViewFrame = _measurementsView.frame;
    NSUInteger numberOfMeasurements = _measurementsArray.count==0 ? 1 : _measurementsArray.count;
    measurementsViewFrame.size.height = 30.0f/*header height*/ + numberOfMeasurements/*no. of measurements*/ * 44.0f/*row height*/;
    _measurementsView.frame = measurementsViewFrame;
    
    CGRect measurementsTableViewFrame = _measurementsTableView.frame;
    measurementsTableViewFrame.size.height = numberOfMeasurements/*no. of measurements*/ * 44.0f/*row height*/;
    _measurementsTableView.frame = measurementsTableViewFrame;
    
    CGRect totalMeasurementsViewFrame = _totalMeasurementsView.frame;
    totalMeasurementsViewFrame.origin.y = measurementsViewFrame.origin.y + measurementsViewFrame.size.height + 20.0f;
    _totalMeasurementsView.frame = totalMeasurementsViewFrame;
    
    [_measurementsView updateDividerLines];
    
    _measurementsScrollView.contentSize = CGSizeMake(_measurementsScrollView.frame.size.width, _measurementsScrollView.frame.size.height + ( _totalMeasurementsView.frame.origin.y + _totalMeasurementsView.frame.size.height + 20.0f - _measurementsScrollView.frame.size.height));
}

#pragma mark - iCarousel datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)aCarousel
{
    return (_samplesArray.count==0) ? 0 : ((_samplesArray.count-1)/numberOfVisibleSamples)+1;
}

- (UIView *)carousel:(iCarousel *)aCarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView*)view
{
    if (view == nil)
    {
        // content view
        UIView *aView = [[UIView alloc] initWithFrame:samplesCarousel.bounds];
        
        NSUInteger viewsCount = ((_samplesArray.count-1)/numberOfVisibleSamples)+1;
        NSUInteger viewsToAdd = (index+1)<viewsCount ? numberOfVisibleSamples : _samplesArray.count-(index*numberOfVisibleSamples);
        for (int i=0; i<viewsToAdd; i++)
        {
            SampleTileView *tileView = [[SampleTileView alloc] initWithFrame:CGRectMake((i*((numberOfVisibleSamples==14)?51:50.5)), 0, 52, 52)];
            Sample *sample = (Sample*)[_samplesArray objectAtIndex:(index*numberOfVisibleSamples)+i];
            NSUInteger sampleNumber = (index*numberOfVisibleSamples)+i+1;
            tileView.tag = sampleNumber;
            [tileView setSampleId:sample.sample_SampleNumber];
            [tileView setSampleNumber:sampleNumber];
            [tileView setSampleCompletedStatus:[self isvalidForSample:sample]];
            [tileView setSampleSelected:(sampleNumber==selectedSampleNumber)?YES:NO];
            tileView.delegate = self;
            [aView addSubview:tileView];
        }
        
        return aView;
    }
    view.frame = samplesCarousel.bounds;
    return view;
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_chemicalsTableView)
    {
        return _chemicalsArray.count;
    }
    else if (tableView==_ppeTableView)
    {
        return _ppeArray.count;
    }
    else
    {
        // measurementsTableView
        return _measurementsArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_chemicalsTableView || tableView==_ppeTableView)
    {
        return 40.0f;
    }
    else
    {
        // measurementsTableView
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_chemicalsTableView || tableView==_ppeTableView)
    {
        static NSString *kCellID = @"ChemicalPPEValueCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
            cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(tableView ==_chemicalsTableView)
        {
            SampleChemical *sc = (SampleChemical*)[_chemicalsArray objectAtIndex:indexPath.row];
            cell.textLabel.text = sc.sampleChemical_Name;
            if (sc.sampleChemical_PELCFlag || sc.sampleChemical_TLVCFlag)
            {
                [_btnCielingCheck setSelected:TRUE];
                [[mSingleton getPersistentStoreManager] updateSampleChemical:nil inSample:currentSample forField:FIELD_SAMPLECHEMICAL_CFlag withValue:[NSNumber numberWithBool:TRUE]];
            }
            if (sc.sampleChemical_TLVTWAFlag || sc.sampleChemical_PELTWAFlag)
            {
                [_btnTWACheck setSelected:TRUE];
                [[mSingleton getPersistentStoreManager] updateSampleChemical:nil inSample:currentSample forField:FIELD_SAMPLECHEMICAL_TWAFlag withValue:[NSNumber numberWithBool:TRUE]];
            }
            if (sc.sampleChemical_TLVSTELFlag || sc.sampleChemical_PELSTELFlag)
            {
                [_btnSTELCheck setSelected:TRUE];
                [[mSingleton getPersistentStoreManager] updateSampleChemical:nil inSample:currentSample forField:FIELD_SAMPLECHEMICAL_STELFlag withValue:[NSNumber numberWithBool:TRUE]];
            }
        }
        else
        {
            SampleProtectionEquipment *ppe = (SampleProtectionEquipment*)[_ppeArray objectAtIndex:indexPath.row];
            cell.textLabel.text = ppe.sampleProtectionEquipment_Name;
        }
        
        return cell;
    }
    else
    {
        // measurementsTableView
        static NSString *kMeasurementCellID = @"MeasurementValueCell";
        SampleMeasurement *measurement = (SampleMeasurement*)[_measurementsArray objectAtIndex:indexPath.row];
        
        NSDictionary *onTimeComponents = [mSingleton getDateComponentsforString:measurement.sampleMeasurement_OnTime];
        NSString *onTimeString = [NSString stringWithFormat:@"%@:%@ %@", [onTimeComponents valueForKey:@"hour"], [onTimeComponents valueForKey:@"minute"], [onTimeComponents valueForKey:@"meridian"]];
        
        NSDictionary *offTimeComponents = [mSingleton getDateComponentsforString:measurement.sampleMeasurement_OffTime];
        NSString *offTimeString = [NSString stringWithFormat:@"%@:%@ %@", [offTimeComponents valueForKey:@"hour"], [offTimeComponents valueForKey:@"minute"], [offTimeComponents valueForKey:@"meridian"]];
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kMeasurementCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMeasurementCellID];
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UIFont *font14px = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
            UIColor *textColor = [UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f];
            
            TextInsetLabel *onTimeLabel = [[TextInsetLabel alloc] initWithFrame:CGRectMake(0, 0, 170.5, cell.contentView.bounds.size.height)];
            onTimeLabel.tag = MEASUREMENT_ONTIME_TAG;
            onTimeLabel.backgroundColor = [UIColor clearColor];
            onTimeLabel.font = font14px;
            onTimeLabel.textColor = textColor;
            onTimeLabel.text = onTimeString;
            [cell.contentView addSubview:onTimeLabel];
            
            TextInsetLabel *onFlowRateLabel = [[TextInsetLabel alloc] initWithFrame:CGRectMake(170.5, 0, 170.5, cell.contentView.bounds.size.height)];
            onFlowRateLabel.tag = MEASUREMENT_ONFLOWRATE_TAG;
            onFlowRateLabel.backgroundColor = [UIColor clearColor];
            onFlowRateLabel.font = font14px;
            onFlowRateLabel.textColor = textColor;
            onFlowRateLabel.text = [measurement.sampleMeasurement_OnFlowRate stringValue];
            [cell.contentView addSubview:onFlowRateLabel];
            
            TextInsetLabel *offTimeLabel = [[TextInsetLabel alloc] initWithFrame:CGRectMake(341, 0, 170.5, cell.contentView.bounds.size.height)];
            offTimeLabel.tag = MEASUREMENT_OFFTIME_TAG;
            offTimeLabel.backgroundColor = [UIColor clearColor];
            offTimeLabel.font = font14px;
            offTimeLabel.textColor = textColor;
            offTimeLabel.text = offTimeString;
            [cell.contentView addSubview:offTimeLabel];
            
            TextInsetLabel *offFlowRateLabel = [[TextInsetLabel alloc] initWithFrame:CGRectMake(511.5, 0, 170.5, cell.contentView.bounds.size.height)];
            offFlowRateLabel.tag = MEASUREMENT_OFFFLOWRATE_TAG;
            offFlowRateLabel.backgroundColor = [UIColor clearColor];
            offFlowRateLabel.font = font14px;
            offFlowRateLabel.textColor = textColor;
            offFlowRateLabel.text = [measurement.sampleMeasurement_OffFlowRate stringValue];
            [cell.contentView addSubview:offFlowRateLabel];
        }
        else
        {
            TextInsetLabel *onTimeLabel = (TextInsetLabel*)[cell.contentView viewWithTag:MEASUREMENT_ONTIME_TAG];
            onTimeLabel.text = onTimeString;
            TextInsetLabel *onFlowRateLabel = (TextInsetLabel*)[cell.contentView viewWithTag:MEASUREMENT_ONFLOWRATE_TAG];
            onFlowRateLabel.text = [measurement.sampleMeasurement_OnFlowRate stringValue];
            onFlowRateLabel.backgroundColor = [UIColor clearColor];
            TextInsetLabel *offTimeLabel = (TextInsetLabel*)[cell.contentView viewWithTag:MEASUREMENT_OFFTIME_TAG];
            offTimeLabel.text = offTimeString;
            TextInsetLabel *offFlowRateLabel = (TextInsetLabel*)[cell.contentView viewWithTag:MEASUREMENT_OFFFLOWRATE_TAG];
            offFlowRateLabel.text = [measurement.sampleMeasurement_OffFlowRate stringValue];
            offFlowRateLabel.backgroundColor =[UIColor clearColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView==_measurementsTableView)
    {
        SampleMeasurement *measurement = (SampleMeasurement*)[_measurementsArray objectAtIndex:indexPath.row];
        [self showMeasurementEditAddView:YES forMeasurement:measurement];
    }
}

#pragma mark - SampleTileViewDelegate

-(void)sampleNumberSelected:(NSUInteger)number
{
    if(selectedSampleNumber == number)
        return;
    
    SampleTileView *tileView = (SampleTileView*)[samplesCarousel viewWithTag:selectedSampleNumber];
    if(tileView && [tileView isKindOfClass:[SampleTileView class]])
    {
        [tileView setSampleSelected:NO];
    }
    
    [self updateSampleNumber:number-1 animate:YES];
    [_btnTWACheck setSelected:NO];
    [_btnSTELCheck setSelected:NO];
    [_btnCielingCheck setSelected:NO];
    
    selectedSampleNumber = number;
}

#pragma mark - SampleTypeListProtocol

-(void)sampleTypeSelected:(SampleType *)sampleType
{
    _sampleTypeValueLabel.text = sampleType.sampleTypeName;
    currentSample.airesSampleType.sampleTypeName = sampleType.sampleTypeName;;
    [popover dismissPopoverAnimated:YES];
    [[mSingleton getPersistentStoreManager] updateSample:currentSample inProject:currentProject forField:FIELD_SAMPLE_SAMPLETYPE withValue:sampleType];
}

#pragma mark - DeviceTypeListProtocol

-(void)deviceTypeSelected:(DeviceType *)deviceType
{
    _deviceTypeValueLabel.text = deviceType.deviceType_DeviceTypeName;
    currentSample.deviceTypeId = deviceType.deviceType_DeviceTypeID;
    currentSample.deviceType = deviceType.deviceType_DeviceTypeName;
    [popover dismissPopoverAnimated:YES];
    [[mSingleton getPersistentStoreManager] updateSample:currentSample inProject:currentProject forField:FIELD_SAMPLE_DEVICETYPE withValue:deviceType];
    [_measurementsTableView reloadData];
}

#pragma mark - ChemicalListProtocol

-(void)chemicalsListBackPressed
{
    [popover dismissPopoverAnimated:YES];
}

-(void)selectedChemicals:(NSArray *)array
{
    [_chemicalsTableView reloadData];
    [self updateChemicalPPETable];
    [popover dismissPopoverAnimated:YES];
    
    NSMutableArray *chemArray = [[NSMutableArray alloc] init];
    for(SampleChemical *chemical in _chemicalsArray)
    {
        NSMutableDictionary *chemicalDict = [[NSMutableDictionary alloc] init];
        [chemicalDict setValue:chemical.sampleChemical_Name forKey:@"Chemical"];
        [chemicalDict setValue:chemical.sampleChemical_PELCFlag forKey:@"PELCFlag"];
        [chemicalDict setValue:chemical.sampleChemical_PELSTELFlag forKey:@"PELSTELFlag"];
        [chemicalDict setValue:chemical.sampleChemical_PELTWAFlag forKey:@"PELTWAFlag"];
        [chemicalDict setValue:chemical.sampleChemical_TLVSTELFlag forKey:@"TLVCFlag"];
        [chemicalDict setValue:chemical.sampleChemical_TLVTWAFlag forKey:@"TLVSTELFlag"];
        [chemicalDict setValue:chemical.sampleChemical_PELTWAFlag forKey:@"TLVTWAFlag"];
        NSLog(@"Chemical Id - %@", chemical.sampleChemicalID);
        if(chemical.sampleChemicalID.intValue == 0)
            chemical.sampleChemicalID = [[mSingleton getPersistentStoreManager] generateIDforNewSampleChemical];
        [chemicalDict setValue:chemical.sampleChemicalID forKey:@"SampleChemicalId"];
        [chemicalDict setValue:currentSample.sampleID forKey:@"SampleId"];
        [chemicalDict setValue:chemical.deleted forKey:@"Deleted"];
        [chemicalDict setValue:chemical.chemicalID forKey:@"ChemicalId"];
        
        [chemArray addObject:chemicalDict];
    }
    
    [[mSingleton getPersistentStoreManager] storeSampleChemicalDetails:chemArray forSample:currentSample];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

#pragma mark - PPEListProtocol

-(void)ppeListBackPressed
{
    [popover dismissPopoverAnimated:YES];
}

-(void)selectedPPE:(NSArray *)array
{
    [_ppeTableView reloadData];
    [self updateChemicalPPETable];
    [popover dismissPopoverAnimated:YES];
    
    NSMutableArray *equipArray = [[NSMutableArray alloc] init];
    for(SampleProtectionEquipment *equipment in _ppeArray)
    {
        NSMutableDictionary *equipDict = [[NSMutableDictionary alloc] init];
        [equipDict setValue:equipment.sampleProtectionEquipment_Name forKey:@"PPE"];
        [equipDict setValue:equipment.sampleProtectionEquipmentID forKey:@"PPEId"];
        [equipDict setValue:currentSample.sampleID forKey:@"SampleId"];
        [equipDict setValue:equipment.deleted forKey:@"Deleted"];
        
        NSLog(@"Equipment Id - %@", equipment.samplePPEId);
        if(equipment.samplePPEId.intValue == 0)
            equipment.samplePPEId = [[mSingleton getPersistentStoreManager] generateIDforNewSampleProtectionEquipment];
        
        [equipDict setValue:equipment.samplePPEId forKey:@"SamplePPEId"];
        
        [equipArray addObject:equipDict];
    }
    
    [[mSingleton getPersistentStoreManager] storeSampleProtectionEquipmentDetails:equipArray forSample:currentSample];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

#pragma mark - TextEditProtocol

-(void)textEditDonePressed:(NSString *)text forDetailType:(TextDetailType)detailType
{
    [self removeTextEditView];
    
    switch (detailType) {
        case Edit_EmployeeName:
        {
            _employeeNameValueLabel.text = text;
            [[mSingleton getPersistentStoreManager] updateSample:currentSample inProject:currentProject forField:FIELD_SAMPLE_EMPLOYEE_NAME withValue:text];
        }
            break;
        case Edit_EmployeeJob:
        {
            _employeeJobValueLabel.text = text;
            [[mSingleton getPersistentStoreManager] updateSample:currentSample inProject:currentProject forField:FIELD_SAMPLE_EMPLOYEE_JOB withValue:text];
        }
            break;
        case Edit_OperationalArea:
        {
            _operationalAreaValueLabel.text = text;
            [[mSingleton getPersistentStoreManager] updateSample:currentSample inProject:currentProject forField:FIELD_SAMPLE_OPERATIONAL_AREA withValue:text];
        }
            break;
        case Edit_Notes:
        {
            _notesValueLabel.text = text;
            [self updateNotes];
        }
            break;
        case Edit_Comments:
        {
            _commentsValueLabel.text = text;
            [self updateComments];
        }
            break;
            
        default:
            break;
    }
}

-(void)textEditCancelPressed
{
    [self removeTextEditView];
}

#pragma mark - MeasurementActiveProtocol

-(void)measurementActiveAddPressed:(MeasurementFields *)measurement
{
    [self removeMeasurementEditView];
    
    NSMutableDictionary *measurementDict = [[NSMutableDictionary alloc] init];
    [measurementDict setValue:measurement.sampleMeasurement_OnTime forKey:@"OnTime"];
    [measurementDict setValue:measurement.sampleMeasurement_OffTime forKey:@"OffTime"];
    [measurementDict setValue:measurement.sampleMeasurement_OnFlowRate forKey:@"OnFlowRate"];
    [measurementDict setValue:measurement.sampleMeasurement_OffFlowRate forKey:@"OffFlowRate"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Area"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Minutes"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Volume"];
    [measurementDict setValue:currentSample.sample_SampleId forKey:@"SampleId"];
    NSNumber *measurementId = [[mSingleton getPersistentStoreManager] generateIDforNewSampleMeasurement];
    [measurementDict setValue:measurementId forKey:@"MeasurementId"];
    [measurementDict setValue:[NSNumber numberWithBool:FALSE] forKey:@"Deleted"];
    
    NSArray *meaurement = [NSArray arrayWithObject:measurementDict];
    [[mSingleton getPersistentStoreManager] storeSampleMeasurementDetails:meaurement forSample:currentSample];
    
    [_measurementsArray removeAllObjects];
    [_measurementsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleMeasurementforSample:currentSample]];
    
    [_measurementsTableView reloadData];
    [self updateMeasurementTable];
    
    CGPoint bottomOffset = CGPointMake(0, _measurementsScrollView.contentSize.height - _measurementsScrollView.bounds.size.height);
    [_measurementsScrollView setContentOffset:bottomOffset animated:YES];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

-(void)measurementActiveDonePressed:(SampleMeasurement*)measurement
{
    [self removeMeasurementEditView];
    [self updateMeasurementTable];
    
    [[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OnTime withValue:measurement.sampleMeasurement_OnTime];
    [[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OffTime withValue:measurement.sampleMeasurement_OffTime];
    [[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OnFlowRate withValue:measurement.sampleMeasurement_OnFlowRate];
    [[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OffFlowRate withValue:measurement.sampleMeasurement_OffFlowRate];
}

-(void)measurementActiveCancelPressed
{
    [self removeMeasurementEditView];
}

-(void)measurementActiveDeletePressed:(SampleMeasurement*)measurement
{
    [self removeMeasurementEditView];
    [_measurementsArray removeLastObject];
    [self updateMeasurementTable];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

#pragma mark - MeasurementPassiveProtocol

-(void)measurementPassiveAddPressed:(MeasurementFields *)measurement
{
    [self removeMeasurementEditView];
    
    NSMutableDictionary *measurementDict = [[NSMutableDictionary alloc] init];
    [measurementDict setValue:measurement.sampleMeasurement_OnTime forKey:@"OnTime"];
    [measurementDict setValue:measurement.sampleMeasurement_OffTime forKey:@"OffTime"];
    //[measurementDict setValue:measurement.sampleMeasurement_OnFlowRate forKey:@"OnFlowRate"];
    //[measurementDict setValue:measurement.sampleMeasurement_OffFlowRate forKey:@"OffFlowRate"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Area"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Minutes"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Volume"];
    [measurementDict setValue:currentSample.sample_SampleId forKey:@"SampleId"];
    NSNumber *measurementId = [[mSingleton getPersistentStoreManager] generateIDforNewSampleMeasurement];
    [measurementDict setValue:measurementId forKey:@"MeasurementId"];
    [measurementDict setValue:[NSNumber numberWithBool:FALSE] forKey:@"Deleted"];
    
    NSArray *meaurement = [NSArray arrayWithObject:measurementDict];
    [[mSingleton getPersistentStoreManager] storeSampleMeasurementDetails:meaurement forSample:currentSample];
    
    [_measurementsArray removeAllObjects];
    [_measurementsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleMeasurementforSample:currentSample]];
    
    [_measurementsTableView reloadData];
    [self updateMeasurementTable];
    
    CGPoint bottomOffset = CGPointMake(0, _measurementsScrollView.contentSize.height - _measurementsScrollView.bounds.size.height);
    [_measurementsScrollView setContentOffset:bottomOffset animated:YES];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

-(void)measurementPassiveDonePressed:(SampleMeasurement*)measurement
{
    [self removeMeasurementEditView];
    [self updateMeasurementTable];
    
    [[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OnTime withValue:measurement.sampleMeasurement_OnTime];
    [[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OffTime withValue:measurement.sampleMeasurement_OffTime];
    //[[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OnFlowRate withValue:measurement.sampleMeasurement_OnFlowRate];
    //[[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OffFlowRate withValue:measurement.sampleMeasurement_OffFlowRate];
}

-(void)measurementPassiveCancelPressed
{
    [self removeMeasurementEditView];
}

-(void)measurementPassiveDeletePressed:(SampleMeasurement*)measurement
{
    [self removeMeasurementEditView];
    [_measurementsArray removeLastObject];
    [self updateMeasurementTable];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

#pragma mark - MeasurementWipeProtocol

-(void)measurementWipeAddPressed:(MeasurementFields *)measurement
{
    [self removeMeasurementEditView];
    
    NSMutableDictionary *measurementDict = [[NSMutableDictionary alloc] init];
    //[measurementDict setValue:measurement.sampleMeasurement_OnTime forKey:@"OnTime"];
    //[measurementDict setValue:measurement.sampleMeasurement_OffTime forKey:@"OffTime"];
    //[measurementDict setValue:measurement.sampleMeasurement_OnFlowRate forKey:@"OnFlowRate"];
    //[measurementDict setValue:measurement.sampleMeasurement_OffFlowRate forKey:@"OffFlowRate"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Area"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Minutes"];
    [measurementDict setValue:[NSNumber numberWithInt:100] forKey:@"Volume"];
    [measurementDict setValue:currentSample.sample_SampleId forKey:@"SampleId"];
    NSNumber *measurementId = [[mSingleton getPersistentStoreManager] generateIDforNewSampleMeasurement];
    [measurementDict setValue:measurementId forKey:@"MeasurementId"];
    [measurementDict setValue:[NSNumber numberWithBool:FALSE] forKey:@"Deleted"];
    
    NSArray *meaurement = [NSArray arrayWithObject:measurementDict];
    [[mSingleton getPersistentStoreManager] storeSampleMeasurementDetails:meaurement forSample:currentSample];
    
    [_measurementsArray removeAllObjects];
    [_measurementsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleMeasurementforSample:currentSample]];
    
    [_measurementsTableView reloadData];
    [self updateMeasurementTable];
    
    CGPoint bottomOffset = CGPointMake(0, _measurementsScrollView.contentSize.height - _measurementsScrollView.bounds.size.height);
    [_measurementsScrollView setContentOffset:bottomOffset animated:YES];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

-(void)measurementWipeDonePressed:(SampleMeasurement*)measurement
{
    [self removeMeasurementEditView];
    [self updateMeasurementTable];
    
    //[[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OnTime withValue:measurement.sampleMeasurement_OnTime];
    //[[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OffTime withValue:measurement.sampleMeasurement_OffTime];
    //[[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OnFlowRate withValue:measurement.sampleMeasurement_OnFlowRate];
    //[[mSingleton getPersistentStoreManager] updateSampleMeasurement:measurement inSample:currentSample forField:FIELD_SAMPLEMEASUREMENT_OffFlowRate withValue:measurement.sampleMeasurement_OffFlowRate];
}

-(void)measurementWipeCancelPressed
{
    [self removeMeasurementEditView];
}

-(void)measurementWipeDeletePressed:(SampleMeasurement*)measurement
{
    [self removeMeasurementEditView];
    [_measurementsArray removeLastObject];
    [self updateMeasurementTable];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

-(void)removeMeasurementEditView
{
    MeasurementActiveView *measurementAddEditView = (MeasurementActiveView*)[self.view viewWithTag:FADE_VIEW_TAG];
    if(!measurementAddEditView)
        return;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         measurementAddEditView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [measurementAddEditView removeFromSuperview];
                     }];
}

-(id)isvalidField
{
    if([_sampleTypeValueLabel.text length] <= 0)
        return KVO_SAMPLE_SAMPLE_TYPE;
    if([_deviceTypeValueLabel.text length] <= 0)
        return KVO_SAMPLE_DEVICE_TYPE;
    if([_chemicalsArray count] <= 0)
        return KVO_SAMPLE_SC;
    if([_ppeArray count] <= 0)
        return KVO_SAMPLE_PPE;
    if(!(_btnTWACheck.selected || _btnSTELCheck.selected|| _btnCielingCheck.selected))
        return KVO_SAMPLE_INVALID_FLAG;
    if([_measurementsArray count] <= 0)
        return KVO_SAMPLE_MEASUREMENT;
    
    if(!currentSample)
        return KVO_SAMPLE_INVALID;
    
    return KVO_SAMPLE_VALID;
}

-(BOOL)isvalidForSample:(Sample *)sample
{
    if(!sample)
        return FALSE;
    
    if([sample.deviceType length] <= 0)
        return NO;
    if([sample.airesSampleType.sampleTypeName length] <= 0)
        return NO;
    
    if([[[mSingleton getPersistentStoreManager] getSampleMeasurementforSample:sample] count] <= 0)
        return NO;
    
    return YES;
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setProjectDetailView:nil];
    [self setSampleSubHeaderView:nil];
    [self setAdjustSampleAreaButton:nil];
    [self setAddSampleButton:nil];
    [self setSampleDetailsView:nil];
    [self setSampleMeasurementsView:nil];
    [self setSampleDetailsLabel:nil];
    [self setMeaurementsLabel:nil];
    [self setSampleIdLabel:nil];
    [self setSampleDetailsCollapseButton:nil];
    [self setAddMesaurementButton:nil];
    [self setSampleTypeView:nil];
    [self setOperationalAreaView:nil];
    [self setNotesView:nil];
    [self setCommentsView:nil];
    [self setSampleTypeLabel:nil];
    [self setEmployeeNameLabel:nil];
    [self setOperationalAreaLabel:nil];
    [self setNotesLabel:nil];
    [self setCommentsLabel:nil];
    [self setDeviceTypeLabel:nil];
    [self setEmployeeJobLabel:nil];
    [self setSamplesScrollView:nil];
    [self setChemicalPPEView:nil];
    [self setBtnTWACheck:nil];
    [self setBtnSTELCheck:nil];
    [self setBtnCielingCheck:nil];
    [self setLabelTWA:nil];
    [self setLabelSTEL:nil];
    [self setLabelCieling:nil];
    [self setChemicalsTableView:nil];
    [self setPpeTableView:nil];
    [self setFlagsView:nil];
    [self setSampleTypeValueLabel:nil];
    [self setEmployeeNameValueLabel:nil];
    [self setDeviceTypeValueLabel:nil];
    [self setEmployeeJobValueLabel:nil];
    [self setOperationalAreaValueLabel:nil];
    [self setNotesValueLabel:nil];
    [self setCommentsValueLabel:nil];
    [self setMeasurementsView:nil];
    [self setMeasurementsTableView:nil];
    [self setOnTimeLabel:nil];
    [self setOffTimeLabel:nil];
    [self setOnFlowRateLabel:nil];
    [self setOffFlowRateLabel:nil];
    [self setTotalMeasurementsView:nil];
    [self setMeasurementsScrollView:nil];
    [self setSampleChemicalsLabel:nil];
    [self setPpelabel:nil];
    [super viewDidUnload];
}

@end