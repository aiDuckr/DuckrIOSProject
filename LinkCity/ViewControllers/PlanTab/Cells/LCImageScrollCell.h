//
//  LCImageScrollCell.h
//  LinkCity
//
//  Created by 张宗硕 on 5/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHomeCategoryModel.h"

typedef enum : NSInteger {
    LCImageScrollCellViewType_Recm = 0,
    LCImageScrollCellViewType_Duckr = 1,
} LCImageScrollCellViewType;

@protocol LCImageScrollCellDelegate;

@interface LCImageScrollCell : UITableViewCell
+ (instancetype)createInstance;
- (void)startAutoScroll;
- (void)stopAutoScroll;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, weak) id<LCImageScrollCellDelegate> delegate;
@property (nonatomic, strong) NSArray *homeCategoryArray;
@property (assign, nonatomic) LCImageScrollCellViewType type;

- (void)updateShowCell:(NSArray *)bannerArr withType:(LCImageScrollCellViewType)type;
@end

@protocol LCImageScrollCellDelegate <NSObject>
- (void)imageScrollCell:(LCImageScrollCell *)cell didSelectTopListIndex:(NSInteger)topListIndex;

@end