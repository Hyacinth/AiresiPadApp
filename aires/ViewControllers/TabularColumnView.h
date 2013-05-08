//
//  TabularColumnView.h
//  aires
//
//  Created by Mani on 5/8/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabularColumnView : UIView

@property(nonatomic) CGFloat horizontalLineYPos;
@property(nonatomic) CGFloat numberOfColumns;
-(void)updateDividerLines;
@end
