//
//  ViewController.m
//  RingPractice
//
//  Created by Sue Lee on 9/23(Tuesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RingView *ringView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UISlider *startValue;
@property (weak, nonatomic) IBOutlet UISlider *endValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)run:(id)sender {
    [self.ringView runOneFrom:_startValue.value To:_endValue.value animated:YES];
}
- (IBAction)nonAnimatedRun:(id)sender {
    [self.ringView runOneFrom:_startValue.value To:_endValue.value animated:NO];

}

- (IBAction)slide1:(id)sender {
    [self updateUI];
}

- (IBAction)slide2:(id)sender {
    [self updateUI];
}

- (IBAction)reset:(id)sender {
    [self.ringView runOneFrom:0 To:0 animated:NO];
}

- (void) updateUI {
    self.startLabel.text = [NSString stringWithFormat:@"%.2f", self.startValue.value];
    self.endLabel.text = [NSString stringWithFormat:@"%.2f", self.endValue.value];

    [self.ringView setStartPosition:_startValue.value];
    [self.ringView setCurrentPosition:_endValue.value];
    [self reset:nil];
}

@end
