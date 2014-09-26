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
@property (weak, nonatomic) IBOutlet UILabel *numSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *repSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;
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
    
    self.repSpeedLabel.text = [NSString stringWithFormat:@"Rep Speed %.2f(s)", self.repTime];
    //    self.restTimeLabel.text = [NSString stringWithFormat:@"Rest Time %.2f", self.restTime];
    self.totalDuaration = self.repTime * self.numRep * self.numSet;
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
    self.firstRing.strokeColor=[UIColor blueColor].CGColor;
    self.firstRing.lineWidth=15;
    self.firstRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.firstRing];
}

- (void)initSecondRing { //middle
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:100 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];

    self.secondRing=[CAShapeLayer layer];
    self.secondRing.path=path.CGPath;//46,169,230
    self.secondRing.fillColor=[UIColor clearColor].CGColor;
    self.secondRing.strokeColor=[UIColor redColor].CGColor;
    self.secondRing.lineWidth=15;
    self.secondRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.secondRing];
}

- (void)initThirdRing { //in
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:90 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
    
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
