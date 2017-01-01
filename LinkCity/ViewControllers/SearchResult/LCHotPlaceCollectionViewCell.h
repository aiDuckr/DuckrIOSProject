//
//  LCHotPlaceCollectionViewCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHotPlaceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placePlanNumLabel;
@property (weak, nonatomic) IBOutlet UIView *hotPlaceBGView;
@property (weak, nonatomic) IBOutlet UIImageView *placeBGImageView;


- (void)updateShowHotPlaces:(LCHomeCategoryModel *)category;
@end
