//
//  LCFreePlanCell.m
//  LinkCity
//
//  Created by Roy on 12/10/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCFreePlanCell.h"


#define MaxPlanDescriptionStrLength (100)
#define MaxThemeBtnNum (4)

@interface LCFreePlanCell()
@property (nonatomic, assign) BOOL showDistancelabel;
@property (nonatomic, strong) NSArray *themeBtnArr;
@end
@implementation LCFreePlanCell

- (void)awakeFromNib {
    self.descriptionLabel.numberOfLines = 3;
    [self.descriptionLabel sizeToFit];
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.imageHeightConstraint.constant = (DEVICE_WIDTH - 2) / 3.0f;
    [super awakeFromNib];
}

- (NSArray *)themeBtnArr {
    if (nil == _themeBtnArr) {
        _themeBtnArr = [[NSArray alloc] initWithObjects:self.themeBtn1, self.themeBtn2, self.themeBtn3, self.themeBtn4, nil];
    }
    return _themeBtnArr;
}

- (void)updateShowWithPlan:(LCPlanModel *)plan hideThemeId:(NSInteger)themeId withSpaInset:(BOOL)isHaveInset {
    self.plan = plan;
    self.hideThemeId = themeId;
    if (isHaveInset) {
        self.spaViewHeight.constant = 12.0f;
    } else {
        self.spaViewHeight.constant = 0.0f;
    }
    [self updateShow];
    
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

- (void)updateShowWithPlan:(LCPlanModel *)plan hideThemeId:(NSInteger)themeId withDistance:(BOOL)showDistanceLabel withSpaInset:(BOOL)isHaveInset {
    self.showDistancelabel = showDistanceLabel;
    [self updateShowWithPlan:plan hideThemeId:themeId withSpaInset:isHaveInset];
}

- (IBAction)avatarBtnAction:(id)sender {
    if (self.plan.memberList.count > 0) {
        LCUserModel *user = [self.plan.memberList firstObject];
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:[LCSharedFuncUtil getTopMostViewController].navigationController];
    }
}

