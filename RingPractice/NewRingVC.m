//
//  NewRingVCViewController.m
//  RingPractice
//
//  Created by Sue Lee on 9/25/14.
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "NewRingVC.h"

@interface NewRingVC ()

@property (nonatomic, retain) CAShapeLayer *firstRing;
@property (nonatomic, retain) CAShapeLayer *secondRing;
@property (nonatomic, retain) CAShapeLayer *thirdRing;
@property (weak, nonatomic) IBOutlet UILabel *restTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRepLabel;
@property (weak, nonatomic) IBOutlet UILabel *repSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) float timerValue;
@property (nonatomic, assign) float totalDuaration;
@property (nonatomic, strong) NSTimer *autoTimer;
@property (nonatomic, strong) NSTimer *secondRingTimer;
@property (nonatomic, strong) NSTimer *repTimer;
@property (nonatomic, assign) int currentRep;
@property (nonatomic, assign) int currentSet;

@end

@implementation NewRingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabels];
    [self drawSecondBackgroundRing];
    [self drawFirstRingBackgroundRing];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self reset];
}

- (void)updateLabels {
    self.timerValue = 0;
    self.totalDuaration = self.repTime * self.numRep * self.numSet + self.restTime * (self.numSet-1);
    self.repSpeedLabel.text = [NSString stringWithFormat:@"%.1f(s)/Rep, %.1f(s)/Rest)", self.repTime, self.restTime];
    self.restTimeLabel.text = [NSString stringWithFormat:@"Total time:%.1f(s)", self.totalDuaration];
    self.numRepLabel.text = [NSString stringWithFormat:@"(Rep:%d/Set:%d)", self.numRep, self.numSet];
    self.runTimeLabel.text = [NSString stringWithFormat:@"%.f", 0.0];
    self.statusLabel.text = [NSString stringWithFormat:@"Rep (%d),Set(%d)", 1, 1];

}

