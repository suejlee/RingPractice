//
//  RingView.h
//  RingPractice
//
//  Created by Sue Lee on 9/23(Tuesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface RingView : UIView

@property (nonatomic, assign) CGFloat speed1;
@property (nonatomic, assign) CGFloat speed2;

@property (nonatomic, assign) CGFloat fromValue;
@property (nonatomic, assign) CGFloat toValue;
@property (nonatomic, assign) CGFloat self_progress;
@property (nonatomic, assign) CGFloat firstSlider;

- (void)runOneFrom:(CGFloat)from To:(CGFloat)to animated:(BOOL)animated;

@end
