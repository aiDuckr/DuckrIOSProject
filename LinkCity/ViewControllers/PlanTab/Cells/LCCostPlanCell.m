//
//  LCCostPlanCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/9/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCCostPlanCell.h"

@implementation LCCostPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.type = LCCostPlanCellViewType_Plan;
    self.isChoosed = false;
    self.themeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.themeButton.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithPlan:(LCPlanModel *)plan {
    self.plan = plan;
    self.titleLabel.text = plan.declaration;
    self.departDestLabel.text = [plan getDepartAndDestString];
    self.timeLabel.text = [plan getPlanStartDateText];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@/人", plan.costPrice];
    
    if ([self.plan isStagePlan]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@起/人", plan.lowestPrice];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@/人", plan.lowestPrice];
    }
    
    [self.coverImageView setImageWithURL:[NSURL URLWithString:plan.firstPhotoThumbUrl]];
    [self updateUpperRightButton:self.isChoosed];
    if (nil != plan.tourThemes && plan.tourThemes.count > 0) {
        self.timeLabelGapConstraint.constant = 12.0f;
        self.themeButton.hidden = NO;
        LCRouteThemeModel *tourTheme = [plan.tourThemes objectAtIndex:0];
        [self.themeButton setTitle:tourTheme.title forState:UIControlStateNormal];
    } else {
        [self.themeButton setTitle:@"" forState:UIControlStateNormal];
        self.timeLabelGapConstraint.constant = -20.0f;
        self.themeButton.hidden = YES;
    }
    
    if (nil != plan.showingList && plan.showingList.count > 0) {
        self.editSelectLabel.hidden = YES;
        self.usersView.hidden = NO;
        self.likeOrBuyLabel.hidden = NO;
        [self updateUsersView:plan.showingList];
        self.likeOrBuyLabel.text = [NSString stringWithFormat:@"%@", plan.showingText];
    } else {
        self.editSelectLabel.hidden = NO;
        self.usersView.hidden = YES;
        self.likeOrBuyLabel.hidden = YES;
    }
    
    if( [LCStringUtil isNotNullString:plan.reason]) {
        if (IS_IPHONE_4_4S || IS_IPHONE_5_5S) {
            self.reasonLabel.text = plan.reason;
        } else {
            self.reasonLabel.text = [NSString stringWithFormat:@"%@", plan.reason];
        }
    } else {
        self.reasonLabel.text = [NSString stringWithFormat:@""];
    }
}

- (void)updateUsersView:(NSArray *)usersArr {
    for (UIView *v in self.usersView.subviews) {
        [v removeFromSuperview];
    }
    NSInteger showUserNum = usersArr.count;
    if (showUserNum > 0) {
        if (showUserNum > 3) {
            showUserNum = 3;
        }
        self.usersViewWidthConstraint.constant = 27.0f + 22.0f * (showUserNum - 1);
    } else {
        self.usersViewWidthConstraint.constant = 0.0f;
    }
    for (NSInteger i = 0; i < showUserNum; ++i) {
        LCUserModel *user = [usersArr objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f + 22.0f * i, 0.0f, 27.0f, 27.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        imageView.layer.cornerRadius = 13.5f;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColorFromRGBA(0xf0df6b, 1.0f) CGColor];
        imageView.layer.borderWidth = 1.0f;
        [self.usersView addSubview:imageView];
    }
}

- (void)updateShowUpperRight {
    if (LCCostPlanCellViewType_Plan == self.type) {
        self.isChoosed = self.plan.isFavored;
        if (false == self.isChoosed) {
            [self.upperRightButton setImage:[UIImage imageNamed:@"PlanTabUnFavorCostPlan"] forState:UIControlStateNormal];
        } else {
            [self.upperRightButton setImage:[UIImage imageNamed:@"PlanTabFavorCostPlan"] forState:UIControlStateNormal];
        }
    } else {
        if (false == self.isChoosed) {
            [self.upperRightButton setImage:[UIImage imageNamed:@"PlanTabUnchoosed"] forState:UIControlStateNormal];
        } else {
            [self.upperRightButton setImage:[UIImage imageNamed:@"PlanTabChoosed"] forState:UIControlStateNormal];
        }
    }
}

- (void)updateUpperRightButton:(BOOL)isChoosed {
    self.isChoosed = isChoosed;
    [self updateShowUpperRight];
}

- (IBAction)chooseUpperRightAction:(id)sender {
    self.isChoosed = !self.isChoosed;
    __weak typeof(self) weakSelf = self;
    if (LCCostPlanCellViewType_Plan == self.type) {
        self.plan.isFavored = self.isChoosed;
        if (![[LCDataManager sharedInstance] haveLogin]) {
            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
            return ;
        }
        if (0 == self.plan.isFavored) {
            [LCNetRequester favorPlan:self.plan.planGuid withType:0 callBack:^(LCPlanModel *plan, NSError *error){
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain];
                }else {
                    [weakSelf updateShowWithPlan:plan];
                }
            }];
            
        } else {
            [LCNetRequester favorPlan:self.plan.planGuid withType:1 callBack:^(LCPlanModel *plan, NSError *error){
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain];
                }else {
                    [weakSelf updateShowWithPlan:plan];
                }
            }];
        }
    }
    [self updateShowUpperRight];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseUpperRightButton:)]) {
        [self.delegate chooseUpperRightButton:self];
    }
}


@end
