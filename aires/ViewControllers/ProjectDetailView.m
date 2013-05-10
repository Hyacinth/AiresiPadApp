//
//  ProjectDetailView.m
//  aires
//
//  Created by Mani on 4/29/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "ProjectDetailView.h"
#import "Project.h"
#import <QuartzCore/QuartzCore.h>
#import "AiresSingleton.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface ProjectDetailView ()
{
    UIFont *dateFont;
    UIFont *dayFont;
    UIFont *monthYearFont;
    UIFont *titleFont;
    UIFont *clientFont;
    UIFont *font12Regular;
    UIFont *font14Regular;
    UIFont *font14Bold;
    
    UIImage *clockImage;
    UIImage *qcImage;
    UIImage *contactImage;
    UIImage *mapImage;
    UIImage *phoneImage;
    
    UIButton *emailButton;
}
@end

@implementation ProjectDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initView];
}

-(void)initView
{
    dateFont = [UIFont fontWithName:@"ProximaNova-Bold" size:36.0f];
    dayFont = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0f];
    monthYearFont = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    titleFont = [UIFont fontWithName:@"ProximaNova-Bold" size:18.0f];
    clientFont = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    font12Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    font14Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    font14Bold = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
    
    clockImage = [UIImage imageNamed:@"clock.png"];
    qcImage = [UIImage imageNamed:@"lab.png"];
    contactImage = [UIImage imageNamed:@"buddy.png"];
    mapImage = [UIImage imageNamed:@"map.png"];
    phoneImage = [UIImage imageNamed:@"phone.png"];
    
    emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailButton.frame = CGRectMake(20, 630, 260, 35);
    
    UIImage *bgimage = [UIImage imageNamed:@"btn_contact_bg.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    
    [emailButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    [self addSubview:emailButton];
    
    [emailButton setImage:[UIImage imageNamed:@"email.png"] forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [emailButton.titleLabel setFont:font14Bold];
    
    [emailButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    emailButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    emailButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
}

-(void)setProject:(Project *)project
{
    _project = project;
    [emailButton setTitle:_project.project_ContactEmail forState:UIControlStateNormal];
}

- (void)drawRect:(CGRect)rect
{
    // Create thegradient
    CGFloat colors [] = {
        222.0f/255.0f, 238.0f/255.0f, 254.0f/255.0f, 1.0,
        151.0f/255.0f, 190.0f/255.0f, 222.0f/255.0f, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // Get the current context so we can draw.
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
	// Set the fill color to white.
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f].CGColor);
   
    NSString *now = _project.project_DateOnsite;
    NSDictionary *dateComp = [mSingleton getDateComponentsforString:now];
    NSString *date = [dateComp objectForKey:@"date"];
    NSString *month = [dateComp objectForKey:@"month"];
    NSString *year = [dateComp objectForKey:@"year"];
    NSString *day = [dateComp objectForKey:@"day"];

    [date drawInRect:CGRectMake(20, 25, 45, 40)
             withFont:dateFont
        lineBreakMode:UILineBreakModeTailTruncation
            alignment:UITextAlignmentLeft];
    
    [day drawInRect:CGRectMake(70, 30, 80, 15)
                   withFont:dayFont
              lineBreakMode:UILineBreakModeTailTruncation
                  alignment:UITextAlignmentLeft];
    
    [[NSString stringWithFormat:@"%@ %@",month, year] drawInRect:CGRectMake(70, 43, 80, 15)
                   withFont:monthYearFont
              lineBreakMode:UILineBreakModeTailTruncation
                  alignment:UITextAlignmentLeft];
    
    [_project.project_ProjectNumber drawInRect:CGRectMake(20, 85, 260, 20)
                                           withFont:titleFont
                                      lineBreakMode:UILineBreakModeTailTruncation
                                          alignment:UITextAlignmentLeft];
    
    [_project.project_ClientName drawInRect:CGRectMake(20, 107, 260, 15)
                        withFont:clientFont
                   lineBreakMode:UILineBreakModeTailTruncation
                       alignment:UITextAlignmentLeft];
    
    [_project.project_ProjectDescription
     drawInRect:CGRectMake(20, 145, 250, 80)
     withFont:font12Regular
     lineBreakMode:UILineBreakModeTailTruncation
     alignment:UITextAlignmentLeft];
    
    [clockImage drawInRect:CGRectMake(20, 250, 25, 25)];
    
    [@"Turnaround Time" drawInRect:CGRectMake(60, 247, 100, 10)
                          withFont:font12Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [_project.project_TurnAroundTime drawInRect:CGRectMake(60, 263, 140, 10)
                  withFont:font14Bold
             lineBreakMode:UILineBreakModeTailTruncation
                 alignment:UITextAlignmentLeft];
    
    [qcImage drawInRect:CGRectMake(20, 300, 25, 25)];
    
    [@"Quality Control" drawInRect:CGRectMake(60, 297, 100, 10)
                          withFont:font12Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [_project.project_QCPerson drawInRect:CGRectMake(60, 313, 100, 10)
                     withFont:font14Bold
                lineBreakMode:UILineBreakModeTailTruncation
                    alignment:UITextAlignmentLeft];
    
    [@"Lab" drawInRect:CGRectMake(165, 297, 100, 10)
              withFont:font12Regular
         lineBreakMode:UILineBreakModeTailTruncation
             alignment:UITextAlignmentLeft];
    
    [_project.project_LabName drawInRect:CGRectMake(165, 313, 100, 10)
                     withFont:font14Bold
                lineBreakMode:UILineBreakModeTailTruncation
                    alignment:UITextAlignmentLeft];
        
    [contactImage drawInRect:CGRectMake(20, 480, 25, 25)];
    
    [@"Contact Person" drawInRect:CGRectMake(60, 477, 100, 10)
                         withFont:font12Regular
                    lineBreakMode:UILineBreakModeTailTruncation
                        alignment:UITextAlignmentLeft];
    
    [[NSString stringWithFormat:@"%@ %@", _project.project_ContactFirstName, _project.project_ContactLastName] drawInRect:CGRectMake(60, 493, 100, 20)
                       withFont:font14Bold
                  lineBreakMode:UILineBreakModeTailTruncation
                      alignment:UITextAlignmentLeft];
    
    [mapImage drawInRect:CGRectMake(20, 535, 25, 25)];
    
    [_project.project_LocationAddress drawInRect:CGRectMake(60, 532, 250, 10)
                                           withFont:font14Regular
                                      lineBreakMode:UILineBreakModeTailTruncation
                                          alignment:UITextAlignmentLeft];
    
    [_project.project_LocationAddress2 drawInRect:CGRectMake(60, 548, 250, 10)
                             withFont:font14Regular
                        lineBreakMode:UILineBreakModeTailTruncation
                            alignment:UITextAlignmentLeft];
    
    [phoneImage drawInRect:CGRectMake(20, 585, 25, 25)];
    
    [_project.project_ContactPhoneNumber drawInRect:CGRectMake(60, 590, 100, 10)
                        withFont:font14Bold
                   lineBreakMode:UILineBreakModeTailTruncation
                       alignment:UITextAlignmentLeft];
}

@end