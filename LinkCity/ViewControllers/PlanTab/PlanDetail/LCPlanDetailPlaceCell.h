//
//  LCPlanDetailPlaceCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanDetailPlaceCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *dashView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;

- (void)updateShowPlaceName:(NSString *)placeName;
+ (CGFloat)cellHeight;
+ (CGFloat)cellWidthForPlaceName:(NSString *)placeName;
@end
