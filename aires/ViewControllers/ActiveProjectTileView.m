//
//  ActiveProjectTileView.m
//  AiresConsulting
//
//  Created by Mani on 4/19/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import "ActiveProjectTileView.h"
#import <QuartzCore/QuartzCore.h>
#import "Project.h"

@interface ActiveProjectTileView ()
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

@implementation ActiveProjectTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = YES;
        self.layer.shadowRadius = 15.0f;
        self.layer.shadowOpacity = 0.75f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        // top blue line
        CALayer *blueLayer = [CALayer layer];
        blueLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 6.0f);
        blueLayer.backgroundColor = [UIColor colorWithRed:0 green:138.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
        [self.layer insertSublayer:blueLayer atIndex:0];
        // mask for corner radius
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:blueLayer.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(6.0, 6.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = blueLayer.bounds;
        maskLayer.path = maskPath.CGPath;
        blueLayer.mask = maskLayer;
        
        dateFont = [UIFont fontWithName:@"ProximaNova-Bold" size:48.0f];
        dayFont = [UIFont fontWithName:@"ProximaNova-Bold" size:16.0f];
        monthYearFont = [UIFont fontWithName:@"ProximaNova-Regular" size:16.0f];
        titleFont = [UIFont fontWithName:@"ProximaNova-Bold" size:28.0f];
        clientFont = [UIFont fontWithName:@"ProximaNova-Regular" size:24.0f];
        font12Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
        font14Regular = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
        font14Bold = [UIFont fontWithName:@"ProximaNova-Bold" size:14.0f];
        
        clockImage = [UIImage imageNamed:@"clock.png"];
        qcImage = [UIImage imageNamed:@"lab.png"];
        contactImage = [UIImage imageNamed:@"buddy.png"];
        mapImage = [UIImage imageNamed:@"map.png"];
        phoneImage = [UIImage imageNamed:@"phone.png"];
        
        emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emailButton.frame = CGRectMake(190, 410, 230, 40);

        UIImage *bgimage = [UIImage imageNamed:@"btn_contact_bg.png"];
        bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
        
        [emailButton setBackgroundImage:bgimage forState:UIControlStateNormal];
        [self addSubview:emailButton];
        
        [emailButton setImage:[UIImage imageNamed:@"email.png"] forState:UIControlStateNormal];
        //[emailButton setTitle:_project.project_ContactEmail forState:UIControlStateNormal];
        [emailButton setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [emailButton.titleLabel setFont:font14Bold];
        
        [emailButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        emailButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        emailButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return self;
}

-(void)setProject:(Project *)project
{
    _project = project;
    [emailButton setTitle:_project.project_ContactEmail forState:UIControlStateNormal];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Create thegradient
    CGFloat colors [] = {
        1.0f, 1.0f, 1.0f, 1.0f,
        227.0f/255.0f, 241.0f/255.0f, 251.0f/255.0f, 1.0
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
    
//    NSDate *now = _project.project_DateOnsite;
//    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
//    [weekday setDateFormat: @"EEEE"];
//    
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:_project.project_DateOnsite];    
//    
//    NSInteger day = [components day];
//    NSInteger month = [components month];
//    NSInteger year = [components year];
    
    [@"25" drawInRect:CGRectMake(40, 40, 60, 40)
             withFont:dateFont
        lineBreakMode:UILineBreakModeTailTruncation
            alignment:UITextAlignmentLeft];
    
    [@"Tuesday" drawInRect:CGRectMake(105, 45, 80, 20)
                   withFont:dayFont
              lineBreakMode:UILineBreakModeTailTruncation
                  alignment:UITextAlignmentLeft];
    
    [@"Jan, 2013" drawInRect:CGRectMake(105, 65, 80, 20)
                   withFont:monthYearFont
              lineBreakMode:UILineBreakModeTailTruncation
                  alignment:UITextAlignmentLeft];
    
    [_project.project_ProjectNumber drawInRect:CGRectMake(40, 105, 630, 20)
                                           withFont:titleFont
                                      lineBreakMode:UILineBreakModeTailTruncation
                                          alignment:UITextAlignmentLeft];
    
    [_project.project_ClientName drawInRect:CGRectMake(40, 135, 630, 20)
                                   withFont:clientFont
                              lineBreakMode:UILineBreakModeTailTruncation
                                  alignment:UITextAlignmentLeft];
    
    [_project.project_ProjectDescription drawInRect:CGRectMake(40, 180, 630, 60)
                                           withFont:font14Regular
                                      lineBreakMode:UILineBreakModeTailTruncation
                                          alignment:UITextAlignmentLeft];
    
    [clockImage drawInRect:CGRectMake(40, 270, 25, 25)];
    
    [@"Turnaround Time" drawInRect:CGRectMake(78, 267, 100, 10)
                   withFont:font12Regular
              lineBreakMode:UILineBreakModeTailTruncation
                  alignment:UITextAlignmentLeft];
    
    [@"4 Hours" drawInRect:CGRectMake(78, 282, 100, 20)
                          withFont:font14Bold
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [qcImage drawInRect:CGRectMake(200, 270, 25, 25)];

    [@"Quality Control" drawInRect:CGRectMake(238, 267, 100, 10)
                          withFont:font12Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [_project.project_QCPerson drawInRect:CGRectMake(238, 282, 100, 20)
                  withFont:font14Bold
             lineBreakMode:UILineBreakModeTailTruncation
                 alignment:UITextAlignmentLeft];
    
    [@"Lab" drawInRect:CGRectMake(368, 267, 100, 10)
                          withFont:font12Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [_project.project_LabName drawInRect:CGRectMake(368, 282, 100, 20)
                     withFont:font14Bold
                lineBreakMode:UILineBreakModeTailTruncation
                    alignment:UITextAlignmentLeft];

    // draw the line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:151.0f/255.0f green:173.0f/255.0f blue:193.0f/255.0f alpha:1.0f].CGColor);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 40, 330); //start at this point
    CGContextAddLineToPoint(context, 650, 330); //draw to this point
    // and now draw the Path!
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:242.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f].CGColor);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 40, 331); //start at this point
    CGContextAddLineToPoint(context, 650, 331); //draw to this point
    // and now draw the Path!
    CGContextStrokePath(context);
    
    [contactImage drawInRect:CGRectMake(40, 365, 25, 25)];

    [@"Contact Person" drawInRect:CGRectMake(78, 362, 100, 10)
                          withFont:font12Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [[NSString stringWithFormat:@"%@ %@", _project.project_ContactFirstName, _project.project_ContactLastName] drawInRect:CGRectMake(78, 377, 100, 20)
                  withFont:font14Bold
             lineBreakMode:UILineBreakModeTailTruncation
                 alignment:UITextAlignmentLeft];
    
    [mapImage drawInRect:CGRectMake(200, 365, 25, 25)];

    [_project.project_LocationAddress drawInRect:CGRectMake(238, 362, 250, 10)
                          withFont:font14Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [_project.project_LocationAddress2 drawInRect:CGRectMake(238, 379, 250, 10)
                     withFont:font14Regular
                lineBreakMode:UILineBreakModeTailTruncation
                    alignment:UITextAlignmentLeft];
    
    [phoneImage drawInRect:CGRectMake(40, 420, 25, 25)];

    [_project.project_ContactPhoneNumber drawInRect:CGRectMake(78, 423, 100, 20)
                       withFont:font14Bold
                  lineBreakMode:UILineBreakModeTailTruncation
                      alignment:UITextAlignmentLeft];
}

@end