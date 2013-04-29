//
//  LoginSettingsViewController.m
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "LoginSettingsViewController.h"
#import "AiresSingleton.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface LoginSettingsViewController ()

@end

@implementation LoginSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Choose an Environment"];
    //[[mSingleton getWebServiceManager] getEnvironment];
    NSString *env = [[mSingleton getSecurityManager] getValueForKey:LOGIN_ENVIRONMENT];
    if (!env)
        [[mSingleton getSecurityManager] setValue:LOGIN_SETTINGS_PRODUCTION forKey:LOGIN_ENVIRONMENT];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"      Choose an Environment      ";
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Reset login credentials before table loads
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecurityManager *mSecurityManager = [mSingleton getSecurityManager];
    NSString *env = [mSecurityManager getValueForKey:LOGIN_ENVIRONMENT];
    
    static NSString *CellIdentifier = @"LoginSettingsViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = LOGIN_SETTINGS_PRODUCTION;
            break;
        case 1:
            cell.textLabel.text = LOGIN_SETTINGS_STAGE;
            break;
        case 2:
            cell.textLabel.text = LOGIN_SETTINGS_QA;
            break;
        case 3:
            cell.textLabel.text = LOGIN_SETTINGS_DEVELOPMENT;
            break;
            
        default:
            break;
    }
    if ([env isEqualToString:cell.textLabel.text])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SecurityManager *mSecurityManager = [mSingleton getSecurityManager];
    [mSecurityManager setValue:cell.textLabel.text forKey:LOGIN_ENVIRONMENT];
    if ([mSingleton.environmentURLs objectForKey:cell.textLabel.text])
        [mSecurityManager setValue:[mSingleton.environmentURLs objectForKey:cell.textLabel.text] forKey:LOGIN_ENVIRONMENT_URL];
    [tableView reloadData];
}

@end
