//
//  LoginTableCell.m
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "LoginTableCell.h"

@implementation LoginTableCell
@synthesize cellLabel;
@synthesize cellTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(!cellLabel)
            cellLabel = [[UILabel alloc] init];
        
        if(!cellTextField)
            cellTextField = [[UITextField alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
