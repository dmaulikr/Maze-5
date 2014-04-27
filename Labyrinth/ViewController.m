//
//  ViewController.m
//  Labyrinth
//
//  Created by Minh Luu on 4/26/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motion;
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (nonatomic, strong) BallView *ball;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGPoint center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    CGSize ballSize = CGSizeMake(30, 30);
    CGRect frame = CGRectMake(center.x - ballSize.width/2, center.y - ballSize.height/2, ballSize.width, ballSize.height);
    self.ball = [[BallView alloc] initWithFrame:frame];
    
    [self.view addSubview:self.ball];
    
    self.motion = [[CMMotionManager alloc] init];
    
    [self.motion startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self handleAcceleration:accelerometerData];
    }];
}

- (void)handleAcceleration:(CMAccelerometerData *)data
{
    CGFloat x = data.acceleration.x;
    CGFloat y = data.acceleration.y;
    CGFloat z = data.acceleration.z;
    
    self.xLabel.text = [NSString stringWithFormat:@"x: %.2f", x];
    self.yLabel.text = [NSString stringWithFormat:@"y: %.2f", y];
    self.zLabel.text = [NSString stringWithFormat:@"z: %.2f", z];
    
    [self moveBallX:x andY:y];
}

- (void)moveBallX:(CGFloat)dx andY:(CGFloat)dy
{
    self.ball.frame = CGRectMake(self.ball.frame.origin.x + 10 * dx, self.ball.frame.origin.y - 10 * dy, self.ball.frame.size.width, self.ball.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
