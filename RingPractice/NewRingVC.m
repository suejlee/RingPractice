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

@end

@implementation NewRingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self initFirstLayer];
    [self initSecondLayer];
    
    self.label1.text = [NSString stringWithFormat:@"%.2f", self.firstDuration];
    self.label2.text = [NSString stringWithFormat:@"%.2f", self.secondDuration];
    self.rep1.text = [NSString stringWithFormat:@"%d", self.firstRepetition];
    self.rep2.text = [NSString stringWithFormat:@"%d", self.secondRepetition];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initFirstLayer {
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO];
    self.firstRing=[CAShapeLayer layer];
    self.firstRing.path=path.CGPath;//46,169,230
    self.firstRing.fillColor=[UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1].CGColor;
    self.firstRing.strokeColor=[UIColor colorWithWhite:1 alpha:0.7].CGColor;
    self.firstRing.lineWidth=5;
    self.firstRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.firstRing];
    [self drawFirstRingAnimation:self.firstRing];
}

- (void)initSecondLayer {
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:120 startAngle:0 endAngle:2*M_PI clockwise:YES];

    self.secondRing=[CAShapeLayer layer];
    self.secondRing.path=path.CGPath;//46,169,230
    self.secondRing.fillColor=[UIColor clearColor].CGColor;
    self.secondRing.strokeColor=[UIColor redColor].CGColor;
    self.secondRing.lineWidth=10;
    self.secondRing.frame=self.view.frame;
    [self.view.layer addSublayer:self.secondRing];
    [self drawSecondRingAnimation:self.secondRing];
}


-(void)drawFirstRingAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=self.firstDuration;
    bas.repeatCount=self.firstRepetition;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)drawSecondRingAnimation:(CALayer *)layer {
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=self.secondDuration;
    bas.repeatCount=self.secondRepetition;
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
