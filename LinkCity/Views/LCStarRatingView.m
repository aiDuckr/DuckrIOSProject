//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "LCStarRatingView.h"

@interface LCStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@property (nonatomic, assign) CGFloat starGap;
@end

@implementation LCStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kNUMBER_OF_STAR starWidth:kSTAR_WIDTH];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _numberOfStar = kNUMBER_OF_STAR;
    _starWidth = kSTAR_WIDTH;
    [self commonInit];
}

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number starWidth:(CGFloat)starWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        _starWidth = starWidth;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.starGap = (self.frame.size.width - _numberOfStar*_starWidth)/(_numberOfStar*2);
    [self setupViews];
}


- (void)setStarWidth:(CGFloat)starWidth{
    _starWidth = starWidth;
    self.starGap = (self.frame.size.width - _numberOfStar*_starWidth)/(_numberOfStar*2);
    
    for (UIView *v in self.subviews){
        [v removeFromSuperview];
    }
    [self setupViews];
}

- (void)setupViews{
    self.starBackgroundView = [self buidlStarViewWithImageName:kBACKGROUND_STAR];
    self.starForegroundView = [self buidlStarViewWithImageName:kFOREGROUND_STAR];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

#pragma mark -
#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate
{
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion
{
//    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0)
    {
        score = 0;
    }
    
    if (score > self.numberOfStar)
    {
        score = self.numberOfStar;
    }
    
    CGPoint point = CGPointMake(score * (self.starWidth + self.starGap*2) - 2, 0);
    
    if(isAnimate)
    {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weakSelf changeStarForegroundViewWithPoint:point];
             
         } completion:^(BOOL finished)
         {
             if (completion)
             {
                 completion(finished);
             }
         }];
    }
    else
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark -
#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         [weakSelf changeStarForegroundViewWithPoint:point];
     }];
}

#pragma mark -
#pragma mark - Buidl Star View

/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    NSLog(@"%f,%f",self.starGap,self.starWidth);
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.frame = CGRectMake(i*(self.starWidth+self.starGap*2)+self.starGap, (frame.size.height-self.starWidth)/2.0, self.starWidth, self.starWidth);
        
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark -
#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSInteger intScore = 0;
    if (p.x <= 0) {
        intScore = 0;
    }else{
        float score = (p.x)/(self.starGap*2 + self.starWidth);
        intScore = (NSInteger)(score+1);
    }
//    NSLog(@"fscore: %f   iScore:%ld",score,(long)intScore);
    
    if (intScore<0) {
        intScore = 0;
    }
    if (intScore>self.numberOfStar) {
        intScore = self.numberOfStar;
    }
    
    p.x = intScore * (self.starWidth + self.starGap*2);
    
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:intScore];
    }
}

@end
