//
//  prmtListCell.h
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHomeCategoryModel.h"

@protocol LCPrmtListCellDelegate;
@interface LCPrmtListCell : UIView
@property (nonatomic, weak) id<LCPrmtListCellDelegate> delegate;
@property (nonatomic, strong) NSArray *imageUrlArray;   // array of LCHomeCategoryModel
@property (nonatomic, assign) NSInteger showingPageIndex;

+ (instancetype)createInstance;
- (void)startAutoScroll;
- (void)stopAutoScroll;

@end


@protocol LCPrmtListCellDelegate <NSObject>

- (void)prmtListCell:(LCPrmtListCell *)cell didSelectTopListIndex:(NSInteger)topListIndex;

@end