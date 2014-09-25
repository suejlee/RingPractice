//
//  ViewController.h
//  RingPractice
//
//  Created by Sue Lee on 9/23(Tuesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingView.h"

@interface RingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UISlider *startValue;
@property (weak, nonatomic) IBOutlet UISlider *endValue;
@property (nonatomic, assign) float initStartValue;
@property (nonatomic, assign) float initEndValue;
@property (nonatomic, strong) NSNumber *repetition;
@end

