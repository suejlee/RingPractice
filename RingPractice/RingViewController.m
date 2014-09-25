//
//  ViewController.m
//  RingPractice
//
//  Created by Sue Lee on 9/23(Tuesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "RingViewController.h"

@interface RingViewController ()
@property (weak, nonatomic) IBOutlet RingView *ringView;

@end

@implementation RingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startValue.value = self.initStartValue;
    self.endValue.value = self.initEndValue;
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)run:(id)sender {
    [self.ringView runOneFrom:self.startValue.value To:self.endValue.value animated:YES];
}
- (IBAction)nonAnimatedRun:(id)sender {
    [self.ringView runOneFrom:self.startValue.value To:self.endValue.value animated:NO];

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

    [self.ringView setStartPosition:self.startValue.value];
    [self.ringView setCurrentPosition:self.endValue.value];
    [self reset:nil];
}

@end
