//
//  RingView.m
//  RingPractice
//
//  Created by Sue Lee on 9/23(Tuesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "RingView.h"

@interface RingView()
@property (nonatomic, assign) CFTimeInterval animationStartTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, retain) CAShapeLayer *backgroundInLayout;
@property (nonatomic, retain) CAShapeLayer *progressInLayout;
//@property (nonatomic, retain) CAShapeLayer *backgroundOutLayer;
//@property (nonatomic, retain) CAShapeLayer *progressOutLayer;
//@property (nonatomic, assign) CGFloat current2;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, assign) CGFloat duration;

@end

@implementation RingView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void) setup {
    self.currentPosition = 0;
    self.duration = 1; // 2 sec
    self.backgroundColor = [UIColor yellowColor];
    
    CGFloat lineWidth =fmax(self.bounds.size.width*.025, 1.0);
    
    self.backgroundInLayout = [CAShapeLayer layer];
    self.backgroundInLayout.strokeColor = [UIColor grayColor].CGColor;
    self.backgroundInLayout.fillColor = nil;
    self.backgroundInLayout.lineCap = kCALineCapRound;
    self.backgroundInLayout.lineWidth = lineWidth;
    [self.layer addSublayer:self.backgroundInLayout];
    
    self.progressInLayout = [CAShapeLayer layer];
    self.progressInLayout.strokeColor = [UIColor purpleColor].CGColor;
    self.progressInLayout.fillColor = nil;
    self.progressInLayout.lineCap = kCALineCapRound;
    self.progressInLayout.lineWidth = lineWidth * 2;
    [self.layer addSublayer:self.progressInLayout];
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 80, 30)];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.contentMode = UIViewContentModeCenter;
    self.label1.font = [UIFont systemFontOfSize:(self.bounds.size.width / 10)];
    self.label1.textColor = [UIColor redColor];
    self.label1.backgroundColor = [UIColor grayColor];
    [self addSubview:self.label1];
}


#pragma mark The animation part

- (void)runOneFrom:(CGFloat)from To:(CGFloat)to animated:(BOOL)animated{
    if (self.currentPosition == to) { // I am already done
        return;
    }
    if (animated == NO) { // when I am moving the slider manually
        if (self.displayLink) {
            [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
        }
        self.currentPosition = to;
        [self setNeedsDisplay];
    }
    else {
        
        self.animationStartTime = CACurrentMediaTime();
        self.fromValue = self.currentPosition;
        self.toValue = to;
        if (!self.displayLink) {
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    CGFloat dt = (displayLink.timestamp - self.animationStartTime) / self.duration;
    if (dt >= 1.0) { // where it stops
        [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        self.displayLink = nil;
        self.currentPosition = self.toValue;
        [self setNeedsDisplay];
        return;
    }
    self.currentPosition = self.fromValue + dt * (self.toValue - self.fromValue);
    [self setNeedsDisplay];
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawBackgroundIn];
    [self drawProgressIn];
}

- (void)drawBackgroundIn
{
    //Create parameters to draw background
    float startAngle = - M_PI_2;
    float endAngle = startAngle + (2.0 * M_PI);
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - self.backgroundInLayout.lineWidth) / 3.0;
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.backgroundInLayout.lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    self.backgroundInLayout.path = path.CGPath;
}


- (void)drawProgressIn
{
    float startAngle = -M_PI_2 + (2.0 * M_PI * self.startPosition);
    float endAngle = -M_PI_2 + (2.0 * M_PI * self.currentPosition);
    if (startAngle > endAngle) {
        startAngle = endAngle;
    }
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - self.backgroundInLayout.lineWidth) / 3.0; // align center of the background
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    path.lineWidth = self.progressInLayout.lineWidth;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    self.progressInLayout.path = path.CGPath;
    
    self.label1.text = [NSString stringWithFormat:@"%.2f", self.currentPosition];
    
    
}

@end
