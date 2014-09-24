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
@property (weak, nonatomic) IBOutlet UILabel *progressPercentage;
@property (weak, nonatomic) IBOutlet UILabel *progressTime;
@property (weak, nonatomic) IBOutlet UILabel *firstSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondSpeedLabel;
@property (weak, nonatomic) IBOutlet UISlider *firstSlider;
@property (weak, nonatomic) IBOutlet UISlider *secondSlider;

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
    [self.ringView runOneFrom:_firstSlider.value To:_secondSlider.value animated:YES];

}

- (IBAction)firstSpeed:(id)sender {
    [self updateUI];
//    [self.ringView setFirstStart:self.firstSlider.value];
}

- (IBAction)secondSpeed:(id)sender {
    [self updateUI];
//    [self.ringView setFirstEnd:self.secondSlider.value];
}

- (IBAction)reset:(id)sender {
    [self.ringView runOneFrom:0 To:0 animated:NO];
}

- (void) updateUI {
    self.firstSpeedLabel.text = [NSString stringWithFormat:@"%.2f", self.firstSlider.value];
    self.secondSpeedLabel.text = [NSString stringWithFormat:@"%.2f", self.secondSlider.value];

    [self.ringView setFirstSlider:self.firstSlider.value];
    [self.ringView setSelf_progress:self.secondSlider.value];
}

@end
