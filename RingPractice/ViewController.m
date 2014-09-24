//
//  ViewController.m
//  RingPractice
//
//  Created by Sue Lee on 9/23(Tuesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)run:(id)sender {
}

- (IBAction)firstSpeed:(id)sender {
    self.firstSpeedLabel.text = [NSString stringWithFormat:@"%.1f", self.firstSlider.value];
}

- (IBAction)secondSpeed:(id)sender {
    self.secondSpeedLabel.text = [NSString stringWithFormat:@"%.1f", self.secondSlider.value];

}




@end
