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
    [super viewDidUnload];
}

@end
