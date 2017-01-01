//
//  LCPlanDetailUserInfoCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LCPlanDetailUserInfoCellDelegate;

@interface LCPlanDetailUserInfoCell : UITableViewCell
@property (nonatomic, strong) LCPlanModel *plan;
@property (weak, nonatomic) IBOutlet UIButton *avatarButtonImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *routeCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeCollectionHeight;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (nonatomic, weak) id<LCPlanDetailUserInfoCellDelegate> delegate;

- (void)updateShowUserInfo:(LCPlanModel *)plan;
@end

@protocol LCPlanDetailUserInfoCellDelegate <NSObject>
- (void)planDetailUserInfoCellToViewUserDetail:(LCPlanDetailUserInfoCell *)cell;
- (void)planDetailUserInfoCellToViewPlace:(NSString *)placeName isDepart:(BOOL)isDepart;
@end
