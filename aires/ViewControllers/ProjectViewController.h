//
//  ProjectViewController.h
//  AiresConsulting
//
//  Created by Mani on 4/22/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "SampleTileView.h"

@class ProjectDetailView;

@interface ProjectViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, SampleTileViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *homeButton;
@property (retain, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UILabel *samplesLabel;
@property (weak, nonatomic) IBOutlet ProjectDetailView *projectDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *sampleSubHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *adjustSampleAreaButton;
@property (weak, nonatomic) IBOutlet UIButton *addSampleButton;

@end