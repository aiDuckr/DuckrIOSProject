//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

/*
 
 - Star - - Star - - Star - - Star -
 
  |  this vertical line divide score 0 ~ 1
 */

#import <UIKit/UIKit.h>
@class LCStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(LCStarRatingView *)view score:(NSInteger)score;

@end

@interface LCStarRatingView : UIView

@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) CGFloat starWidth;

@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number starWidth:(CGFloat)starWidth;

/**
 *  设置控件分数
 *
 *  @param score     分数
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end

#define kBACKGROUND_STAR @"GreyStar"
#define kFOREGROUND_STAR @"YellowStar"
#define kNUMBER_OF_STAR  0
#define kSTAR_WIDTH 30