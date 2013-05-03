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

@interface ProjectViewController ()
{
    BOOL bProjectDetailsVisible;
    NSUInteger selectedSampleNumber;
    NSUInteger numberOfVisibleSamples;
    iCarousel *samplesCarousel;
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
    
    samplesCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(300, 88, 724, 53)];
    samplesCarousel.backgroundColor = [UIColor clearColor];
    samplesCarousel.type = iCarouselTypeLinear;
    samplesCarousel.bounceDistance = 0.25f;
    samplesCarousel.scrollSpeed = 0.75f;
    samplesCarousel.dataSource = self;
    samplesCarousel.delegate = self;
    [self.view  insertSubview:samplesCarousel belowSubview:_projectDetailView];
    
    selectedSampleNumber = 1;
    numberOfVisibleSamples = 14;
    [samplesCarousel reloadData];
    
    _sampleDetailsLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    _sampleIdLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    _meaurementsLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    
    _samplesScrollView.contentSize = CGSizeMake(712, 700);
    
    // top blue line
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(0, 0, 1012, 6.0f);
    blueLayer.backgroundColor = [UIColor colorWithRed:0 green:138.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    [_sampleDetailsView.layer insertSublayer:blueLayer atIndex:0];
    _sampleDetailsView.layer.masksToBounds = YES;
    
    CALayer *blueLayer1 = [CALayer layer];
    blueLayer1.frame = CGRectMake(0, 0, 1012.0f, 6.0f);
    blueLayer1.backgroundColor = [UIColor colorWithRed:0 green:138.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    [_sampleMeasurementsView.layer insertSublayer:blueLayer1 atIndex:0];
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
    
    UIFont *labelFont = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0f];
    _sampleTypeLabel.font = labelFont;
    _employeeNameLabel.font = labelFont;
    _deviceTypeLabel.font = labelFont;
    _employeeJobLabel.font = labelFont;
    _operationalAreaLabel.font = labelFont;
    _notesLabel.font = labelFont;
    _commentsLabel.font = labelFont;
    _labelTWA.font =[UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    _labelSTEL.font =[UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    _labelCieling.font = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    
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
                         _addMesaurementButton.frame = CGRectMake(bProjectDetailsVisible?966:666.0f, 6.0f, 46.0f, 42.0f);
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
                             _sampleTypeView.alpha = alpha;
                             _operationalAreaView.alpha = alpha;
                             _notesView.alpha = alpha;
                             _commentsView.alpha = alpha;
                             _btnTWACheck.alpha = alpha;
                             _chemicalPPEView.alpha = alpha;
                             _btnSTELCheck.alpha = alpha;
                             _btnCielingCheck.alpha= alpha;
                             _labelTWA.alpha =alpha;
                             _labelSTEL.alpha =alpha;
                             _labelCieling.alpha = alpha;
                         }];
    }
    else
    {
        frame.size.height = 523.0f;
        frame1.origin.y = 670.0f;
        frame1.size.height = 44.0f;
        angle = 0;
        alpha = 1.0f;
        [UIView animateWithDuration:0.2
                              delay:0.2f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _sampleTypeView.alpha = alpha;
                             _operationalAreaView.alpha = alpha;
                             _notesView.alpha = alpha;
                             _commentsView.alpha = alpha;
                             _btnTWACheck.alpha = alpha;
                             _chemicalPPEView.alpha = alpha;
                             _btnSTELCheck.alpha = alpha;
                             _btnCielingCheck.alpha= alpha;
                             _labelTWA.alpha =alpha;
                             _labelSTEL.alpha =alpha;
                             _labelCieling.alpha = alpha;
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
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(IBAction)addMeasurement:(id)sender
{
    
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
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    
    [self.navigationController.view.layer
     addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:mPreviewReportViewController animated:YES];
    
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
}

#pragma mark - iCarousel datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)aCarousel
{
    return 2;
}

- (UIView *)carousel:(iCarousel *)aCarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView*)view
{
    if (view == nil)
    {
        // content view
        UIView *aView = [[UIView alloc] initWithFrame:samplesCarousel.bounds];
        
        for (int i=0; i<numberOfVisibleSamples; i++)
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
	return (tableView==_chemicalsTableView)?_chemicalsArray.count:_ppeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"ValueCell";
	
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
    [super viewDidUnload];
}

@end