- (IBAction)runButtonPressed:(id)sender {
    if(self.timerValue > 0) return;
    [self drawRings];
    [self drawRingAnimation:self.firstRing withDuration:self.totalDuaration repetition:1];
    [self secondRingTimer:nil];
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                      target:self selector:@selector(handleTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    self.secondRingTimer = [NSTimer scheduledTimerWithTimeInterval:self.repTime * self.numRep + self.restTime
                                                            target:self
                                                          selector:@selector(secondRingTimer:)
                                                          userInfo:nil
                                                           repeats:YES];
}

- (void) secondRingTimer:(NSTimer *)timer {
    self.currentSet++;
    self.currentRep = 1;
    self.statusLabel.text = [NSString stringWithFormat:@"Rep (%d),Set(%d)", self.currentRep, self.currentSet];
    [self drawRingAnimation:self.secondRing withDuration:self.repTime  * self.numRep repetition:1];
    [self drawRingAnimation:self.thirdRing withDuration:self.repTime repetition:self.numRep];
    [self performSelector:@selector(setStatusLabelTimer) withObject:nil afterDelay:self.repTime * self.numRep];
    self.repTimer = [NSTimer scheduledTimerWithTimeInterval:self.repTime
                                                            target:self
                                                          selector:@selector(setStatusLabeLForRep:)
                                                          userInfo:nil
                                                           repeats:YES];
}

- (void) setStatusLabeLForRep:(NSTimer *)timer {
    self.currentRep ++;
    self.statusLabel.text = [NSString stringWithFormat:@"Rep (%d),Set(%d)", self.currentRep, self.currentSet];
    if (self.currentRep == self.numRep)
        self.currentRep = 0;
}

- (void) setStatusLabelTimer {
    self.statusLabel.text = @"Rest!";
    self.currentRep = 1;
    if(self.repTimer!= nil) { // I need to reset, so that it'll start from the beginning of the second set
        [self.repTimer invalidate];
        self.repTimer = nil;
    }
}

- (IBAction)stopButtonPressed:(id)sender {
    self.statusLabel.text = @"Stop & Reset!";
    self.runTimeLabel.text = @"0";
    [self reset];
}

- (void)reset {
    self.timerValue = 0;
    self.currentRep = 0;
    self.currentSet = 0;
    [self.firstRing removeAllAnimations];
    [self.secondRing removeAllAnimations];
    [self.thirdRing removeAllAnimations];
    [self.view.layer removeAllAnimations];
    
    if(self.autoTimer != nil) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
    if (self.repTimer != nil) {
        [self.repTimer invalidate];
        self.repTimer = nil;
    }
    if (self.secondRingTimer != nil) {
        [self.secondRingTimer invalidate];
        self.secondRingTimer = nil;
    }
    [self.firstRing removeFromSuperlayer];
    [self.secondRing removeFromSuperlayer];
    [self.thirdRing removeFromSuperlayer];
}

- (void) handleTimer:(NSTimer *)timer {
    if (self.timerValue >= self.totalDuaration ) { //total duation
        self.statusLabel.text = @"Done! Good job!";
        self.runTimeLabel.text = [NSString stringWithFormat:@"%.1f", self.totalDuaration ];
        self.timerValue = 0;
        [self reset];
    } else {
        self.runTimeLabel.text = [NSString stringWithFormat:@"%.1f", self.timerValue ];
        self.timerValue += 0.1;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark draw Rings

- (void)drawRings { //out
    self.firstRing=[CAShapeLayer layer];
    [self drawRingWithLayer:self.firstRing
                     radius:125
                strokeColor:[UIColor colorWithRed:.2 green:.2 blue:.3 alpha:.5].CGColor
                  lineWidth:15];
    
    self.secondRing=[CAShapeLayer layer];
    [self drawRingWithLayer:self.secondRing
                     radius:100
                strokeColor:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.5].CGColor
                  lineWidth:15];

    self.thirdRing=[CAShapeLayer layer];
    [self drawRingWithLayer:self.thirdRing
                     radius:80
                strokeColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1].CGColor
                  lineWidth:3];
    
}

- (void)drawFirstRingBackgroundRing {
 
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;
    float totalTime = self.totalDuaration;
    
    float runTimePerSet = self.repTime * self.numRep;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    
    CGFloat runAngle = 2.0 * M_PI * (runTimePerSet/totalTime);
    CGFloat restAngle = 2.0 * M_PI * (self.restTime/totalTime);
    CGFloat outerStartAngle = - M_PI_2 + runAngle;
    
    for (int i=0; i < self.numSet-1; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center
                        radius:130
                    startAngle:outerStartAngle
                      endAngle:(outerStartAngle + restAngle)
                     clockwise:YES];
        
        [path addArcWithCenter:center
                        radius:120
                    startAngle:(outerStartAngle + restAngle)
                      endAngle:outerStartAngle
                     clockwise:NO];
        
        [path closePath];
        
        CGPathAddPath(pathRef, NULL, path.CGPath);
        outerStartAngle += restAngle + runAngle;
    }
    
    CAShapeLayer *firstSegmentRing = [CAShapeLayer layer];
    
    firstSegmentRing=[CAShapeLayer layer];
    firstSegmentRing.fillColor=[UIColor whiteColor].CGColor;
    firstSegmentRing.strokeColor=[UIColor colorWithRed:0 green:0 blue:.8 alpha:.7].CGColor;
    firstSegmentRing.lineWidth=10;
    firstSegmentRing.frame=self.view.frame;
    firstSegmentRing.path=pathRef;
    
    CGPathRelease(pathRef);

    
    UIBezierPath *path2=[UIBezierPath bezierPath];
    
    [path2 addArcWithCenter:center
                     radius:125
                 startAngle:-M_PI_2
                   endAngle:3*M_PI_2
                  clockwise:YES];
    
    CAShapeLayer *firstBackgroundRingLayer = [CAShapeLayer layer];
    firstBackgroundRingLayer=[CAShapeLayer layer];
    firstBackgroundRingLayer.path=path2.CGPath;//46,169,230
    firstBackgroundRingLayer.fillColor= [UIColor clearColor].CGColor;
    firstBackgroundRingLayer.strokeColor=[UIColor colorWithRed:.2 green:.2 blue:.3 alpha:.2].CGColor;
    firstBackgroundRingLayer.lineWidth=15;
    firstBackgroundRingLayer.frame=self.view.frame;
    [path2 closePath];
    
    
    [self.view.layer addSublayer:firstBackgroundRingLayer];
    [self.view.layer addSublayer:firstSegmentRing];
    

}


