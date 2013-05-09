//
//  DeviceTypesListViewController.m
//  aires
//
//  Created by Mani on 5/9/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "DeviceTypesListViewController.h"
#import "DeviceType.h"

@interface DeviceTypesListViewController ()

@end

@implementation DeviceTypesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17.0f];
    
    [_deviceTypesTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] ;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */    
    
	DeviceType *deviceType = [_listContent objectAtIndex:indexPath.row];
	
    cell.textLabel.text = deviceType.deviceType_DeviceTypeName;
    if([deviceType.deviceType_DeviceTypeName isEqualToString:_selectedDeviceType.deviceType_DeviceTypeName])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DeviceType *deviceType = [_listContent objectAtIndex:indexPath.row];

    if(_delegate && [_delegate respondsToSelector:@selector(deviceTypeSelected:)])
    {
        [_delegate deviceTypeSelected:deviceType];
    }
}

@end
