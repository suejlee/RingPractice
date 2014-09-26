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
    [self initSecondRing];
    
    self.repSpeedLabel.text = [NSString stringWithFormat:@"Rep Speed %.2f(s)", self.repTime];
    //    self.restTimeLabel.text = [NSString stringWithFormat:@"Rest Time %.2f", self.restTime];
    self.totalDuaration = self.repTime * self.numRep * self.numSet;// + self.restTime * (self.numSet-1);
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
//    if (self.autoTimer != nil) {
//        [self.autoTimer invalidate];
//        self.autoTimer = nil;
//    }
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
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:120 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
    self.firstRing=[CAShapeLayer layer];
    self.firstRing.path=path.CGPath;//46,169,230
    self.firstRing.fillColor= [UIColor clearColor].CGColor;
    self.firstRing.strokeColor=[UIColor grayColor].CGColor;
    self.firstRing.lineWidth=15;
    self.firstRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.firstRing];
}

- (void)initSecondRing { //middle
    UIBezierPath *path1=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(rect.size.width/2,rect.size.height/2-20) ;// CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.width / 2.0);
    
    [path1 addArcWithCenter:center radius:100 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];

    self.secondRing=[CAShapeLayer layer];
    self.secondRing.fillColor=[UIColor clearColor].CGColor;
    self.secondRing.strokeColor=[UIColor blackColor].CGColor;
    self.secondRing.lineWidth=15;
    self.secondRing.frame=self.view.frame;
    self.secondRing.path=path1.CGPath;
    [self.view.layer addSublayer:self.secondRing];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();

    float segmentSeparationAngle = M_PI / (2 * self.numRep);
    CGFloat outerStartAngle = - M_PI_2;
    outerStartAngle += (segmentSeparationAngle / 2.0);
    CGFloat outerRingAngle = (2.0 * M_PI) / (self.numRep) - segmentSeparationAngle;

    for (int i = 0; i < self.numRep; i++) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:100 startAngle:outerStartAngle endAngle:(outerStartAngle + outerRingAngle) clockwise:YES];
        
        [path addArcWithCenter:center radius:85 startAngle:(outerStartAngle + outerRingAngle) endAngle:outerStartAngle clockwise:NO];
        
        [path closePath];
        CGPathAddPath(pathRef, NULL, path.CGPath);
        outerStartAngle += (outerRingAngle + segmentSeparationAngle);
    }
    
    self.secondPlusRing=[CAShapeLayer layer];
    self.secondPlusRing.fillColor=[UIColor clearColor].CGColor;
    self.secondPlusRing.strokeColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:.8].CGColor;
    self.secondPlusRing.lineWidth=15;
    self.secondPlusRing.frame=self.view.frame;
    self.secondPlusRing.path=pathRef;
    
    CGPathRelease(pathRef);

    [self.view.layer addSublayer:self.secondPlusRing];
}

- (void)initThirdRing { //in
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:85 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
    
    self.thirdRing=[CAShapeLayer layer];
    self.thirdRing.path=path.CGPath;//46,169,230
    self.thirdRing.fillColor=[UIColor clearColor].CGColor;
    self.thirdRing.strokeColor=[UIColor grayColor].CGColor;
    self.thirdRing.lineWidth=5;
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
