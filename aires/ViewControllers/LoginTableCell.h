//
//  LoginTableCell.h
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableCell : UITableViewCell
{
    IBOutlet UILabel *cellLabel;
    IBOutlet UITextField *cellTextField;
}

@property(strong, nonatomic) UILabel *cellLabel;
@property(strong, nonatomic) UITextField *cellTextField;

@end
