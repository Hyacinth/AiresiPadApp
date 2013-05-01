//
//  SampleTileView.h
//  aires
//
//  Created by Mani on 5/1/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SampleTileViewDelegate;

@interface SampleTileView : UIView

@property(nonatomic) id<SampleTileViewDelegate> delegate;

-(void)setSampleId:(NSString*)sampleId;
-(void)setSampleNumber:(NSUInteger)number;
-(void)setSampleCompletedStatus:(BOOL)status;
-(void)setSampleSelected:(BOOL)select;

@end

@protocol SampleTileViewDelegate <NSObject>

-(void)sampleNumberSelected:(NSUInteger)number;

@end