//
//  LCCommentScoreView.h
//  LinkCity
//
//  Created by lhr on 16/6/7.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LCCommentScoreViewType)
 {
    LCCommentScoreViewTypePlanDetail,
    LCCommentScoreViewTypeCommonDetail,
};

@interface LCCommentScoreView : UIView


- (instancetype)initWithFrame:(CGRect)frame scoreViewType:(LCCommentScoreViewType)type;

- (void)updateShowWithScore:(NSInteger)score;
@end
