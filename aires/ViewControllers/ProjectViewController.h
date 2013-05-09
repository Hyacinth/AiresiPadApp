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
#import "TextEditView.h"
#import "MeasurementAddEditView.h"
#import "Project.h"
#import "TabularColumnView.h"
#import "ChemicalsListViewController.h"
#import "PPEListViewController.h"
#import "DeviceTypesListViewController.h"

@class ProjectDetailView;

@interface ProjectViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, SampleTileViewDelegate, UIPopoverControllerDelegate, TextEditProtocol, MeasurementAddEditProtocol, ChemicalsListProtocol, PPEListProtocol, DeviceTypeListProtocol>
{
    PreviewReportViewController *mPreviewReportViewController;
    Project *currentProject;
}

@property (retain, nonatomic) Project *currentProject;
@property (retain, nonatomic) NSMutableArray *samplesArray;
@property (retain, nonatomic) NSMutableArray *deviceTypesArray;
@property (retain, nonatomic) NSMutableArray *chemicalsArray;
@property (retain, nonatomic) NSMutableArray *ppeArray;
@property (retain, nonatomic) NSMutableArray *measurementsArray;

@property (retain, nonatomic) IBOutlet UIButton *homeButton;
@property (retain, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;
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
@property (weak, nonatomic) IBOutlet UILabel *sampleTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeJobLabel;

@property (weak, nonatomic) IBOutlet UILabel *employeeJobValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *operationalAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationalAreaValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsValueLabel;

@property (weak, nonatomic) IBOutlet TabularColumnView *chemicalPPEView;

@property (weak, nonatomic) IBOutlet UIButton *btnTWACheck;
@property (weak, nonatomic) IBOutlet UIButton *btnSTELCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnCielingCheck;
@property (weak, nonatomic) IBOutlet UILabel *labelTWA;
@property (weak, nonatomic) IBOutlet UILabel *labelSTEL;
@property (weak, nonatomic) IBOutlet UILabel *labelCieling;
@property (weak, nonatomic) IBOutlet UITableView *chemicalsTableView;
@property (weak, nonatomic) IBOutlet UITableView *ppeTableView;
@property (weak, nonatomic) IBOutlet UIView *flagsView;
@property (weak, nonatomic) IBOutlet UIScrollView *measurementsScrollView;
@property (weak, nonatomic) IBOutlet TabularColumnView *measurementsView;
@property (weak, nonatomic) IBOutlet UITableView *measurementsTableView;
@property (weak, nonatomic) IBOutlet UILabel *onTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *offTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *onFlowRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *offFlowRateLabel;
@property (weak, nonatomic) IBOutlet UIView *totalMeasurementsView;

-(IBAction)checkButtonPressed:(id)sender;
-(IBAction)onGeneratePreview:(id)sender;
-(IBAction)homeButtonPressed:(id)sender;
-(IBAction)adjustSamplesArea:(id)sender;
-(IBAction)sampleDetailsCollapse:(id)sender;
-(IBAction)addChemical:(id)sender;
-(IBAction)addPPE:(id)sender;
-(IBAction)addMeasurement:(id)sender;

@end