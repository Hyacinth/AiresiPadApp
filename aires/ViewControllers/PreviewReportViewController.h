//
//  PreviewReportViewController.h
//  aires
//
//  Created by Gautham on 01/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface PreviewReportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIFont *font12Regular;
    UIFont *font14Regular;
    UIFont *font14Bold;
    UIFont *font16Regular;
    UIFont *font16Bold;
    UIFont *font28Bold;
    UIFont *font48Bold;

    Project *currentProject;
    NSArray *samplesArray;
}

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *TTLabel;
@property (weak, nonatomic) IBOutlet UILabel *labLabel;
@property (weak, nonatomic) IBOutlet UILabel *qcLabel;
@property (weak, nonatomic) IBOutlet UILabel *cpLabel;
@property (weak, nonatomic) IBOutlet UILabel *ttValuelabel;
@property (weak, nonatomic) IBOutlet UILabel *labValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *qcValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *qpValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectDescLabel;
@property (weak, nonatomic) IBOutlet UITableView *projectDetailsTable;

-(void)updateReport:(Project *)project;

@end
