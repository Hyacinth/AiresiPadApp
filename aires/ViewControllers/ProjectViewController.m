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
}

@end

@implementation ProjectViewController

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
    
    _samplesCarousel.type = iCarouselTypeLinear;
    _samplesCarousel.bounceDistance = 0.25f;
    _samplesCarousel.scrollSpeed = 0.75f;
    
    selectedSampleNumber = 1;
    [_samplesCarousel reloadData];
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
                     }
                     completion:^(BOOL finished) {
                         bProjectDetailsVisible = !bProjectDetailsVisible;
                     }];
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
        UIView *aView = [[UIView alloc] initWithFrame:_samplesCarousel.bounds];
        
        for (int i=0; i<14; i++)
        {            
            SampleTileView *tileView = [[SampleTileView alloc] initWithFrame:CGRectMake((i*51), 0, 52, 52)];
            NSUInteger sampleNumber = (index*14)+i+1;
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
    return view;
}

#pragma mark - SampleTileViewDelegate

-(void)sampleNumberSelected:(NSUInteger)number
{
    if(selectedSampleNumber == number)
        return;
    
    SampleTileView *tileView = (SampleTileView*)[_samplesCarousel viewWithTag:selectedSampleNumber];
    if(tileView && [tileView isKindOfClass:[SampleTileView class]])
    {
        [tileView setSampleSelected:NO];
    }
    
    selectedSampleNumber = number;
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
    [self setSamplesCarousel:nil];
    [super viewDidUnload];
}

@end