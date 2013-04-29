//
//  DashboardSettingsViewController.m
//  aires
//
//  Created by Gautham on 25/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "DashboardSettingsViewController.h"
#import "AiresSingleton.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface DashboardSettingsViewController ()

@end

@implementation DashboardSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setScrollEnabled:FALSE];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!rememberPasswordSwitch)
        rememberPasswordSwitch = [[UISwitch alloc] init];
    BOOL switchValue = [[[mSingleton getSecurityManager] getValueForKey:LOGIN_AUTOLOGIN] boolValue];
    [rememberPasswordSwitch setOn:switchValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DashboardSettingsViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            if (!rememberPasswordSwitch)
                rememberPasswordSwitch = [[UISwitch alloc] init];
            BOOL switchValue = [[[mSingleton getSecurityManager] getValueForKey:LOGIN_AUTOLOGIN] boolValue];
            [rememberPasswordSwitch setOn:switchValue];
            [rememberPasswordSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = rememberPasswordSwitch;
            cell.textLabel.text = @"Remember Password";
            break;
        case 1:
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"Logout";
            break;
            
        default:
            break;
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            [[mSingleton getWebServiceManager] logout];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UISwitch Method
-(void)switchValueChanged:(id)sender
{
    NSString *switchState = ([rememberPasswordSwitch isOn]) ? @"TRUE" : @"FALSE"; 
    [[mSingleton getSecurityManager] setValue:switchState forKey:LOGIN_AUTOLOGIN];
}

@end
