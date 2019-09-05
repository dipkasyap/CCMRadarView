

#import <QuartzCore/QuartzCore.h>
#import "RippleEffectView.h"

@implementation RippleEffectView

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithFrame: CGRectZero];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


-(void)drawImageWithFrame:(UIImage *)image Frame:(CGRect)frame Color:(UIColor*)bordercolor{
    
    buttonImage = [[UIImageView alloc]initWithImage:image];
    buttonImage.layer.borderColor = [UIColor clearColor].CGColor;
    buttonImage.layer.borderWidth = 3;
    buttonImage.clipsToBounds = YES;
    buttonImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:buttonImage];
    
    buttonImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderWidth = 2;
    self.layer.borderColor = bordercolor.CGColor;
    
    _titleLabel = [UILabel new];
    [self addSubview: _titleLabel];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"tex";
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonTapped:)];
    [self addGestureRecognizer:tapGesture];
    
    //constraints
    [NSLayoutConstraint activateConstraints:
     @[
       [buttonImage.widthAnchor constraintEqualToAnchor: self.widthAnchor multiplier: 0.6],
       [buttonImage.heightAnchor constraintEqualToAnchor: self.heightAnchor multiplier: 0.6],
       [buttonImage.centerXAnchor constraintEqualToAnchor: self.centerXAnchor],
       [buttonImage.centerYAnchor constraintEqualToAnchor: self.centerYAnchor],
       
       [_titleLabel.widthAnchor constraintEqualToAnchor: self.widthAnchor],
       [_titleLabel.heightAnchor constraintEqualToAnchor: self.heightAnchor],
       [_titleLabel.centerXAnchor constraintEqualToAnchor: self.centerXAnchor],
       [_titleLabel.centerYAnchor constraintEqualToAnchor: self.centerYAnchor]
       
       ]
     ];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.frame = rect;
    
    [
     NSTimer
     scheduledTimerWithTimeInterval:1.2
     target:self
     selector:@selector(continuoousripples)
     userInfo:nil
     repeats:YES
     ];
    
    buttonImage.layer.cornerRadius = buttonImage.frame.size.height/2;
    
    
}


-(instancetype)initWithImage:(UIImage *)image
                       Frame:(CGRect)frame
                       Color:(UIColor*)bordercolor
                      Target:(SEL)action
                          ID:(id)sender {
    self = [super initWithFrame:frame];
    
    if(self){
        [self drawImageWithFrame:image Frame:frame Color:bordercolor];
        selectedMethod = action;
        senderid = sender;
    }
    
    return self;
}

-(instancetype)initWithImage:(UIImage *)image
                       Frame:(CGRect)frame
                      didEnd:(onFinish)executeOnFinish {
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self drawImageWithFrame:image Frame:frame Color:bordercolor];
        self.block = executeOnFinish;
    }
    
    return self;
}


-(void)setRippleColor:(UIColor *)color {
    rippleColor = color;
}

-(void)setRippleTrailColor:(UIColor *)color {
    rippleTrailColor = color;
}

-(void)buttonTapped:(id)sender {
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.frame), -CGRectGetMidY(self.frame), self.frame.size.width, self.frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    
    CGPoint shapePosition = [self center];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = rippleTrailColor.CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = rippleColor.CGColor;
    circleShape.lineWidth = 3;
    
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 2.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
    
    //__weak RippleEffectView *weakSelf = self;
    
    [UIView animateWithDuration:1.1 animations:^{
        buttonImage.alpha = 0.4;
        self.layer.borderColor = rippleColor.CGColor;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2.2 animations:^{           //Edit animateWithDuration value to change ripple animtion time
            buttonImage.alpha = 1;
            self.layer.borderColor = rippleColor.CGColor;
        }completion:^(BOOL finished) {
            if([senderid respondsToSelector:selectedMethod]){
                [senderid performSelectorOnMainThread:selectedMethod withObject:nil waitUntilDone:NO];
            }
            
            if(_block) {
                BOOL success= YES;
                _block(success);
            }
        }];
        
    }];
}



-(void)continuoousripples {
    
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.frame), -CGRectGetMidY(self.frame), self.frame.size.width, self.frame.size.height);
   
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    CGPoint shapePosition = [self center];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = rippleTrailColor.CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = rippleColor.CGColor;
    circleShape.lineWidth = 2;
    
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 2.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
}


@end
