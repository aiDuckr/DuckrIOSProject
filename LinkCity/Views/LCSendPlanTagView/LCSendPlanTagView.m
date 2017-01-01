//
//  LCSendPlanTagView.m
//  LinkCity
//
//  Created by lhr on 16/4/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendPlanTagView.h"
#import "UIView+BlocksKit.h"

@interface LCSendPlanTagView()

@property (nonatomic,strong) UILabel *titleLabel;



@property (nonatomic,assign) BOOL isFixed;

@end

static const CGFloat fixedFontSize = 14.0;
static const CGFloat unFixedFontSize = 13.0;

@implementation LCSendPlanTagView

- (instancetype)initWithFrame:(CGRect)frame isFixedFrame:(BOOL)isFixed titleString:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        //
        self.userInteractionEnabled = YES;
        _titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.isFixed = isFixed;
        if (isFixed) {
            [_titleLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:fixedFontSize]];
            [self.titleLabel sizeToFit];
        } else {
            [_titleLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:unFixedFontSize]];
            [self.titleLabel sizeToFit];
            self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.titleLabel.frame.size.width + 20, frame.size.height);
        }
        self.isSelected = NO;
        self.layer.cornerRadius = 2.5;
        [self addSubview:self.titleLabel];
        [self bk_whenTapped:^{
            [self pressed];
        }];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    UIColor *textColor,*backGroundColor;
    if (isSelected) {
        backGroundColor = UIColorFromRGBA(0xfedd00, 1.0);
        textColor = UIColorFromRGBA(0x6b450a, 1.0);

    } else {
        backGroundColor = UIColorFromRGBA(0xf5f5f3, 1.0);
        textColor = UIColorFromRGBA(0x7d7975, 1.0);
        
    }
    _isSelected = isSelected;
    self.backgroundColor = backGroundColor;
    self.titleLabel.textColor = textColor;
}

//- (void)bindWithData {
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)pressed {
    [self.delegate didPressLCSendPlanTagView:self];
}
@end
