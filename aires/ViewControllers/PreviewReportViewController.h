//
//  PreviewReportViewController.h
//  aires
//
//  Created by Gautham on 01/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import <MessageUI/MessageUI.h>


#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            10.0

//Line drawing
#define kLineWidth              1.0

@interface PreviewReportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
    UIFont *font12Regular;
    UIFont *font12Bold;
    UIFont *font14Regular;
    UIFont *font14Bold;
    UIFont *font16Regular;
    UIFont *font16Bold;
    UIFont *font28Bold;
    UIFont *font48Bold;

    Project *currentProject;
    NSArray *samplesArray;

    CGSize pageSize;
    UIAlertView *noNetworkAlert;
    UIAlertView *projectResultAlert;
}

@property (strong, nonatomic) Project *currentProject;

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *unlockButton;
@property (strong, nonatomic) IBOutlet UIButton *sendMailButton;
@property (strong, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *TTLabel;
@property (strong, nonatomic) IBOutlet UILabel *labLabel;
@property (strong, nonatomic) IBOutlet UILabel *qcLabel;
@property (strong, nonatomic) IBOutlet UILabel *cpLabel;
@property (strong, nonatomic) IBOutlet UILabel *ttValuelabel;
@property (strong, nonatomic) IBOutlet UILabel *labValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *qcValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *qpValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *projectDescLabel;
@property (strong, nonatomic) IBOutlet UITableView *projectDetailsTable;
@property (retain, nonatomic) IBOutlet UIScrollView *loadingView;

-(void)updateReport:(Project *)project;
- (IBAction)onSendEmail:(id)sender;
- (IBAction)onClosePreview:(id)sender;
- (IBAction)onUnlockProject:(id)sender;

@end
