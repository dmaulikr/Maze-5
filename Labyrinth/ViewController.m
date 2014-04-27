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
#define kBallSize 30

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastUpdate = [NSDate date];
    self.currentPoint = self.view.center;
    
    // Create ball view
    CGRect ballFrame = CGRectMake(0, 0, kBallSize, kBallSize);
    ballFrame.origin = self.currentPoint;
    self.ball = [[BallView alloc] initWithFrame:ballFrame];
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
#define kFriction 1.05

- (void)handleAcceleration:(CMAccelerometerData *)data
{
    NSTimeInterval timeSinceLastDraw = -[self.lastUpdate timeIntervalSinceNow];
    
    CGFloat x = data.acceleration.x;
    CGFloat y = data.acceleration.y;
    CGFloat z = data.acceleration.z;
    
//    self.xLabel.text = [NSString stringWithFormat:@"x: %.2f", x];
//    self.yLabel.text = [NSString stringWithFormat:@"y: %.2f", y];
//    self.zLabel.text = [NSString stringWithFormat:@"z: %.2f", z];
    
    self.xVelocity = (self.xVelocity / kFriction) - (x * timeSinceLastDraw);
    self.yVelocity = (self.yVelocity / kFriction) - (y * timeSinceLastDraw);
    
    CGFloat dx = timeSinceLastDraw * self.xVelocity * kScalingFactor;
    CGFloat dy = timeSinceLastDraw * self.yVelocity * kScalingFactor;
    
    self.currentPoint = CGPointMake(self.currentPoint.x - dx,
                                    self.currentPoint.y + dy);
    
    [self moveBall];
    
    self.lastUpdate = [NSDate date];
}

- (void)moveBall
{
    [self collisionWithBoundaries];
    self.previousPoint = self.currentPoint;
    
    CGRect frame = self.ball.frame;
    frame.origin = self.currentPoint;
    self.ball.frame = frame;

}

#define kReflectionFactor 2

- (void)collisionWithBoundaries {
    
    if (self.currentPoint.x < 0) {
        self.currentPoint = CGPointMake(0, self.currentPoint.y);
        self.xVelocity = -(self.xVelocity / kReflectionFactor);
    }
    
    if (self.currentPoint.y < 0) {
        self.currentPoint = CGPointMake(self.currentPoint.x, 0);
        self.yVelocity = -(self.yVelocity / kReflectionFactor);
    }
    
    if (self.currentPoint.x > self.view.bounds.size.width - self.ball.frame.size.width) {
        _currentPoint.x = self.view.bounds.size.width - self.ball.frame.size.width;
        self.xVelocity = -(self.xVelocity / kReflectionFactor);
    }
    
    if (self.currentPoint.y > self.view.bounds.size.height - self.ball.frame.size.height) {
        _currentPoint.y = self.view.bounds.size.height - self.ball.frame.size.height;
        self.yVelocity = -(self.yVelocity / kReflectionFactor);
    }
    
}

@end
