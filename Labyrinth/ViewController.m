//
//  ViewController.m
//  Labyrinth
//
//  Created by Minh Luu on 4/26/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import "WallView.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motion;
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (nonatomic, strong) BallView *ball;
@property (nonatomic) CGFloat xSpeed;
@property (nonatomic) CGFloat ySpeed;
@property (nonatomic, strong) NSDate *lastUpdate;

@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) CGPoint previousPoint;
@property (nonatomic) CGFloat xVelocity;
@property (nonatomic) CGFloat yVelocity;

@end

@implementation ViewController

#define kUpdateInterval 1.0f/60.0f

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastUpdate = [NSDate date];
    self.currentPoint = self.view.center;
    
    // Create ball view
    CGSize ballSize = CGSizeMake(30, 30);
    CGRect frame = CGRectMake(self.view.center.x - ballSize.width/2, self.view.center.y - ballSize.height/2, ballSize.width, ballSize.height);
    self.ball = [[BallView alloc] initWithFrame:frame];
    [self.view addSubview:self.ball];
    
    // Create wall...
//    CGRect wallFrame = CGRectMake(10, 10, 100, 20);
//    UIView *wallView = [[UIView alloc] initWithFrame:wallFrame];
//    wallView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:wallView];
    
    // Initiate accelerometer
    self.motion = [[CMMotionManager alloc] init];
    self.motion.accelerometerUpdateInterval = kUpdateInterval;
    [self.motion startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self handleAcceleration:accelerometerData];
    }];
}

#define kScalingFactor 2000

- (void)handleAcceleration:(CMAccelerometerData *)data
{
    NSTimeInterval timeSinceLastDraw = -[self.lastUpdate timeIntervalSinceNow];
    
    CGFloat x = data.acceleration.x;
    CGFloat y = data.acceleration.y;
    CGFloat z = data.acceleration.z;
    
//    self.xLabel.text = [NSString stringWithFormat:@"x: %.2f", x];
//    self.yLabel.text = [NSString stringWithFormat:@"y: %.2f", y];
//    self.zLabel.text = [NSString stringWithFormat:@"z: %.2f", z];
    
    self.xVelocity = self.xVelocity - (x * timeSinceLastDraw);
    self.yVelocity = self.yVelocity - (y * timeSinceLastDraw);
    
    CGFloat dx = timeSinceLastDraw * self.xVelocity * kScalingFactor;
    CGFloat dy = timeSinceLastDraw * self.yVelocity * kScalingFactor;
    
    self.currentPoint = CGPointMake(self.currentPoint.x - dx,
                                    self.currentPoint.y + dy);
    
    [self moveBall];
    
    self.lastUpdate = [NSDate date];
}

- (void)moveBall
{
    self.previousPoint = self.currentPoint;
    
    CGRect frame = self.ball.frame;
    frame.origin = self.currentPoint;
    self.ball.frame = frame;

}

- (void)bounceOffWalls
{
    if (self.ball.frame.origin.x <= 0) {
        self.xSpeed = fabs(self.xSpeed/1.1);
    } else if (self.ball.frame.origin.x >= self.view.bounds.size.width - self.ball.frame.size.width) {
        self.xSpeed = -fabs(self.xSpeed/1.1);
    }
    
    if (self.ball.frame.origin.y <= 0) {
        self.ySpeed = -fabs(self.ySpeed/1.1);
    } else if (self.ball.frame.origin.y >= self.view.bounds.size.height - self.ball.frame.size.height) {
        self.ySpeed = fabs(self.ySpeed/1.1);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
