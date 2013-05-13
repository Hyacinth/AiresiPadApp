//
//  SampleTypesListViewController.h
//  aires
//
//  Created by Mani on 5/9/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SampleTypeListProtocol;
@class SampleType;

@interface SampleTypesListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceTypesTableView;
@property (nonatomic, retain) id<SampleTypeListProtocol> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) SampleType *selectedSampleType;

@end

@protocol SampleTypeListProtocol <NSObject>

-(void)sampleTypeSelected:(SampleType*)sampleType;

@end