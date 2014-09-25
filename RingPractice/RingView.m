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
    _currentPosition = 0;
    _duration = 1; // 2 sec
    self.backgroundColor = [UIColor yellowColor];
    
    CGFloat lineWidth =fmax(self.bounds.size.width*.025, 1.0);
    
    _backgroundInLayout = [CAShapeLayer layer];
    _backgroundInLayout.strokeColor = [UIColor grayColor].CGColor;
    _backgroundInLayout.fillColor = nil;
    _backgroundInLayout.lineCap = kCALineCapRound;
    _backgroundInLayout.lineWidth = lineWidth;
    [self.layer addSublayer:_backgroundInLayout];
    
    _progressInLayout = [CAShapeLayer layer];
    _progressInLayout.strokeColor = [UIColor purpleColor].CGColor;
    _progressInLayout.fillColor = nil;
    _progressInLayout.lineCap = kCALineCapRound;
    _progressInLayout.lineWidth = lineWidth * 2;
    [self.layer addSublayer:_progressInLayout];
    
    _label1 = [[UILabel alloc] init];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.contentMode = UIViewContentModeCenter;
    _label1.font = [UIFont systemFontOfSize:(self.bounds.size.width / 10)];
    _label1.textColor = [UIColor redColor];
    _label1.frame = self.bounds;
    [self addSubview:_label1];
}


#pragma mark The animation part

- (void)runOneFrom:(CGFloat)from To:(CGFloat)to animated:(BOOL)animated{
    if (_currentPosition == to) { // I am already done
        return;
    }
    if (animated == NO) { // when I am moving the slider manually
        if (_displayLink) {
            [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            _displayLink = nil;
        }
        _currentPosition = to;
        [self setNeedsDisplay];
    }
    else {
        
        _animationStartTime = CACurrentMediaTime();
        _fromValue = _currentPosition;
        _toValue = to;
        if (!_displayLink) {
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        }
    }
}


- (void)animateProgress:(CADisplayLink *)displayLink
{
    CGFloat dt = (displayLink.timestamp - _animationStartTime) / _duration;
    if (dt >= 1.0) { // where it stops
        [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        self.displayLink = nil;
        _currentPosition = _toValue;
        [self setNeedsDisplay];
        return;
    }
    _currentPosition = _fromValue + dt * (_toValue - _fromValue);
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
    CGFloat radius = (self.bounds.size.width - _backgroundInLayout.lineWidth) / 3.0;
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = _backgroundInLayout.lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    _backgroundInLayout.path = path.CGPath;
}


- (void)drawProgressIn
{
    float startAngle = -M_PI_2 + (2.0 * M_PI * _startPosition);
    float endAngle = -M_PI_2 + (2.0 * M_PI * _currentPosition);
    if (startAngle > endAngle) {
        startAngle = endAngle;
    }
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundInLayout.lineWidth) / 3.0; // align center of the background
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    path.lineWidth = _progressInLayout.lineWidth;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    _progressInLayout.path = path.CGPath;
    
    _label1.text = [NSString stringWithFormat:@"%.2f", _currentPosition];
    
    
}

@end
