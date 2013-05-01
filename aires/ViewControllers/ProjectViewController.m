//
//  ProjectViewController.m
//  AiresConsulting
//
//  Created by Mani on 4/22/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectDetailView.h"

@interface ProjectViewController ()
{
    BOOL bProjectDetailsVisible;
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
        
        for (int i=0; i<12; i++)
        {
            // content view
            UIView *sView = [[UIView alloc] initWithFrame:CGRectMake((i*60), 0, 60, 52)];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(7, 0, 47, 52);
            [button setImage:[UIImage imageNamed:@"btn_sample_filled_unsel.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_sample_filled_sel.png"] forState:UIControlStateSelected];
            [sView addSubview:button];
            [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%d", (index*12) + (i+1)];
            label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
            label.textColor = [UIColor colorWithRed:81.0f/255.0f green:93.0f/255.0f blue:125.0f/255.0f alpha:1.0f];
            label.shadowColor = [UIColor whiteColor];
            label.shadowOffset = CGSizeMake(0, 2);
            [sView addSubview:label];
            
            UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 60, 15)];
            sLabel.backgroundColor = [UIColor clearColor];
            sLabel.text = @"Sample";
            sLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:10.0f];
            sLabel.textColor = [UIColor colorWithRed:122.0f/255.0f green:147.0f/255.0f blue:171.0f/255.0f alpha:1.0f];
            sLabel.shadowColor = [UIColor whiteColor];
            sLabel.shadowOffset = CGSizeMake(0, 1);
            sLabel.textAlignment = UITextAlignmentCenter;
            [sView addSubview:sLabel];

            [aView addSubview:sView];
        }
        
        return aView;
    }
    return view;
}

-(void)buttonSelected:(UIButton*)button
{
    [button setSelected:!button.isSelected];
}

#pragma mark - iCarousel delegate

-(void)carousel:(iCarousel *)aCarousel didSelectItemAtIndex:(NSInteger)index
{

}

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
