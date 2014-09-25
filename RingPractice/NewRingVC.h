//
//  NewRingVCViewController.h
//  RingPractice
//
//  Created by Sue Lee on 9/25/14.
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface NewRingVC : UIViewController

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float firstDuration;
@property (nonatomic, assign) float secondDuration;
@property (nonatomic, assign) int firstRepetition;
@property (nonatomic, assign) int secondRepetition;


@end
