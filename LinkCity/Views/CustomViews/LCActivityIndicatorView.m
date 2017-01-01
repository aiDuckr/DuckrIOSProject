//
//  LCActivityIndicatorView.m
//  LinkCity
//
//  Created by roy on 12/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCActivityIndicatorView.h"

@interface LCActivityIndicatorView()
@property (nonatomic,strong) UIImageView *imgView;
@end;
@implementation LCActivityIndicatorView


static NSInteger animateIndex = 0;
static bool isAnimating = NO;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self customizedInit];
    }
    return self;
}
- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    self = [super init];
    if (self) {
        [self customizedInit];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customizedInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self customizedInit];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    self.imgView.frame = self.bounds;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.imgView.frame = self.bounds;
}
- (void)setAlpha:(CGFloat)alpha{
    [super setAlpha:alpha];
    [self.imgView setAlpha:alpha];
}

- (void)customizedInit{
    self.imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imgView.image = [UIImage imageNamed:@"LoadingA"];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgView];
}

- (void)startAnimating{
    self.hidden = NO;
    isAnimating = YES;
    [self doAnimate];
}
- (void)stopAnimating{
    self.hidden = YES;
    isAnimating = NO;
}
- (BOOL)isAnimating{
    return isAnimating;
}

- (void)doAnimate{
    if (isAnimating) {
        CGFloat rotateAngle = M_PI/6*(++animateIndex%12);
        //RLog(@"rotate angle:%f",rotateAngle);
        CGAffineTransform rotateTrans = CGAffineTransformMakeRotation(rotateAngle);
        self.imgView.transform = rotateTrans;
        [self performSelector:@selector(doAnimate) withObject:nil afterDelay:0.1];
    }else{
        animateIndex = 0;
    }
}


@end
