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

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface ProjectViewController ()
{
    BOOL bProjectDetailsVisible;
    NSUInteger selectedSampleNumber;
    NSUInteger numberOfVisibleSamples;
    iCarousel *samplesCarousel;
    UIPopoverController *popover;
}

@end

@implementation ProjectViewController
@synthesize currentProject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

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
    // _notesView.layer.masksToBounds = YES;
    _commentsView.layer.borderColor = grayColor.CGColor;
    _commentsView.layer.borderWidth = 1.0f;
    _commentsView.layer.cornerRadius = 5.0f;
    //_commentsView.layer.masksToBounds = YES;
    
    _chemicalPPEView.layer.borderColor = grayColor.CGColor;
    _chemicalPPEView.layer.borderWidth = 1.0f;
    _chemicalPPEView.layer.cornerRadius = 5.0f;
    
    _measurementsView.layer.borderColor = grayColor.CGColor;
    _measurementsView.layer.borderWidth = 1.0f;
    _measurementsView.layer.cornerRadius = 5.0f;
    
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
    
    CALayer *grayLine5 = [CALayer layer];
    grayLine5.frame = CGRectMake(112, 0, 1.0f, _notesView.bounds.size.height);
    grayLine5.backgroundColor = grayColor.CGColor;
    [_notesView.layer insertSublayer:grayLine5 atIndex:0];
    
    CALayer *grayLine6 = [CALayer layer];
    grayLine6.frame = CGRectMake(112, 0, 1.0f, _commentsView.bounds.size.height);
    grayLine6.backgroundColor = grayColor.CGColor;
    [_commentsView.layer insertSublayer:grayLine6 atIndex:0];
    
    _chemicalsArray = [[NSMutableArray alloc] initWithObjects:@"Formaldehyde", @"Methylene Chloride", @"Ethylene Oxide", @"Ethanol", @"Zinc Phosphate", @"Oxylene", nil];
    _ppeArray = [[NSMutableArray alloc] initWithObjects:@"Safety Goggles", @"Mask", @"Apron", nil];
    
    [_chemicalsTableView reloadData];
    [_ppeTableView reloadData];
    
    NSUInteger chemicalsCount = _chemicalsArray.count;
    NSUInteger ppeCount = _ppeArray.count;
    NSUInteger moreCount = chemicalsCount>ppeCount?chemicalsCount:ppeCount;
    
    CGRect chemicalPPEFrame = _chemicalPPEView.frame;
    chemicalPPEFrame.size.height = 44.0f/*title*/ + (40.0f/*row height*/ * moreCount);
    _chemicalPPEView.frame = chemicalPPEFrame;
    
    CGRect flagsViewFrame = _flagsView.frame;
    flagsViewFrame.origin.y = _chemicalPPEView.frame.origin.y + _chemicalPPEView.frame.size.height + 20.0f;
    _flagsView.frame = flagsViewFrame;
    
    CALayer *grayLine7 = [CALayer layer];
    grayLine7.frame = CGRectMake(341, 0, 1.0f, _chemicalPPEView.bounds.size.height);
    grayLine7.backgroundColor = grayColor.CGColor;
    [_chemicalPPEView.layer addSublayer:grayLine7];
    
    CALayer *grayLine8 = [CALayer layer];
    grayLine8.frame = CGRectMake(0, 44.0f, _chemicalPPEView.bounds.size.width, 1.0f);
    grayLine8.backgroundColor = grayColor.CGColor;
    [_chemicalPPEView.layer addSublayer:grayLine8];
    
    _samplesScrollView.contentSize = CGSizeMake(_samplesScrollView.frame.size.width, _samplesScrollView.frame.size.height + ( _flagsView.frame.origin.y + _flagsView.frame.size.height + 20.0f - _samplesScrollView.frame.size.height));
    
    UIImage *addMeasurementImage = [UIImage imageNamed:@"btn_contact_bg.png"];
    addMeasurementImage = [addMeasurementImage stretchableImageWithLeftCapWidth:addMeasurementImage.size.width/2 topCapHeight:addMeasurementImage.size.height/2];
    [_addMesaurementButton setBackgroundImage:addMeasurementImage forState:UIControlStateNormal];
    [_addMesaurementButton.titleLabel setFont:font14px];
    
    //[_addMesaurementButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    //_addMesaurementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    //_addMesaurementButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    CGRect measurementsViewFrame = _measurementsView.frame;
    measurementsViewFrame.size.height = 30.0f/*header height*/ + 15/*no. of measurements*/ * 44.0f/*row height*/;
    _measurementsView.frame = measurementsViewFrame;
    
    CGRect measurementsTableViewFrame = _measurementsTableView.frame;
    measurementsTableViewFrame.size.height = 15/*no. of measurements*/ * 44.0f/*row height*/;
    _measurementsTableView.frame = measurementsTableViewFrame;
    
    CGRect totalMeasurementsViewFrame = _totalMeasurementsView.frame;
    totalMeasurementsViewFrame.origin.y = measurementsViewFrame.origin.y + measurementsViewFrame.size.height + 20.0f;
    _totalMeasurementsView.frame = totalMeasurementsViewFrame;
    
    CALayer *grayLine9 = [CALayer layer];
    grayLine9.frame = CGRectMake(170, 0, 1.0f, _measurementsView.bounds.size.height);
    grayLine9.backgroundColor = grayColor.CGColor;
    [_measurementsView.layer addSublayer:grayLine9];
    
    CALayer *grayLine10 = [CALayer layer];
    grayLine10.frame = CGRectMake(341, 0, 1.0f, _measurementsView.bounds.size.height);
    grayLine10.backgroundColor = grayColor.CGColor;
    [_measurementsView.layer addSublayer:grayLine10];
    
    CALayer *grayLine11 = [CALayer layer];
    grayLine11.frame = CGRectMake(512, 0, 1.0f, _measurementsView.bounds.size.height);
    grayLine11.backgroundColor = grayColor.CGColor;
    [_measurementsView.layer addSublayer:grayLine11];
    
    CALayer *grayLine12 = [CALayer layer];
    grayLine12.frame = CGRectMake(0, 30, _measurementsView.bounds.size.width, 1.0f);
    grayLine12.backgroundColor = grayColor.CGColor;
    [_measurementsView.layer addSublayer:grayLine12];
    
    _measurementsScrollView.contentSize = CGSizeMake(_measurementsScrollView.frame.size.width, _measurementsScrollView.frame.size.height + ( _totalMeasurementsView.frame.origin.y + _totalMeasurementsView.frame.size.height + 20.0f - _measurementsScrollView.frame.size.height));
    
    [_btnTWACheck setSelected:NO];
    [_btnSTELCheck setSelected:NO];
    [_btnCielingCheck setSelected:NO];
    
    [self updateSampleNumber:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];   
}

