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


@end

@implementation NewRingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.timerValue = 0;
    //    [self setupRings];
    //    [self initFirstRing];
    [self initSecondRing];
    [self drawSecondBackgroundRing];
    
    self.repSpeedLabel.text = [NSString stringWithFormat:@"Rep(%.2f(s))/Rest(%.2f(s))", self.repTime, self.restTime];
    //    self.restTimeLabel.text = [NSString stringWithFormat:@"Rest Time %.2f", self.restTime];
    self.totalDuaration = self.repTime * self.numRep * self.numSet ;//+ self.restTime * (self.numSet-1);
    self.restTimeLabel.text = [NSString stringWithFormat:@"Total time:%.1f(s)", self.totalDuaration];
    self.numRepLabel.text = [NSString stringWithFormat:@" Rep:%d, Set:%d", self.numRep, self.numSet];
    //    self.numSetLabel.text = [NSString stringWithFormat:@"Number of Sets:%d", self.numSet];
    self.runTimeLabel.text = [NSString stringWithFormat:@"%.f", 0.0];
    
    
}
- (IBAction)runButtonPressed:(id)sender {
    
    [self setupRings];
    [self runRings];
    
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}
- (IBAction)stopButtonPressed:(id)sender {
    [self.firstRing removeAllAnimations];
    [self.secondRing removeAllAnimations];
    [self.thirdRing removeAllAnimations];

}

-(void) setupRings {
    [self initFirstRing];
    [self initSecondRing];
    [self initThirdRing];
}

-(void) runRings {
    
    [self drawRingAnimation:self.firstRing withDuration:self.totalDuaration repetition:1];
    [self drawRingAnimation:self.secondRing withDuration:self.repTime  * self.numRep repetition:self.numSet];
    [self drawRingAnimation:self.thirdRing withDuration:self.repTime repetition:self.numRep * self.numSet];
}

- (void) handleTimer:(NSTimer *)timer {
    if (self.totalDuaration - self.timerValue < 0 ) { //total duation
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
    self.runTimeLabel.text = [NSString stringWithFormat:@"%.1f", self.timerValue ];
    self.timerValue += 0.1;
    
    int currentRep = (int)fmod(self.timerValue/self.repTime, self.numRep)+1;
    int currentSet = (int)(self.timerValue/(self.repTime * self.numRep))+1;
    if (currentSet == self.numSet+1 && currentRep == 1)
        self.statusLabel.text = @"Done! Good job!";
    else
        self.statusLabel.text = [NSString stringWithFormat:@"Rep %d, Set %d", currentRep, currentSet];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initFirstRing { //out
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;
    
    [path addArcWithCenter:center
                    radius:120
                startAngle:-M_PI_2
                  endAngle:3*M_PI_2
                 clockwise:YES];
    
    self.firstRing=[CAShapeLayer layer];
    self.firstRing.path=path.CGPath;//46,169,230
    self.firstRing.fillColor= [UIColor clearColor].CGColor;
    self.firstRing.strokeColor=[UIColor colorWithRed:.2 green:.2 blue:.3 alpha:.5].CGColor;
    
    self.firstRing.lineWidth=20;
    self.firstRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.firstRing];
    
}

- (void)drawSecondBackgroundRing {
    
    
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    float segmentSeparationAngle = M_PI / (2 * self.numRep);
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
    
    self.secondPlusRing=[CAShapeLayer layer];
    self.secondPlusRing.fillColor=[UIColor whiteColor].CGColor;
    self.secondPlusRing.strokeColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:.5].CGColor;
    self.secondPlusRing.lineWidth=20;
    self.secondPlusRing.frame=self.view.frame;
    self.secondPlusRing.path=pathRef;
    
    CGPathRelease(pathRef);
    [self.view.layer addSublayer:self.secondPlusRing];
}


- (void)initSecondRing { //middle
    
//    [self drawSecondBackgroundRing];
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
    self.secondRing.strokeColor=[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:5].CGColor;
    self.secondRing.lineWidth=20;
    self.secondRing.frame=self.view.frame;
    self.secondRing.path=path.CGPath;
    [self.view.layer addSublayer:self.secondRing];
    
}

- (void)initThirdRing { //in
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;
    
    [path addArcWithCenter:center
                    radius:70
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
