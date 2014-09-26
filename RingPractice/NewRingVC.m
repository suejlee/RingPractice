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

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *rep1;
@property (weak, nonatomic) IBOutlet UILabel *rep2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation NewRingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initFirstRing];
    [self initSecondRing];
    [self initThirdRing];
    
    self.label1.text = [NSString stringWithFormat:@"%.2f", self.repTime];
    self.label2.text = [NSString stringWithFormat:@"%.2f", self.restTime];
    self.rep1.text = [NSString stringWithFormat:@"%d", self.numRep];
    self.rep2.text = [NSString stringWithFormat:@"%d", self.numSet];
    self.timeLabel.text = [NSString stringWithFormat:@"%f", 0.0];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void) handleTimer:(NSTimer *)timer {
    self.timeLabel.text = timer.description;
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
    [self drawFirstRingAnimation:self.firstRing];
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
    [self drawSecondRingAnimation:self.secondRing];
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
    [self drawThirdRingAnimation:self.thirdRing];
}


-(void)drawFirstRingAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"]; //out
    bas.duration=self.repTime * self.numRep * self.numSet;//self.repTime;
    bas.repeatCount=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)drawSecondRingAnimation:(CALayer *)layer { // middle
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=self.repTime * self.numRep;
    bas.repeatCount=self.numSet;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)drawThirdRingAnimation:(CALayer *)layer { // in
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=self.repTime;
    bas.repeatCount=self.numRep * self.numSet;
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
