//
//  DashboardViewController.m
//  AiresConsulting
//
//  Created by Manigandan Parthasarathi on 24/03/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import "DashboardViewController.h"
#import "ActiveProjectTileView.h"
#import "CompletedProjectTileView.h"
#import "ProjectViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DashboardViewController ()

@end

@implementation DashboardViewController

//@synthesize carousel, carousel2, liveProjectsLabel, completedProjectsLabel, seeAllButton, profileImageView, welcomeLabel, usernameLabel, airesLabel, searchField, searchView, btnSettings, btnRefresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _activeProjectsCarousel.type = iCarouselTypeAires;
    _activeProjectsCarousel.bounceDistance = 0.25f;
    
    _completedProjectsCarousel.type = iCarouselTypeLinear;
    _completedProjectsCarousel.bounceDistance = 0.25f;
    _completedProjectsCarousel.scrollSpeed = 0.6f;
    
    //[self addGradeintToCarousel];
    
    _searchView.layer.cornerRadius = 15.0f;
    
    UIImage *bgimage = [UIImage imageNamed:@"btn_navbar_bg.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    
    [_btnSettings setBackgroundImage:bgimage forState:UIControlStateNormal];
    [_btnRefresh setBackgroundImage:bgimage forState:UIControlStateNormal];
}

-(void)awakeFromNib
{
    [_liveProjectsLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0f]];
    [_completedProjectsLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0f]];
    [_seeAllButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:12.0f]];
    [_welcomeLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:12.0f]];
    [_usernameLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:14.0f]];
    [_airesLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0f]];
    [_searchField setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0f]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)addGradeintToCarousel
{
    // Recreate gradient mask with new fade length
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    CGRect bounds = _activeProjectsCarousel.layer.bounds;
    bounds.origin.y -= 70;
    bounds.size.height += 70;
    
    gradientMask.bounds =  bounds;
    //gradientMask.masksToBounds = YES;
    gradientMask.position = CGPointMake(_activeProjectsCarousel.bounds.size.width/2, _activeProjectsCarousel.bounds.size.height/2);
    
    NSObject *transparent = (NSObject *)[[UIColor clearColor] CGColor];
    NSObject *opaque = (NSObject *)[[UIColor colorWithRed:29.0/255.0 green:32.0/255.0 blue:29.0/255.0 alpha:0.75] CGColor];
    
    gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(_activeProjectsCarousel.frame));
    gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(_activeProjectsCarousel.frame));
    CGFloat fadePoint = 210.0f/_activeProjectsCarousel.frame.size.width;
    [gradientMask setColors: [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil]];
    [gradientMask setLocations: [NSArray arrayWithObjects:
                                 [NSNumber numberWithDouble: 0.0],
                                 [NSNumber numberWithDouble: fadePoint],
                                 [NSNumber numberWithDouble: 1 - fadePoint],
                                 [NSNumber numberWithDouble: 1.0],
                                 nil]];
    _activeProjectsCarousel.layer.mask = gradientMask;
}

#pragma mark - iCarousel datasource

- (UIView *)carousel:(iCarousel *)aCarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView*)view
{
    if(aCarousel == _activeProjectsCarousel)
    {
        if (view == nil)
        {
            UIView *aView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 690, 480)] autorelease];
            aView.backgroundColor = [UIColor clearColor];
            
            // background gradient
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.cornerRadius = 8.0f;
            gradient.frame = CGRectMake(0, 0, aView.frame.size.width, aView.frame.size.height);
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:227.0f/255.0f green:241.0f/255.0f blue:251.0f/255.0f alpha:1.0f] CGColor], nil];
            [aView.layer insertSublayer:gradient atIndex:0];
            
            gradient.shadowRadius = 15.0f;
            gradient.shadowOpacity = 0.75f;
            gradient.shadowColor = [UIColor blackColor].CGColor;
            gradient.shadowPath = [UIBezierPath bezierPathWithRect:aView.bounds].CGPath;
            
            // top blue line
            CALayer *blueLayer = [CALayer layer];
            blueLayer.frame = CGRectMake(0, 0, aView.frame.size.width, 6.0f);
            blueLayer.backgroundColor = [UIColor colorWithRed:0 green:138.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
            [gradient insertSublayer:blueLayer atIndex:0];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:blueLayer.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(6.0, 6.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = blueLayer.bounds;
            maskLayer.path = maskPath.CGPath;
            blueLayer.mask = maskLayer;
            [maskLayer release];
            
            // content view            
            ActiveProjectTileView *tileView = [[[ActiveProjectTileView alloc] initWithFrame:aView.frame] autorelease];
            [aView addSubview:tileView];
            return aView;
        }
        return view;
    }
    else
    {
        if (view == nil)
        {
            UIView *aView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 94)] autorelease];
            aView.backgroundColor = [UIColor clearColor];
            
            // 4 completed projects will be shown at a time
            for (int i=0; i<4; i++)
            {
                // content view
                CompletedProjectTileView *tileView = [[[CompletedProjectTileView alloc] initWithFrame:CGRectMake(i*256, 0, 256, 154)] autorelease];
                [aView addSubview:tileView];
            }            
            return aView;
        }
        return view;
    }
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)aCarousel
{
    return (aCarousel == _activeProjectsCarousel)?5:4;
}

#pragma mark - iCarousel delegate

-(void)carousel:(iCarousel *)aCarousel didSelectItemAtIndex:(NSInteger)index
{
    if(aCarousel == _activeProjectsCarousel && index == _activeProjectsCarousel.currentItemIndex)
    {
        ProjectViewController *projectVC = [[[ProjectViewController alloc] initWithNibName:@"ProjectViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:projectVC animated:YES];
    }
    
    if(aCarousel == _completedProjectsCarousel && index == _completedProjectsCarousel.currentItemIndex)
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setActiveProjectsCarousel:nil];
    [self setCompletedProjectsCarousel:nil];
    [self setLiveProjectsLabel:nil];
    [self setCompletedProjectsLabel:nil];
    [self setSeeAllButton:nil];
    [self setProfileImageView:nil];
    [self setWelcomeLabel:nil];
    [self setUsernameLabel:nil];
    [self setAiresLabel:nil];
    [self setSearchField:nil];
    [self setSearchView:nil];
    [self setBtnSettings:nil];
    [self setBtnRefresh:nil];
    
    [super viewDidUnload];
}


- (void)dealloc
{      
    [_activeProjectsCarousel release];
    [_completedProjectsCarousel release];
    [_liveProjectsLabel release];
    [_completedProjectsLabel release];
    [_seeAllButton release];
    [_profileImageView release];
    [_welcomeLabel release];
    [_usernameLabel release];
    [_airesLabel release];
    [_searchField release];
    [_searchView release];
    [_btnSettings release];
    [_btnRefresh release];
    
    [super dealloc];
}

@end