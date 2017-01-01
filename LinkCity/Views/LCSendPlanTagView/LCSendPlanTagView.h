//
//  LCSendPlanTagView.h
//  LinkCity
//
//  Created by lhr on 16/4/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCSendPlanTagView;
@protocol LCSendPlanTagViewDelegate <NSObject>

- (void)didPressLCSendPlanTagView:(LCSendPlanTagView *)view;

@end

@interface LCSendPlanTagView : UIView

@property (nonatomic, weak) id <LCSendPlanTagViewDelegate> delegate;

@property (nonatomic,assign) BOOL isSelected;

- (instancetype)initWithFrame:(CGRect)frame isFixedFrame:(BOOL)isFixed titleString:(NSString *)title;

//- (void)bindWithData;
@end
