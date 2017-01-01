//
//  LCHomeVCPlanCell.m
//  LinkCity
//
//  Created by Roy on 6/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCHomeVCPlanCell.h"


#define MaxPlanDescriptionStrLength (100)
@implementation LCHomeVCPlanCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    UIImage *topBgImage = [UIImage imageNamed:LCPlanCellTopBg];
    topBgImage = [topBgImage resizableImageWithCapInsets:LCCellTopBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.topBg.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:LCPlanCellBottomBg];
    bottomImage = [bottomImage resizableImageWithCapInsets:LCCellBottomBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.bottomBg.image = bottomImage;
    
    [self.planImageFirstButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.planImageSecondButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.planImageThirdButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setPlan:(LCPlanModel *)plan{
    _plan = plan;
    
    [self updateShow];
}

- (IBAction)avatarButtonAction:(id)sender {
    if (self.plan.memberList.count>0) {
        LCUserModel *user = [self.plan.memberList firstObject];
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:[LCSharedFuncUtil getTopMostViewController].navigationController];
    }
}


- (void)imageButtonAction:(id)sender{
    [MobClick event:Mob_PlanList_Image];
    
    NSInteger btnIndex = 0;
    if (sender == self.planImageFirstButton) {
        btnIndex = 0;
    }else if(sender == self.planImageSecondButton){
        btnIndex = 1;
    }else if(sender == self.planImageThirdButton){
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


- (void)updateShow{
    
    if (self.plan.isProvideCar) {
        self.planServiceImageView.hidden = NO;
        self.planServiceImageView.image = [UIImage imageNamed:@"ServiceCarIcon"];
    }else if(self.plan.isProvideTourGuide){
        self.planServiceImageView.hidden = NO;
        self.planServiceImageView.image = [UIImage imageNamed:@"ServiceLeadIcon"];
    }else{
        self.planServiceImageView.hidden = YES;
    }
    
    if (self.plan.memberList.count > 0) {
        LCUserModel *creater = [self.plan.memberList objectAtIndex:0];
        [self.createrAvatar setImageWithURL:[NSURL URLWithString:creater.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.createrName.text = creater.nick;
        self.createrAgeLabel.text = [creater getUserAgeString];
        
        if ([creater getUserSex] == UserSex_Male) {
            self.createrSexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
        }else{
            self.createrSexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
        }
    }
    
    if ([LCStringUtil isNullString:self.plan.departName]) {
        self.startPlaceLabel.text = @"目的地:";
        self.arrowImageView.hidden = YES;
        self.destinationLabelLeading.constant = 4;
    }else{
        self.startPlaceLabel.text = [LCStringUtil getNotNullStr:self.plan.departName];
        self.arrowImageView.hidden = NO;
        self.destinationLabelLeading.constant = 24;
    }
    self.destinationLabel.text = [self.plan getDestinationsStringWithSeparator:@"-"];
    if ([self.plan isStagePlan]) {
        if (self.plan.daysLong == 0) {
            self.plan.daysLong = 1;
        }
        self.planTimeLabel.text = [NSString stringWithFormat:@"多期 玩%ld",(long)self.plan.daysLong];
    }else{
        self.planTimeLabel.text = [self.plan getPlanTimeString];
    }
    
    if ([LCStringUtil isNotNullString:self.plan.publishPlace]) {
        self.planSendLocationLabel.text = [NSString stringWithFormat:@"我在%@",self.plan.publishPlace];
    }else{
        self.planSendLocationLabel.text = @"";
    }
    
    
    /*状态标签
     免费邀约： N天前发布 （如果是今天发布的，显示 18：30发布）
     收费邀约：集合中/已报满/行程中/已结束 张若宇
    */
    NSString *todayStr = [LCDateUtil getTodayStr];
    NSDate *now = [LCDateUtil dateFromString:todayStr];
    NSDate *startDate = [LCDateUtil dateFromString:self.plan.startTime];
    NSDate *endDate = [LCDateUtil dateFromString:self.plan.endTime];
    
    if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
        //收费邀约
        if ([now timeIntervalSinceDate:startDate] < 0) {
            //收费邀约：集合中/已报满
            if (self.plan.totalOrderNumber+1 < self.plan.scaleMax) {
                self.planDepartState.text = @"集合中";
            }else{
                self.planDepartState.text = @"已报满";
            }
        }else if ([now timeIntervalSinceDate:endDate] <= 0) {
            //before end
            self.planDepartState.text = @"行程中";
        }else{
            //after end
            self.planDepartState.text = @"已结束";
        }
    }else{
        //免费邀约：N天前发布
        NSString *publishTime = [LCDateUtil getTimeIntervalStringFromDateString:self.plan.createdTime];
        self.planDepartState.text = [NSString stringWithFormat:@"%@发布",publishTime];
    }
    
    if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
        self.priceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@/人",self.plan.costPrice];
    }else{
        self.priceLabel.hidden = YES;
    }
    
    [self.planDescriptionLabel setText:[LCHomeVCPlanCell getShotDescStrOfPlan:self.plan] withLineSpace:LCTextFieldLineSpace];
    
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoThumbUrl]) {
        self.planImageFirstButton.hidden = NO;
        [self.planImageFirstButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        self.planImageFirstButton.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoThumbUrl]) {
        self.planImageSecondButton.hidden = NO;
        [self.planImageSecondButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.plan.secondPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        self.planImageSecondButton.hidden = YES;
        [self.planImageSecondButton setImage:nil forState:UIControlStateNormal];
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoThumbUrl]) {
        self.planImageThirdButton.hidden = NO;
        [self.planImageThirdButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.plan.thirdPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        self.planImageThirdButton.hidden = YES;
        [self.planImageThirdButton setImage:nil forState:UIControlStateNormal];
    }
    
    NSInteger totalNum = 0;
    if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
        totalNum = self.plan.totalStageOrderNumber+1;
    }else{
        totalNum = self.plan.userNum;
    }
    self.memberNumLabel.text = [NSString stringWithFormat:@"已有%ld人加入",(long)totalNum];
    
    NSString *str = @"";
    if (self.plan.browseNumber > 9999) {
        str = @"9999+";
    }else{
        str = [NSString stringWithFormat:@"%ld",(long)self.plan.browseNumber];
    }
    self.planScanNumLabel.text = str;
    
    if (self.plan.commentNumber > 9999) {
        str = @"9999+";
    }else{
        str = [NSString stringWithFormat:@"%ld",(long)self.plan.commentNumber];
    }
    self.planCommentNumLabel.text = str;
    
    [self setNeedsUpdateConstraints];
}

+ (CGFloat)getCellHightForPlan:(LCPlanModel *)plan{
    CGFloat height = 0;
    
    CGFloat planDescriptionHeight = [LCStringUtil getHeightOfString:[self getShotDescStrOfPlan:plan]
                                                           withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                                          lineSpace:LCTextFieldLineSpace
                                                         labelWidth:DEVICE_WIDTH-10-12-12-10];
    height += planDescriptionHeight;    //邀约描述
    
    height += ((DEVICE_WIDTH-20)*0.33-10) / 216 * 172;   //图片高
    
    
    height += 190;
    
    return height;
}



+ (NSString *)getShotDescStrOfPlan:(LCPlanModel *)plan{
    if (plan.descriptionStr.length > MaxPlanDescriptionStrLength) {
        return [plan.descriptionStr substringToIndex:MaxPlanDescriptionStrLength];
    }else{
        return plan.descriptionStr;
    }
}


@end
