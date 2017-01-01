//
//  LCFilterTagButtonCell.h
//  LinkCity
//
//  Created by 张宗硕 on 8/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//
#import "LCFilterTagButton.h"
#import <UIKit/UIKit.h>

@interface LCFilterTagButtonCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet LCFilterTagButton *filterTagButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;

- (void)updateFilterTagButton:(LCRouteThemeModel *)model;

@end
