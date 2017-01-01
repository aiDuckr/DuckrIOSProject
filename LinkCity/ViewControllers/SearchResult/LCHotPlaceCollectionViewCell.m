//
//  LCHotPlaceCollectionViewCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCHotPlaceCollectionViewCell.h"

@implementation LCHotPlaceCollectionViewCell

/// TODO:有没有awake唤醒只调用一次的函数.
- (void)updateImageView {
    CGFloat width = (DEVICE_WIDTH - 20 - 3 * 8) / 4;
    self.placeImageWidthConstraint.constant = width;
    self.placeImageHeightConstraint.constant = width;
    self.hotPlaceBGView.layer.cornerRadius = width / 2.0;
    self.hotPlaceBGView.layer.masksToBounds = YES;
}

- (void)updateShowHotPlaces:(LCHomeCategoryModel *)category {
    [self updateImageView];
    self.placeNameLabel.text = category.title;
    self.placePlanNumLabel.text = category.descInfo;
    [self.placeBGImageView setImageWithURL:[NSURL URLWithString:category.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
}

@end
