//
//  WorkoutItem.h
//  RingPractice
//
//  Created by Sue Lee on 9/24(Wednesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkoutItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float start;
@property (nonatomic, assign) float end;
@property (nonatomic, assign) int repetition;
@property (nonatomic, assign) float restingTime;
@property (nonatomic, assign) int numOfSet;
@property (nonatomic, assign) float tempo;

@end