- (void)drawSecondBackgroundRing {
    
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20);
    UIBezierPath *path2=[UIBezierPath bezierPath];
    
    [path2 addArcWithCenter:center
                     radius:100
                 startAngle:-M_PI_2
                   endAngle:3*M_PI_2
                  clockwise:YES];
    
    CAShapeLayer *secondBackgroundRingLayer = [CAShapeLayer layer];
    
    secondBackgroundRingLayer=[CAShapeLayer layer];
    secondBackgroundRingLayer.path=path2.CGPath;
    secondBackgroundRingLayer.fillColor= [UIColor clearColor].CGColor;
    secondBackgroundRingLayer.strokeColor=[UIColor colorWithRed:.2 green:.2 blue:.3 alpha:.2].CGColor;
    secondBackgroundRingLayer.lineWidth=15;
    secondBackgroundRingLayer.frame=self.view.frame;
    [path2 closePath];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    float segmentSeparationAngle = 2 * M_PI * .1 / self.numRep ;
    CGFloat outerStartAngle = - M_PI_2;
    outerStartAngle += (segmentSeparationAngle / 2.0);
    
    CGFloat outerRingAngle = (2.0 * M_PI) / (self.numRep) - segmentSeparationAngle;
    
    for (int i = 0; i < self.numRep; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center
                        radius:105
                    startAngle:outerStartAngle
                      endAngle:(outerStartAngle + outerRingAngle)
                     clockwise:YES];
        
        [path addArcWithCenter:center
                        radius:95
                    startAngle:(outerStartAngle + outerRingAngle)
                      endAngle:outerStartAngle
                     clockwise:NO];
        
        [path closePath];
        CGPathAddPath(pathRef, NULL, path.CGPath);
        outerStartAngle += (outerRingAngle + segmentSeparationAngle);
    }
    
    CAShapeLayer *secondSegmentRingLayer = [CAShapeLayer layer];
    secondSegmentRingLayer=[CAShapeLayer layer];
    secondSegmentRingLayer.fillColor=[UIColor whiteColor].CGColor;
    secondSegmentRingLayer.strokeColor=[UIColor colorWithRed:.4 green:.4 blue:.4 alpha:.3].CGColor;
    secondSegmentRingLayer.lineWidth=10;
    secondSegmentRingLayer.frame=self.view.frame;
    secondSegmentRingLayer.path=pathRef;
    
    CGPathRelease(pathRef);
    
    [self.view.layer addSublayer:secondBackgroundRingLayer];
    [self.view.layer addSublayer:secondSegmentRingLayer];
}


- (void)drawRingWithLayer:(CAShapeLayer *)layer radius:(CGFloat)radius strokeColor:(CGColorRef)color lineWidth:(CGFloat) lineWidth {
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;

    [path addArcWithCenter:center
                    radius:radius
                startAngle:-M_PI_2
                  endAngle:3*M_PI_2
                 clockwise:YES];
    
    layer.path=path.CGPath;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.strokeColor=color;
    layer.lineWidth=lineWidth;
    layer.frame=self.view.frame;
    [self.view.layer addSublayer:layer];
    [path closePath];
}


-(void)drawRingAnimation:(CALayer*)layer withDuration:(float)duration repetition:(float)repetition
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"]; //out
    bas.duration=duration;
    bas.repeatCount=repetition;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
