//
//  LCSendPlanThemeSelectedTagView.h
//  LinkCity
//
//  Created by lhr on 16/4/30.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LCSendPlanThemeSelectedTagView;
@protocol LCSendPlanThemeSelectedTagViewDelegate <NSObject>

- (void)didSelectedThemeWithIndex:(NSInteger)index view:(LCSendPlanThemeSelectedTagView *)view;

@end

@interface LCSendPlanThemeSelectedTagView : UIView

@property (nonatomic,strong) NSArray * itemArray;

@property (weak, nonatomic) id<LCSendPlanThemeSelectedTagViewDelegate> delegate;

- (BOOL)selectItemWithThemeId:(NSInteger)ID;
- (void)setUpWithFrame:(CGRect)frame;
- (void)clearSelection;
@end
