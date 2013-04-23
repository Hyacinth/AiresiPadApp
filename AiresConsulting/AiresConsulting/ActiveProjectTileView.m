//
//  ActiveProjectTileView.m
//  AiresConsulting
//
//  Created by Mani on 4/19/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import "ActiveProjectTileView.h"

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
        [emailButton setTitle:@"seanbeckley@gmail.com" forState:UIControlStateNormal];
        [emailButton setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [emailButton.titleLabel setFont:font14Bold];
        
        [emailButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        emailButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        emailButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Get the current context so we can draw.
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	// Set the fill color to white.
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28.0f/255.0f green:34.0f/255.0f blue:39.0f/255.0f alpha:1.0f].CGColor);
    
    [@"28" drawInRect:CGRectMake(40, 40, 60, 40)
             withFont:dateFont
        lineBreakMode:UILineBreakModeTailTruncation
            alignment:UITextAlignmentLeft];
    
    [@"Thursday" drawInRect:CGRectMake(105, 45, 80, 20)
                   withFont:dayFont
              lineBreakMode:UILineBreakModeTailTruncation
                  alignment:UITextAlignmentLeft];
    
    [@"Mar 2013" drawInRect:CGRectMake(105, 65, 80, 20)
                   withFont:monthYearFont
              lineBreakMode:UILineBreakModeTailTruncation
                  alignment:UITextAlignmentLeft];
    
    [@"Risk Assesment for Sigma-Aldrich" drawInRect:CGRectMake(40, 105, 630, 20)
                                           withFont:titleFont
                                      lineBreakMode:UILineBreakModeTailTruncation
                                          alignment:UITextAlignmentLeft];
    
    [@"Sigma-Aldrich" drawInRect:CGRectMake(40, 135, 630, 20)
                        withFont:clientFont
                   lineBreakMode:UILineBreakModeTailTruncation
                       alignment:UITextAlignmentLeft];
    
    [@"Conduct On-site Investigation, Risk Assessment, Building Material Review (Lead, erial RevieMold, Asbestos). Conduct Onerial Revietion, Risk Assessment, Building Material Review (Lead, Mold, Asbestos), Building Material Review (Lead, Mold, Asbestos), Building Material Review (Lead, Mold, Asbestos), Building Material Review (Lead, Mold, Asbestos)."
     drawInRect:CGRectMake(40, 180, 630, 60)
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
    
    [@"Eric Smith" drawInRect:CGRectMake(238, 282, 100, 20)
                  withFont:font14Bold
             lineBreakMode:UILineBreakModeTailTruncation
                 alignment:UITextAlignmentLeft];
    
    [@"Lab" drawInRect:CGRectMake(368, 267, 100, 10)
                          withFont:font12Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [@"013XYZ Lab" drawInRect:CGRectMake(368, 282, 100, 20)
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
    
    [@"Sean Beckley" drawInRect:CGRectMake(78, 377, 100, 20)
                  withFont:font14Bold
             lineBreakMode:UILineBreakModeTailTruncation
                 alignment:UITextAlignmentLeft];
    
    [mapImage drawInRect:CGRectMake(200, 365, 25, 25)];

    [@"3951 Westerre Parkway, Suite 350" drawInRect:CGRectMake(238, 362, 250, 10)
                          withFont:font14Regular
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentLeft];
    
    [@"Richmond, VA 23233" drawInRect:CGRectMake(238, 379, 250, 10)
                     withFont:font14Regular
                lineBreakMode:UILineBreakModeTailTruncation
                    alignment:UITextAlignmentLeft];
    
    [phoneImage drawInRect:CGRectMake(40, 420, 25, 25)];

    [@"(808) 717-421" drawInRect:CGRectMake(78, 423, 100, 20)
                       withFont:font14Bold
                  lineBreakMode:UILineBreakModeTailTruncation
                      alignment:UITextAlignmentLeft];
}

@end
