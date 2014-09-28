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
@property (nonatomic, retain) CAShapeLayer *firstPlusRing;
@property (nonatomic, retain) CAShapeLayer *secondRing;
@property (nonatomic, retain) CAShapeLayer *secondPlusRing;
@property (nonatomic, retain) CAShapeLayer *thirdRing;
@property (weak, nonatomic) IBOutlet UILabel *restTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRepLabel;
@property (weak, nonatomic) IBOutlet UILabel *numSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *repSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) float timerValue;
@property (nonatomic, assign) float totalDuaration;
@property (nonatomic, strong) NSTimer *autoTimer;
@property (nonatomic, strong) NSTimer *secondRingTimer;


@end

@implementation NewRingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabels];
    
//    self.view.backgroundColor=[UIColor whiteColor];
    self.timerValue = 0;
    [self drawSecondRing];
    [self drawSecondBackgroundRing];
    [self drawFirstRing];
    [self drawFirstRingBackgroundRing];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self reset];
}

- (void)updateLabels {
    self.repSpeedLabel.text = [NSString stringWithFormat:@"Rep(%.1f(s))/Rest(%.1f(s))", self.repTime, self.restTime];
    //    self.restTimeLabel.text = [NSString stringWithFormat:@"Rest Time %.2f", self.restTime];
    self.totalDuaration = self.repTime * self.numRep * self.numSet + self.restTime * (self.numSet-1);
    self.restTimeLabel.text = [NSString stringWithFormat:@"Total time:%.1f(s)", self.totalDuaration];
    self.numRepLabel.text = [NSString stringWithFormat:@"(Rep:%d/Set:%d)", self.numRep, self.numSet];
    //    self.numSetLabel.text = [NSString stringWithFormat:@"Number of Sets:%d", self.numSet];
    self.runTimeLabel.text = [NSString stringWithFormat:@"%.f", 0.0];
}

- (IBAction)runButtonPressed:(id)sender {
    [self reset];
    
    [self setupRings];
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
    if (self.timerValue >= self.totalDuaration ) { //total duation
        [self.secondRingTimer invalidate];
        self.secondRingTimer = nil;
    }

    [self drawRingAnimation:self.secondRing withDuration:self.repTime  * self.numRep repetition:1];
    [self drawRingAnimation:self.thirdRing withDuration:self.repTime repetition:self.numRep];

}

- (IBAction)stopButtonPressed:(id)sender {
    [self reset];
}

- (void)reset {
    [self.firstRing removeAllAnimations];
    [self.secondRing removeAllAnimations];
    [self.thirdRing removeAllAnimations];
    [self.firstPlusRing removeAllAnimations];
    [self.secondPlusRing removeAllAnimations];
    [self.view.layer removeAllAnimations];
    
    if (self.autoTimer) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
    if (self.secondRingTimer) {
        [self.secondRingTimer invalidate];
        self.secondRingTimer = nil;
    }
}

-(void) setupRings {
    [self drawFirstRing];
    [self drawSecondRing];
    [self drawThirdRing];
}


- (void) handleTimer:(NSTimer *)timer {
    if (self.timerValue >= self.totalDuaration ) { //total duation
        [self.autoTimer invalidate];
        self.autoTimer = nil;
        self.timerValue = self.totalDuaration;
        [self.secondRingTimer invalidate];
        self.secondRingTimer = nil;

    }

    self.runTimeLabel.text = [NSString stringWithFormat:@"%.1f", self.timerValue ];

    int currentRep = (int)fmod(self.timerValue/self.repTime, self.numRep)+1;
    int currentSet = (int)(self.timerValue/(self.repTime * self.numRep))+1;
    if (currentSet == self.numSet+1 && currentRep == 1)
        self.statusLabel.text = @"Done! Good job!";
    else
        self.statusLabel.text = [NSString stringWithFormat:@"Rep(%d)/Set(%d)", currentRep, currentSet];

    self.timerValue += 0.1;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawFirstRing { //out
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;
    
    [path addArcWithCenter:center
                    radius:125
                startAngle:-M_PI_2
                  endAngle:3*M_PI_2
                 clockwise:YES];
    
    self.firstRing=[CAShapeLayer layer];
    self.firstRing.path=path.CGPath;//46,169,230
    self.firstRing.fillColor= [UIColor clearColor].CGColor;
    self.firstRing.strokeColor=[UIColor colorWithRed:.2 green:.2 blue:.3 alpha:.5].CGColor;
    
    self.firstRing.lineWidth=15;
    self.firstRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.firstRing];
    
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
    
    self.firstPlusRing=[CAShapeLayer layer];
    self.firstPlusRing.fillColor=[UIColor whiteColor].CGColor;
    self.firstPlusRing.strokeColor=[UIColor colorWithRed:0 green:0 blue:.8 alpha:.7].CGColor;
    self.firstPlusRing.lineWidth=10;
    self.firstPlusRing.frame=self.view.frame;
    self.firstPlusRing.path=pathRef;
    
    CGPathRelease(pathRef);
    [self.view.layer addSublayer:self.firstPlusRing];
}


- (void)drawSecondBackgroundRing {
    
    
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    float segmentSeparationAngle = 2 * M_PI * .1 / self.numRep ;
    CGFloat outerStartAngle = - M_PI_2;// + segmentSeparationAngle;
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
    
    self.secondPlusRing=[CAShapeLayer layer];
    self.secondPlusRing.fillColor=[UIColor whiteColor].CGColor;
    self.secondPlusRing.strokeColor=[UIColor colorWithRed:1 green:8 blue:8 alpha:.5].CGColor;
    self.secondPlusRing.lineWidth=20;
    self.secondPlusRing.frame=self.view.frame;
    self.secondPlusRing.path=pathRef;
    
    CGPathRelease(pathRef);
    [self.view.layer addSublayer:self.secondPlusRing];
}


- (void)drawSecondRing { //middle
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20);
    
    [path addArcWithCenter:center
                    radius:100
                startAngle:-M_PI_2
                  endAngle:3*M_PI_2
                 clockwise:YES];
    
    self.secondRing=[CAShapeLayer layer];
    self.secondRing.fillColor=[UIColor clearColor].CGColor;
    self.secondRing.strokeColor=[UIColor colorWithRed:.3 green:.2 blue:.2 alpha:4].CGColor;
    self.secondRing.lineWidth=20;
    self.secondRing.frame=self.view.frame;
    self.secondRing.path=path.CGPath;
    [self.view.layer addSublayer:self.secondRing];
    
}

- (void)drawThirdRing { //in
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;
    
    [path addArcWithCenter:center
                    radius:80
                startAngle:-M_PI_2
                  endAngle:3*M_PI_2
                 clockwise:YES];
    
    self.thirdRing=[CAShapeLayer layer];
    self.thirdRing.path=path.CGPath;//46,169,230
    self.thirdRing.fillColor=[UIColor clearColor].CGColor;
    self.thirdRing.strokeColor=[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1].CGColor;
    self.thirdRing.lineWidth=3;
    self.thirdRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.thirdRing];
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
