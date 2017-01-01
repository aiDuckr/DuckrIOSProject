//
//  LCTourpicAlbumTimelineCell.h
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourpic.h"

@interface LCTourpicAlbumTimelineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *withWhoLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigGapHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bigGapView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descAndWhereHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *withWhoImageView;

- (void)refreshLayout:(LCTourpic *)tourpic;
- (void)updateCellWithTourpic:(LCTourpic *)tourpic;
+ (CGFloat)getCellHeight:(LCTourpic *)tourpic isShowBigGap:(BOOL)isShowBigGap;
+ (NSString *)getWithWhoStr:(LCTourpic *)tourpic;
@end
