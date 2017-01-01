//
//  LCHomeRcmdCell.m
//  LinkCity
//
//  Created by 张宗硕 on 7/27/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeRcmdCell.h"
#import "LCSharedFuncUtil.h"

@implementation LCHomeRcmdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isChoosed = false;
    self.themeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.themeButton.layer.borderWidth = 1.0f;
    self.scrollView.scrollsToTop = NO;
//    self.editSelectLabel.layer.borderColor = UIColorFromRGBA(0xf87412, 1.0f).CGColor;
//    self.editSelectLabel.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateHomeRcmdCell:(LCHomeRcmd *)homeRcmd {
    if (nil == homeRcmd) {
        return ;
    }
    self.homeRcmd = homeRcmd;
    if ([LCStringUtil isNullString:self.homeRcmd.title]) {
        self.titleHeightConstraint.constant = 0.0f;
    } else {
        self.titleHeightConstraint.constant = 40.0f;
        [self.titleButton setTitle:self.homeRcmd.title forState:UIControlStateNormal];
        
        [LCSharedFuncUtil updateButtonTextImageRight:self.titleButton withSpacing:6.0f];
    }
    if (self.homeRcmd.planArr.count > 0) {
        [self updateCoverPlan];
    }
    if (self.homeRcmd.planArr.count > 1) {
        [self updateScrollView];
    }
    if(self.homeRcmd.type == LCHomeRcmdType_Rcmd){
        [self.otherBtn setTitle:@"其他推荐" forState:UIControlStateNormal];
        

    }else {
        [self.otherBtn setTitle:@"其他" forState:UIControlStateNormal];
        [LCSharedFuncUtil updateButtonTextImageRight:self.otherBtn withSpacing:5];

    }
    
    /*
     typedef enum : NSUInteger {
     LCHomeRcmdType_Default = 0,
     LCHomeRcmdType_Rcmd = 1,
     LCHomeRcmdType_Nearby = 2,
     LCHomeRcmdType_ToDoList = 3,
     LCHomeRcmdType_HotThemes = 4,
     LCHomeRcmdType_Today = 5,
     LCHomeRcmdType_Tomorrow = 6,
     LCHomeRcmdType_Week = 7,
     LCHomeRcmdType_Traing = 8,
     LCHomeRcmdType_LocalRcmd = 101,             ///> 本地精选.
     //    LCHomeRcmdType_LocalTrade = 102,            ///> 热门商圈.
     LCHomeRcmdType_LocalTheme = 103,            ///> 主题活动.
     } LCHomeRcmdType;
     */
    switch (self.homeRcmd.type) {
        case LCHomeRcmdType_Rcmd: {
            [self.otherBtn setTitle:@"其他推荐" forState:UIControlStateNormal];
            break;
        }
        case LCHomeRcmdType_Nearby: {
            [self.otherBtn setTitle:@"附近其他" forState:UIControlStateNormal];
            break;
        }
        case LCHomeRcmdType_Today: {
            [self.otherBtn setTitle:@"今天其他" forState:UIControlStateNormal];
            break;
        }
        case LCHomeRcmdType_Tomorrow: {
            [self.otherBtn setTitle:@"明天其他" forState:UIControlStateNormal];
            break;
        }
        case LCHomeRcmdType_Week: {
            [self.otherBtn setTitle:@"周末其他" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [LCSharedFuncUtil updateButtonTextImageRight:self.otherBtn withSpacing:5];
}

- (void)updateCoverPlan {
    LCPlanModel *plan = [self.homeRcmd.planArr objectAtIndex:0];
    self.titleLabel.text = plan.declaration;
    self.departDestLabel.text = [plan getDepartAndDestString];
    self.timeLabel.text = [plan getPlanStartDateText];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@/人", plan.costPrice];
    
    if ([plan isStagePlan]) {
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
    
    [self updateUsersView:plan.showingList];
    if (nil != plan.showingList && plan.showingList.count > 0) {
        self.editSelectLabel.hidden = YES;
        self.usersView.hidden = NO;
        self.likeOrBuyLabel.hidden = NO;
        self.likeOrBuyLabel.text = [NSString stringWithFormat:@"%@", plan.showingText];
    } else {
        self.editSelectLabel.hidden = NO;
        self.usersView.hidden = YES;
        self.likeOrBuyLabel.hidden = YES;
    }
    if (self.homeRcmd.type == LCHomeRcmdType_Rcmd) {
        if (IS_IPHONE_4_4S || IS_IPHONE_5_5S) {
            self.reasonLabel.text = plan.reason;
        } else {
            self.reasonLabel.text = [NSString stringWithFormat:@"%@", plan.reason];
        }
    }
    else {
        self.reasonLabel.text = [NSString stringWithFormat:@""];
    }
}

- (void)updateScrollView {
    for (UIView *v in self.otherView.subviews) {
        [v removeFromSuperview];
    }
    self.otherViewWidthConstraint.constant = 12.0f + (127.0f + 6.0f) * (self.homeRcmd.planArr.count - 1) + 12.0f;
    for (NSInteger i = 1; i < self.homeRcmd.planArr.count; ++i) {
        LCPlanModel *plan = [self.homeRcmd.planArr objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12.0f + (127.0f + 6.0f) * (i - 1), 0.0f, 127.0f, 125.0f)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 127.0f, 95.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setImageWithURL:[NSURL URLWithString:plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 103.0f, 117.0f, 15.0f)];
        label.text = plan.declaration;
        label.font = [UIFont fontWithName:APP_CHINESE_FONT size:12.0f];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
        [view addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:imageView.frame];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(bottomPlanAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        [self.otherView addSubview:view];
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
    if (nil != self.homeRcmd && self.homeRcmd.planArr.count > 0) {
        LCPlanModel *plan = [self.homeRcmd.planArr objectAtIndex:0];
        self.isChoosed = plan.isFavored;
        if (false == self.isChoosed) {
            [self.upperRightButton setImage:[UIImage imageNamed:@"PlanTabUnFavorCostPlan"] forState:UIControlStateNormal];
        } else {
            [self.upperRightButton setImage:[UIImage imageNamed:@"PlanTabFavorCostPlan"] forState:UIControlStateNormal];
        }
    }
}

- (void)updateUpperRightButton:(BOOL)isChoosed {
    self.isChoosed = isChoosed;
    [self updateShowUpperRight];
}

- (IBAction)topPlanAction:(id)sender {
    if (nil != self.homeRcmd && self.homeRcmd.planArr.count > 0) {
        LCPlanModel *plan = [self.homeRcmd.planArr objectAtIndex:0];
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:[LCSharedFuncUtil getTopMostNavigationController]];
    }
}

- (void)bottomPlanAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (nil != btn) {
        NSInteger i = btn.tag;
        if (i < self.homeRcmd.planArr.count) {
            LCPlanModel *plan = [self.homeRcmd.planArr objectAtIndex:i];
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:[LCSharedFuncUtil getTopMostNavigationController]];
        }
    }
}

- (IBAction)titleAction:(id)sender {
    switch (self.homeRcmd.type) {
        case LCHomeRcmdType_Rcmd:
        case LCHomeRcmdType_Nearby:
        case LCHomeRcmdType_Today:
        case LCHomeRcmdType_Tomorrow:
        case LCHomeRcmdType_Week:
            [LCViewSwitcher pushToShowCostPlanListVC:self.homeRcmd on:[LCSharedFuncUtil getTopMostNavigationController]];
            break;
        case LCHomeRcmdType_LocalTheme:
            [LCViewSwitcher pushToShowThemeWithFilterWithHomeRcmd:self.homeRcmd on:[LCSharedFuncUtil getTopMostNavigationController]];
            break;
        default:
            break;
    }
    
}

- (IBAction)chooseUpperRightAction:(id)sender {
    self.isChoosed = !self.isChoosed;
    if (nil != self.homeRcmd && self.homeRcmd.planArr.count > 0) {
        LCPlanModel *plan = [self.homeRcmd.planArr objectAtIndex:0];
        plan.isFavored = self.isChoosed;
        if (![[LCDataManager sharedInstance] haveLogin]) {
            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
            return ;
        }
        if (0 == plan.isFavored) {
            [LCNetRequester favorPlan:plan.planGuid withType:0 callBack:^(LCPlanModel *plan, NSError *error){
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain];
                }
            }];
            
        } else {
            [LCNetRequester favorPlan:plan.planGuid withType:1 callBack:^(LCPlanModel *plan, NSError *error){
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain];
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
