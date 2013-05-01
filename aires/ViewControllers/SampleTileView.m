//
//  SampleTileView.m
//  aires
//
//  Created by Mani on 5/1/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "SampleTileView.h"

@interface SampleTileView ()
{
    NSUInteger sampleNumber;
    BOOL completedStatus;
    UIButton *sampleButton;
    UILabel *sampleNumberLabel;
    UILabel *sampleIdLabel;
}

@end

@implementation SampleTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sampleButton.frame = CGRectMake(8, 0, 47, 52);
        [sampleButton setImage:[UIImage imageNamed:@"btn_sample_filled_unsel.png"] forState:UIControlStateNormal];
        [sampleButton setImage:[UIImage imageNamed:@"btn_sample_filled_sel.png"] forState:UIControlStateSelected];
        [sampleButton addTarget:self action:@selector(buttonSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sampleButton];
        
        sampleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 25)];
        sampleNumberLabel.backgroundColor = [UIColor clearColor];
        sampleNumberLabel.text = @"8";
        sampleNumberLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
        sampleNumberLabel.textColor = [UIColor colorWithRed:81.0f/255.0f green:93.0f/255.0f blue:125.0f/255.0f alpha:1.0f];
        sampleNumberLabel.shadowColor = [UIColor whiteColor];
        sampleNumberLabel.shadowOffset = CGSizeMake(0, 2);
        [self addSubview:sampleNumberLabel];
        
        sampleIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 60, 15)];
        sampleIdLabel.backgroundColor = [UIColor clearColor];
        sampleIdLabel.text = @"Sample";
        sampleIdLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:10.0f];
        sampleIdLabel.textColor = [UIColor colorWithRed:122.0f/255.0f green:147.0f/255.0f blue:171.0f/255.0f alpha:1.0f];
        sampleIdLabel.shadowColor = [UIColor whiteColor];
        sampleIdLabel.shadowOffset = CGSizeMake(0, 1);
        sampleIdLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:sampleIdLabel];
    }
    return self;
}

-(void)buttonSelected
{
    if(!sampleButton.isSelected)
    {
        [sampleButton setSelected:YES];
        sampleNumberLabel.textColor = [UIColor whiteColor];
        sampleNumberLabel.shadowOffset = CGSizeMake(0, 0);
        sampleIdLabel.textColor = [UIColor whiteColor];
        sampleIdLabel.shadowOffset = CGSizeMake(0, 0);
        
        if(_delegate && [_delegate respondsToSelector:@selector(sampleNumberSelected:)])
        {
            [_delegate sampleNumberSelected:sampleNumber];
        }
    }
}

-(void)setSampleSelected:(BOOL)select
{
    if(select)
    {
        [sampleButton setSelected:YES];
        sampleNumberLabel.textColor = [UIColor whiteColor];
        sampleNumberLabel.shadowOffset = CGSizeMake(0, 0);
        sampleIdLabel.textColor = [UIColor whiteColor];
        sampleIdLabel.shadowOffset = CGSizeMake(0, 0);
    }
    else
    {
        [sampleButton setSelected:NO];
        sampleNumberLabel.textColor = [UIColor colorWithRed:81.0f/255.0f green:93.0f/255.0f blue:125.0f/255.0f alpha:1.0f];
        sampleNumberLabel.shadowOffset = CGSizeMake(0, 2);
        sampleIdLabel.textColor = [UIColor colorWithRed:122.0f/255.0f green:147.0f/255.0f blue:171.0f/255.0f alpha:1.0f];
        sampleIdLabel.shadowOffset = CGSizeMake(0, 1);
    }
}

-(void)setSampleId:(NSString*)sampleId
{
    sampleIdLabel.text = sampleId;
}

-(void)setSampleNumber:(NSUInteger)number
{
    sampleNumber = number;
    sampleNumberLabel.text = [NSString stringWithFormat:@"%d",number];
}

-(void)setSampleCompletedStatus:(BOOL)status
{
    completedStatus = status;
    if(status)
    {
        [sampleButton setImage:[UIImage imageNamed:@"btn_sample_filled_unsel.png"] forState:UIControlStateNormal];
        [sampleButton setImage:[UIImage imageNamed:@"btn_sample_filled_sel.png"] forState:UIControlStateSelected];
    }
    else
    {
        [sampleButton setImage:[UIImage imageNamed:@"btn_sample_unsel.png"] forState:UIControlStateNormal];
        [sampleButton setImage:[UIImage imageNamed:@"btn_sample_sel.png"] forState:UIControlStateSelected];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