-(void)updateSampleNumber:(NSUInteger)index
{
    Sample *sample = [_samplesArray objectAtIndex:index];
    
    _sampleTypeValueLabel.text = sample.sample_SampleNumber;
    _deviceTypeValueLabel.text = sample.sample_DeviceTypeName;
    _employeeNameValueLabel.text = sample.sample_EmployeeName;
    _employeeJobValueLabel.text = sample.sample_EmployeeJob;
    _operationalAreaValueLabel.text = sample.sample_OperationArea;
    _notesValueLabel.text = sample.sample_Notes;
    _commentsValueLabel.text = sample.sample_Comments;
    
    [_chemicalsArray removeAllObjects];
    [_chemicalsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleChemicalforSample:sample]];
    
    //[_ppeArray removeAllObjects];
    //[_ppeArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getSampleProtectionEquipmentforSample:sample]];
    
    [_chemicalsTableView reloadData];
    [_ppeTableView reloadData];
}

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

-(IBAction)adjustSamplesArea:(id)sender
{
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
                         
                         //[self performSelector:@selector(reloadCarousel) withObject:nil afterDelay:0.25];
                     }];
}

-(void)reloadCarousel
{
    [samplesCarousel reloadData];
}

-(IBAction)sampleDetailsCollapse:(id)sender
{
    UIButton *button = (UIButton*)sender;
    CGFloat alpha = 0;
    CGRect frame = _sampleDetailsView.frame;
    CGRect frame1 = _sampleMeasurementsView.frame;
    CGFloat angle = 0;
    if(frame.size.height == 523.0f)
    {
        frame.size.height = 48.0f;
        frame1.origin.y = 195.0f;
        frame1.size.height = 519.0f;
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
        frame.size.height = 523.0f;
        frame1.origin.y = 670.0f;
        frame1.size.height = 44.0f;
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
                         button.transform = CGAffineTransformMakeRotation(-angle);
                         _sampleDetailsView.frame = frame;
                         _sampleMeasurementsView.frame = frame1;
                         _measurementsScrollView.frame = CGRectMake(0, 57, 712, 452);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(IBAction)addChemical:(id)sender
{
    UIButton *button = (UIButton*)sender;
    ChemicalsListViewController * chemicalListVC = [[ChemicalsListViewController alloc] initWithNibName:@"ChemicalsListViewController" bundle:nil];
    chemicalListVC.listContent = [[mSingleton getPersistentStoreManager] getChemicalList];
    
    if(!popover)
     popover = [[UIPopoverController alloc] initWithContentViewController:chemicalListVC];
    else
    [popover setContentViewController:chemicalListVC];
    
    [popover setPopoverContentSize:CGSizeMake(320, 500)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

}

-(IBAction)addPPE:(id)sender
{
    UIButton *button = (UIButton*)sender;
    PPEListViewController * ppeListVC = [[PPEListViewController alloc] initWithNibName:@"PPEListViewController" bundle:nil];
    ppeListVC.listContent = [[mSingleton getPersistentStoreManager] getProtectionEquipmentList];
    if(!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:ppeListVC];
    else
        [popover setContentViewController:ppeListVC];
    
    [popover setPopoverContentSize:CGSizeMake(320, 300)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

-(IBAction)addMeasurement:(id)sender
{
    UIView *dullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    dullView.tag = 999;
    dullView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    dullView.alpha = 0;
    [self.view addSubview:dullView];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MeasurementAddEditView"owner:self options:nil];
    MeasurementAddEditView *measurementView = (MeasurementAddEditView *)[topLevelObjects objectAtIndex:0];
    measurementView.delegate = self;
    measurementView.editMode = NO;
    measurementView.center = dullView.center;
    [dullView addSubview:measurementView];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         dullView.alpha = 1.0f;
                     }];
}

-(IBAction)checkButtonPressed:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [button setSelected:!button.isSelected];
}

- (IBAction)onGeneratePreview:(id)sender
{
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
    
    selectedSampleNumber = number;
    
    [self updateSampleNumber:number-1];
    [_btnTWACheck setSelected:NO];
    [_btnSTELCheck setSelected:NO];
    [_btnCielingCheck setSelected:NO];
}

#pragma mark - iCarousel datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)aCarousel
{
    return (_samplesArray.count / numberOfVisibleSamples) + 1;
}

- (UIView *)carousel:(iCarousel *)aCarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView*)view
{
    if (view == nil)
    {
        // content view
        UIView *aView = [[UIView alloc] initWithFrame:samplesCarousel.bounds];
        
        for (int i=0; i<_samplesArray.count; i++)
        {
            SampleTileView *tileView = [[SampleTileView alloc] initWithFrame:CGRectMake((i*((numberOfVisibleSamples==14)?51:50.5)), 0, 52, 52)];
            NSUInteger sampleNumber = (index*numberOfVisibleSamples)+i+1;
            tileView.tag = sampleNumber;
            [tileView setSampleId:@"Sample"];
            [tileView setSampleNumber:sampleNumber];
            [tileView setSampleCompletedStatus:sampleNumber%3==0?YES:NO];
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
        return 15;
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = (tableView==_chemicalsTableView)?[_chemicalsArray objectAtIndex:indexPath.row]:
        [_ppeArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    else
    {
        // measurementsTableView
        static NSString *kCellID = @"MeasurementValueCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UIFont *font14px = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
            UIColor *textColor = [UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f];
            
            UILabel *onTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 160, cell.contentView.bounds.size.height)];
            onTimeLabel.backgroundColor = [UIColor clearColor];
            onTimeLabel.font = font14px;
            onTimeLabel.textColor = textColor;
            onTimeLabel.text = @"12:30 pm";
            [cell.contentView addSubview:onTimeLabel];
            
            UILabel *offTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(179, 0, 160, cell.contentView.bounds.size.height)];
            offTimeLabel.backgroundColor = [UIColor clearColor];
            offTimeLabel.font = font14px;
            offTimeLabel.textColor = textColor;
            offTimeLabel.text = @"12:40 pm";
            [cell.contentView addSubview:offTimeLabel];
        
            UILabel *onFlowRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 0, 160, cell.contentView.bounds.size.height)];
            onFlowRateLabel.backgroundColor = [UIColor clearColor];
            onFlowRateLabel.font = font14px;
            onFlowRateLabel.textColor = textColor;
            onFlowRateLabel.text = @"0.5";
            [cell.contentView addSubview:onFlowRateLabel];
            
            UILabel *offFlowRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(521, 0, 160, cell.contentView.bounds.size.height)];
            offFlowRateLabel.backgroundColor = [UIColor clearColor];
            offFlowRateLabel.font = font14px;
            offFlowRateLabel.textColor = textColor;
            offFlowRateLabel.text = @"0.75";
            [cell.contentView addSubview:offFlowRateLabel];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView==_measurementsTableView)
    {
        UIView *dullView = [[UIView alloc] initWithFrame:self.view.bounds];
        dullView.tag = 999;
        dullView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        dullView.alpha = 0;
        [self.view addSubview:dullView];
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MeasurementAddEditView"owner:self options:nil];
        MeasurementAddEditView *measurementView = (MeasurementAddEditView *)[topLevelObjects objectAtIndex:0];
        measurementView.delegate = self;
        measurementView.editMode = TRUE;
        measurementView.center = dullView.center;
        [dullView addSubview:measurementView];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             dullView.alpha = 1.0f;
                         }];
    }
}

#pragma mark - MeasurementAddEditProtocol

-(void)measurementsDonePressed
{
    UIView *dullView = (UIView*)[self.view viewWithTag:999];
    if(!dullView)
        return;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         dullView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [dullView removeFromSuperview];
                     }];
}

-(void)measurementsCancelPressed
{
    UIView *dullView = (UIView*)[self.view viewWithTag:999];
    [dullView removeFromSuperview];
    dullView = nil;
}

-(void)measurementsDeletePressed
{
    
}

#pragma mark - Keyboard

-(void)keyboardWillShow
{
    UIView *dullView = (UIView*)[self.view viewWithTag:999];
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect frame = self.view.bounds;
                         frame.origin.y -= 100.0f;
                         dullView.frame = frame;
                     }];
}

-(void)keyboardWillHide
{
    UIView *dullView = (UIView*)[self.view viewWithTag:999];
    [UIView animateWithDuration:0.25
                     animations:^{
                         dullView.frame = self.view.bounds;
                     }];
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
    [super viewDidUnload];
}

@end