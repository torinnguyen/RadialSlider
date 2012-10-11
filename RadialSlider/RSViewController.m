//
//  RSViewController.m
//  RadialSlider
//
//  Created by Torin on 11/10/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "RSViewController.h"

@interface RSViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *knob;
@property (nonatomic, weak) IBOutlet UIImageView *background;
@property (nonatomic, weak) IBOutlet UISlider *progressBar;
@property (nonatomic, weak) IBOutlet UILabel *lblUnit;
@property (nonatomic, weak) IBOutlet UILabel *lblDecimal;
@property (nonatomic, weak) IBOutlet UILabel *lblInteger;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat maxAngle;
@end

@implementation RSViewController

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.distance = [self getDistanceFromPoint:self.knob.center toPoint:self.background.center];
  
  CGFloat dx = self.background.center.x - self.knob.center.x;
  CGFloat dy = self.background.center.y - self.knob.center.y;
  self.maxAngle = atan2(dy, dx) * 180 / M_PI;
  
  self.lblUnit.text = @"\%";
}



#pragma mark - Control

- (void)setProgress:(CGFloat)progress
{
  CGFloat angle = 180.0 * progress;
  
  if (progress > 0.5) {
    angle = 180.0f - (progress - 0.5) * 2 * (180.0f - fabs(self.maxAngle));
  }
  else {
    angle = self.maxAngle + progress * 2 * (-180 - self.maxAngle);
  }
  
  [self setAngle:angle];
  [self updateProgressLabel:progress];
}

- (void)setAngle:(CGFloat)angle
{
  CGFloat dx = self.distance * sinf(angle / 180 * M_PI);
  CGFloat dy = self.distance * cosf(angle / 180 * M_PI);
  CGPoint knobCenter = CGPointMake(self.background.center.x + dx, self.background.center.y + dy);
  
  self.knob.transform = CGAffineTransformMakeRotation(-angle / 180 * M_PI);
  self.knob.center = knobCenter;
}

- (void)updateProgressLabel:(CGFloat)prog
{
  NSString *integerString = [NSString stringWithFormat:@"%02d", (int)floor(prog*100)];
  NSString *decimalString = [NSString stringWithFormat:@".%1d", (int)(prog*1000) % 10];
  self.lblInteger.text = integerString;
  self.lblDecimal.text = decimalString;
}

- (IBAction)onProgressBarChanged:(id)sender
{
  self.progress = self.progressBar.value;
}

#pragma mark - Helpers

- (CGFloat)getDistanceFromPoint:(CGPoint)pt1 toPoint:(CGPoint)pt2
{
  CGFloat dx = pt1.x - pt2.x;
  CGFloat dy = pt1.y - pt2.y;
  CGFloat dist = sqrt( dx*dx + dy*dy );
  return dist;
}

@end
