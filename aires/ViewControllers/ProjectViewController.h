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
#import "PreviewReportViewController.h"
#import "Project.h"

@class ProjectDetailView;

@interface ProjectViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, SampleTileViewDelegate>
{
    PreviewReportViewController *mPreviewReportViewController;
    Project *currentProject;
    NSMutableArray *chemicalsArray;
    NSMutableArray *ppeArray;
}

@property (retain, nonatomic) Project *currentProject;

@property (retain, nonatomic) NSMutableArray *chemicalsArray;
@property (retain, nonatomic) NSMutableArray *ppeArray;

@property (retain, nonatomic) IBOutlet UIButton *homeButton;
@property (retain, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UILabel *samplesLabel;
@property (weak, nonatomic) IBOutlet ProjectDetailView *projectDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *sampleSubHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *adjustSampleAreaButton;
@property (weak, nonatomic) IBOutlet UIButton *addSampleButton;
@property (weak, nonatomic) IBOutlet UILabel *sampleIdLabel;
@property (weak, nonatomic) IBOutlet UIView *sampleDetailsView;
@property (weak, nonatomic) IBOutlet UIView *sampleMeasurementsView;
@property (weak, nonatomic) IBOutlet UILabel *sampleDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaurementsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sampleDetailsCollapseButton;
@property (weak, nonatomic) IBOutlet UIButton *addMesaurementButton;
@property (weak, nonatomic) IBOutlet UIView *sampleTypeView;
@property (weak, nonatomic) IBOutlet UIView *operationalAreaView;
@property (weak, nonatomic) IBOutlet UIView *notesView;
@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet UIScrollView *samplesScrollView;

@property (weak, nonatomic) IBOutlet UILabel *sampleTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeJobLabel;


@property (weak, nonatomic) IBOutlet UILabel *operationalAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (weak, nonatomic) IBOutlet UIView *chemicalPPEView;

@property (weak, nonatomic) IBOutlet UIButton *btnTWACheck;
@property (weak, nonatomic) IBOutlet UIButton *btnSTELCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnCielingCheck;
@property (weak, nonatomic) IBOutlet UILabel *labelTWA;
@property (weak, nonatomic) IBOutlet UILabel *labelSTEL;
@property (weak, nonatomic) IBOutlet UILabel *labelCieling;
@property (weak, nonatomic) IBOutlet UITableView *chemicalsTableView;
@property (weak, nonatomic) IBOutlet UITableView *ppeTableView;
@property (weak, nonatomic) IBOutlet UIView *flagsView;

-(IBAction)checkButtonPressed:(id)sender;
- (IBAction)onGeneratePreview:(id)sender;


@end