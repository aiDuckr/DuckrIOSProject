//
//  LCFilterTagButton.h
//  LinkCity
//
//  Created by 张宗硕 on 8/1/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCFilterTagButton;

typedef enum {
    FilterTagButtonType_Default,
    FilterTagButtonType_Radio,
    FilterTagButtonType_MutSelect,
    FilterTagButtonType_MutWithAll,
} FilterTagButtonType;

typedef enum {
    FilterTagButtonAppearance_Normal,
    FilterTagButtonAppearance_SearchGray,
    FilterTagButtonAppearance_SearchWhite,
} FilterTagButtonAppearance;

@protocol LCFilterTagButtonDelegate <NSObject>
@optional
- (void)filterTagButtonSelected:(LCFilterTagButton *)button;
- (void)filterTagButtonUnSelected:(LCFilterTagButton *)button;

@end

@interface LCFilterTagButton : UIButton
- (void)updateShowButtons:(NSArray *)buttons;
- (void)updateFilterTagButtonStatus:(BOOL)isSelected;
- (void)updateFilterTagButtonApperance:(BOOL)isSelected;
//@property (assign, nonatomic) BOOL isSelected;

@property (assign, nonatomic) FilterTagButtonType type;
@property (assign, nonatomic) FilterTagButtonAppearance appearance;
@property (strong, nonatomic) id<LCFilterTagButtonDelegate> delegate;
@end