- (IBAction)imageBtnAction:(id)sender {
    [MobClick event:Mob_PlanList_Image];
    
    NSInteger btnIndex = 0;
    if (sender == self.firstPhotoBtn) {
        btnIndex = 0;
    } else if (sender == self.secondPhotoBtn) {
        btnIndex = 1;
    } else if(sender == self.thirdPhotoBtn) {
        btnIndex = 2;
    }
    
    NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.firstPhotoUrl;
        imageModel.imageUrlThumb = self.plan.firstPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.secondPhotoUrl;
        imageModel.imageUrlThumb = self.plan.secondPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.thirdPhotoUrl;
        imageModel.imageUrlThumb = self.plan.thirdPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    
    if (imageModels.count > btnIndex) {
        LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
        [photoScanner showImageModels:imageModels fromIndex:btnIndex];
        [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
    }
}

- (void)updateShow {
    self.professionalLabel.text = @"";
    self.sexView.hidden = YES;
    self.avatarImageView.image = [UIImage imageNamed:LCDefaultAvatarImageName];
    if (self.plan.memberList.count > 0) {
        LCUserModel *user = [self.plan.memberList objectAtIndex:0];
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = user.nick;
        self.ageLabel.text = [user getUserAgeString];
        
        self.nickLabel.text = user.nick;
        if (UserSex_Male == user.sex) {
            self.sexView.hidden = NO;
            self.sexView.backgroundColor = UIColorFromRGBA(0x8ccbed, 1.0);
            self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
        } else if (UserSex_Female == user.sex) {
            self.sexView.hidden = NO;
            self.sexView.backgroundColor = UIColorFromRGBA(0xf4abc2, 1.0);
            self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
        }
        
        self.professionalLabel.text = user.professional;
    }
    
    self.dateTimeLabel.text = [self.plan getStartEndTimeText];
    if ([LCStringUtil isNullString:self.dateTimeLabel.text]) {
        self.dateTimeGapHeightConstraint.constant = 0.0f;
    } else {
        self.dateTimeGapHeightConstraint.constant = 13.0f;
    }
    
    self.titleLabel.text = [self.plan getDepartAndDestString];
    
    if (self.plan.favorNumber <= 0) {
        self.likeCountLabel.text = @"感兴趣";
    } else {
        self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",self.plan.favorNumber];
    }
    
    if (self.plan.commentNumber <= 0) {
        self.commentCountLabel.text = @"留言";
    } else {
        self.commentCountLabel.text = [NSString stringWithFormat:@"%zd",self.plan.commentNumber];
    }
    
    if (self.plan.isFavored) {
        self.likeImageView.image = [UIImage imageNamed:@"TourpiclikedIcon"];
    } else {
        self.likeImageView.image = [UIImage imageNamed:@"TourpicUnlikeIcon"];
    }

    if (_showDistancelabel) {
        self.distanceLabel.text = [LCStringUtil getDistanceString:self.plan.distance];
    } else {
        self.distanceLabel.hidden = YES;
    }

    if ([LCStringUtil isNullString:self.plan.descriptionStr]) {
        self.tagGapHeightConstraint.constant = 0;
    } else {
        self.tagGapHeightConstraint.constant = 14;
    }
    [self.descriptionLabel setText:self.plan.descriptionStr withLineSpace:LCTextFieldLineSpace_V_3_3];
    
    [self updateShowAvatarView];
    
    [self updateShowThemeView];
    
    if (nil != self.plan.photoUrls && 1 == self.plan.photoUrls.count) {
        self.imgLeftConstraint.constant = 12.0f;
    } else {
        self.imgLeftConstraint.constant = 0.0f;
    }
    
    NSString *timeStr = [LCDateUtil getCreatedTimeStrByDateTimeStr:self.plan.createdTime];
    if ([LCStringUtil isNotNullString:self.plan.publishPlace]) {
        self.timeLocationLabel.text = [NSString stringWithFormat:@"%@  |  %@", timeStr, self.plan.publishPlace];
    } else {
        self.timeLocationLabel.text = [NSString stringWithFormat:@"%@", timeStr];
    }
    
    if ([LCStringUtil isNullString:self.professionalLabel.text] && (YES == self.distanceLabel.hidden || [LCStringUtil isNullString:self.distanceLabel.text])) {
        self.nickTopConstraint.constant = 25.0f;
    } else {
        self.nickTopConstraint.constant = 17.0f;
    }
}

- (void)updateShowAvatarView {
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoThumbUrl]) {
        self.firstPhotoBtn.hidden = NO;
        self.firstPhotoImageView.hidden = NO;
        [self.firstPhotoImageView setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.firstPhotoBtn.hidden = YES;
        self.firstPhotoImageView.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoThumbUrl]) {
        self.secondPhotoBtn.hidden = NO;
        self.secondPhotoImageView.hidden = NO;
        [self.secondPhotoImageView setImageWithURL:[NSURL URLWithString:self.plan.secondPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.secondPhotoBtn.hidden = YES;
        self.secondPhotoImageView.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoThumbUrl]) {
        self.thirdPhotoBtn.hidden = NO;
        self.thirdPhotoImageView.hidden = NO;
        [self.thirdPhotoImageView setImageWithURL:[NSURL URLWithString:self.plan.thirdPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.thirdPhotoBtn.hidden = YES;
        self.thirdPhotoImageView.hidden = YES;
    }
}

- (void)updateShowThemeView {
    int i = 0;
    NSMutableArray *showThemeArr = [[NSMutableArray alloc] init];
    for (i = 0; i < self.plan.tourThemes.count; i++) {
        LCRouteThemeModel *theme = self.plan.tourThemes[i];
        if (showThemeArr.count < MaxThemeBtnNum) {
            [showThemeArr addObject:theme];
        }
    }
    
    for (i = 0; i < self.plan.tagsArray.count; i++) {
        LCRouteThemeModel *theme = self.plan.tagsArray[i];
        if (showThemeArr.count < MaxThemeBtnNum) {
            [showThemeArr addObject:theme];
        }
    }
    
    for (i = 0; i < self.themeBtnArr.count; ++i) {
        UIButton *btn = (UIButton *)[self.themeBtnArr objectAtIndex:i];
        btn.hidden = YES;
    }
    
    for (i = 0; i < self.themeBtnArr.count && i < showThemeArr.count; ++i) {
        LCRouteThemeModel *model = (LCRouteThemeModel *)[showThemeArr objectAtIndex:i];
        if (nil == model) {
            break ;
        }
        UIButton *btn = (UIButton *)[self.themeBtnArr objectAtIndex:i];
        btn.hidden = NO;
        [btn setTitle:model.title forState:UIControlStateNormal];
    }
    
    if (0 == i) {
        self.themeViewHeightConstraint.constant = 0.0f;
    } else {
        self.themeViewHeightConstraint.constant = 31.0f;
    }
}


+ (NSString *)getShotDescStrOfPlan:(LCPlanModel *)plan{
    if (plan.descriptionStr.length > MaxPlanDescriptionStrLength) {
        return [plan.descriptionStr substringToIndex:MaxPlanDescriptionStrLength];
    }else{
        return plan.descriptionStr;
    }
}

- (IBAction)likeAction:(id)sender {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    NSString * planGuid = self.plan.planGuid;
    if (self.plan.isFavored == 0) {
        self.plan.isFavored = 1;
        self.plan.favorNumber += 1;
        self.likeImageView.image = [UIImage imageNamed:@"TourpiclikedIcon"];
    } else {
        self.plan.isFavored = 0;
        self.plan.favorNumber -= 1;
        self.likeImageView.image = [UIImage imageNamed:@"TourpicUnlikeIcon"];
    }
    
    __weak typeof(self) weakSelf = self;
    [LCNetRequester favorPlan:planGuid withType:self.plan.isFavored callBack:^(LCPlanModel *plan, NSError *error){
        if (error) {
            if (weakSelf.plan.isFavored == 0) {
                weakSelf.plan.isFavored = 1;
                weakSelf.plan.favorNumber += 1;
            } else {
                weakSelf.plan.isFavored = 0;
                weakSelf.plan.favorNumber -= 1;
            }
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (IBAction)commentAction:(id)sender {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.plan recmdUuid:nil on:[LCSharedFuncUtil getTopMostNavigationController]];
}

@end
