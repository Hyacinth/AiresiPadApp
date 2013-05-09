//
//  DeviceTypesListViewController.h
//  aires
//
//  Created by Mani on 5/9/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceTypeListProtocol;
@class DeviceType;

@interface DeviceTypesListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceTypesTableView;
@property (nonatomic, retain) id<DeviceTypeListProtocol> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) DeviceType *selectedDeviceType;

@end

@protocol DeviceTypeListProtocol <NSObject>

-(void)deviceTypeSelected:(DeviceType*)deviceType;

@end