
#import <UIKit/UIKit.h>

@interface RippleEffectView : UIView{
    
    UIImageView *buttonImage;
    CGFloat birderSize;
    UITapGestureRecognizer *tapGesture;
    SEL selectedMethod;
    id senderid;
    UIColor *rippleColor;
    UIColor *bordercolor;
    UIColor *rippleTrailColor;
    NSArray *rippleColors;
    
}
typedef void (^onFinish)(BOOL success);
@property (nonatomic, copy) onFinish block;
@property UILabel *titleLabel;

-(instancetype)initWithImage:(UIImage *)image Frame:(CGRect)frame Color:(UIColor*)bordercolor Target:(SEL)action ID:(id)sender;
-(instancetype)initWithImage:(UIImage *)image Frame:(CGRect)frame didEnd:(onFinish)executeOnFinish;
-(void)setRippleColor:(UIColor *)color;
-(void)setRippleTrailColor:(UIColor *)color;

@end

