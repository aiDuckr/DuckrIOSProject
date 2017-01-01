//
//  LCCommentScoreView.m
//  LinkCity
//
//  Created by lhr on 16/6/7.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCommentScoreView.h"

@interface LCCommentScoreView()

@property (nonatomic, strong) UIImage *fullStarImage;

@property (nonatomic, strong) UIImage *halfStarImage;

@property (nonatomic, strong) UIImage *grayStarImage;

@property (nonatomic, strong) UIImageView *starView1;

@property (nonatomic, strong) UIImageView *starView2;

@property (nonatomic, strong) UIImageView *starView3;

@property (nonatomic, strong) UIImageView *starView4;

@property (nonatomic, strong) UIImageView *starView5;

@property (nonatomic, assign) CGFloat starInsetMargin;
@end



@implementation LCCommentScoreView



- (instancetype)initWithFrame:(CGRect)frame scoreViewType:(LCCommentScoreViewType)type {
    self = [super initWithFrame:frame];
    
    if (type == LCCommentScoreViewTypePlanDetail) {
        self.fullStarImage = [UIImage imageNamed:@"PlanDetailFullStarIcon"];
        self.halfStarImage = [UIImage imageNamed:@"PlanDetailHalfStarIcon"];
        self.grayStarImage = [UIImage imageNamed:@"PlanDetailGrayStarIcon"];
        self.starInsetMargin = 5.0;
    } else {
        
        self.fullStarImage = [UIImage imageNamed:@"PlanDetailCommentFullStarIcon"];
        self.halfStarImage = [UIImage imageNamed:@"PlanDetailCommentHalfStarIcon"];
        self.grayStarImage = [UIImage imageNamed:@"PlanDetailCommentGrayStarIcon"];
        self.starInsetMargin = 4.0;
    }
    self.starView1 = [[UIImageView alloc] initWithImage:self.fullStarImage];
    [self.starView1 sizeToFit];
    self.starView2 = [[UIImageView alloc] initWithImage:self.fullStarImage];
    [self.starView2 sizeToFit];
    self.starView3 = [[UIImageView alloc] initWithImage:self.fullStarImage];
    [self.starView3 sizeToFit];
    self.starView4 = [[UIImageView alloc] initWithImage:self.fullStarImage];
    [self.starView4 sizeToFit];
    self.starView5 = [[UIImageView alloc] initWithImage:self.fullStarImage];
    [self.starView5 sizeToFit];
    [self addSubview:self.starView1];
    [self addSubview:self.starView2];
    [self addSubview:self.starView3];
    [self addSubview:self.starView4];
    [self addSubview:self.starView5];
    //[self updateShowWithScore:score];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.starView1.x = 0;
    self.starView1.yCenter = self.height / 2;
    self.starView2.x = self.starView1.maxX + self.starInsetMargin;
    self.starView2.yCenter = self.height / 2;
    self.starView3.x = self.starView2.maxX + self.starInsetMargin;
    self.starView3.yCenter = self.height / 2;
    self.starView4.x = self.starView3.maxX + self.starInsetMargin;
    self.starView4.yCenter = self.height / 2;
    self.starView5.x = self.starView4.maxX + self.starInsetMargin;
    self.starView5.yCenter = self.height / 2;

    
}

- (void)updateShowWithScore:(NSInteger)score {
    self.starView1.image = self.grayStarImage;
    self.starView2.image = self.grayStarImage;
    self.starView3.image = self.grayStarImage;
    self.starView4.image = self.grayStarImage;
    self.starView5.image = self.grayStarImage;
    if (score > 0) {
        if (score >= 1) {
            self.starView1.image = self.fullStarImage;
        } else {
            self.starView1.image = self.halfStarImage;
            return;
        }
    } else {
        return;
    }
    
    if (score > 1) {
        if (score >= 2) {
            self.starView2.image = self.fullStarImage;
        } else {
            self.starView2.image = self.halfStarImage;
            return;
        }
    } else {
        return;
    }
    
    if (score > 2) {
        if (score >= 3) {
            self.starView3.image = self.fullStarImage;
        } else {
            self.starView3.image = self.halfStarImage;
            return;
        }
    } else {
        return;
    }
    
    if (score > 3) {
        if (score >= 4) {
            self.starView4.image = self.fullStarImage;
        } else {
            self.starView4.image = self.halfStarImage;
            return;
        }
    } else {
        return;
    }
    
    if (score > 4) {
        if (score >= 5) {
            self.starView5.image = self.fullStarImage;
        } else {
            self.starView5.image = self.halfStarImage;
            return;
        }
    } else {
        return;
    }
    [self layoutIfNeeded];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
