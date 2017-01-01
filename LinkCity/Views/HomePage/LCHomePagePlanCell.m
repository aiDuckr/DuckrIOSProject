//
//  LCHomePagePlanCell.m
//  LinkCity
//
//  Created by 张宗硕 on 11/8/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCHomePagePlanCell.h"
#import "LCXMPPUtil.h"

@implementation LCHomePagePlanCell

- (void)awakeFromNib {
    // Initialization code
//    self.avatarImageBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    //add shadow
    self.destinationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.destinationLabel.layer.shadowOpacity = 0.5;
    self.destinationLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.destinationLabel.layer.shadowRadius = 1;
    self.destinationLabel.layer.shouldRasterize = YES;
    
    self.dateLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dateLabel.layer.shadowOpacity = 0.5;
    self.dateLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.dateLabel.layer.shadowRadius = 1;
    self.dateLabel.layer.shouldRasterize = YES;
    
    self.declarationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.declarationLabel.layer.shadowOpacity = 0.5;
    self.declarationLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.declarationLabel.layer.shadowRadius = 1;
    self.declarationLabel.layer.shouldRasterize = YES;
    
    self.destinationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.destinationLabel.layer.shadowOpacity = 0.5;
    self.destinationLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.destinationLabel.layer.shadowRadius = 1;
    self.destinationLabel.layer.shouldRasterize = YES;
    
    self.dateLabelLeftLine.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dateLabelLeftLine.layer.shadowOpacity = 0.5;
    self.dateLabelLeftLine.layer.shadowOffset = CGSizeMake(1, 1);
    self.dateLabelLeftLine.layer.shadowRadius = 1;
    self.dateLabelLeftLine.layer.shouldRasterize = YES;
    
    self.dateLabelRightLine.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dateLabelRightLine.layer.shadowOpacity = 0.5;
    self.dateLabelRightLine.layer.shadowOffset = CGSizeMake(1, 1);
    self.dateLabelRightLine.layer.shadowRadius = 1;
    self.dateLabelRightLine.layer.shouldRasterize = YES;
    
    self.avatarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.avatarBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    self.cellBottomLineHeight.constant = 0.5;
    
    self.avatarImageBtns = [[NSMutableArray alloc] init];
    [self.avatarImageBtns addObject:self.firstPartnerImageBtn];
    [self.avatarImageBtns addObject:self.secondPartnerImageBtn];
    [self.avatarImageBtns addObject:self.thirdPartnerImageBtn];
    [self.avatarImageBtns addObject:self.fourPartnerImageBtn];
    [self.avatarImageBtns addObject:self.fivePartnerImageBtn];
    [self.avatarImageBtns addObject:self.sixPartnerImageBtn];
    
    self.nameLabels = [[NSMutableArray alloc] init];
    [self.nameLabels addObject:self.firstPartnerLabel];
    [self.nameLabels addObject:self.secondPartnerLabel];
    [self.nameLabels addObject:self.thirdPartnerLabel];
    [self.nameLabels addObject:self.fourPartnerLabel];
    [self.nameLabels addObject:self.fivePartnerLabel];
    [self.nameLabels addObject:self.sixPartnerLabel];
}

//- (void)imageViewLoadedImage:(EGOImageView *)imageView
//{
//    imageView.image = [LCImageUtil blurWithCoreImage:imageView.image withRect:imageView.frame pixel:BLUR_IMAGE_PIXEL];
//    self.coverImageView.backgroundColor = [UIColor clearColor];
//}

/// 收藏计划.
- (IBAction)likePlanAction:(id)sender
{
    LCPlanApi *api = [[LCPlanApi alloc] initWithDelegate:self];
    
    if (self.plan.isFavored)
    {
        ZLog(@"setting self.plan.isFavored");
        [api cancelFavorPlan:self.plan.planGuid planType:self.plan.planType];
    }
    else
    {
        ZLog(@"setting self.plan.is not Favored");
        [api favorPlan:self.plan.planGuid planType:self.plan.planType];
        if ([PLAN_TYPE_PARNTER_STR isEqualToString:self.plan.planType])
        {
            [MobClick event:MobEFavorPartner];
        }
        else if ([PLAN_TYPE_RECEPTION_STR isEqualToString:self.plan.planType])
        {
            [MobClick event:MobEFavorReception];
        }
    }
}

- (void)planApi:(LCPlanApi *)api didFavorPlan:(NSInteger)favorNumber withError:(NSError *)error
{
    ZLog(@"the didFavorPlan Number %tu", favorNumber);
    if (!error)
    {
        self.plan.isFavored = YES;
        self.plan.favorNum = favorNumber;
        [self.favorButton setImage:[UIImage imageNamed:@"HomePageLikeBtnHL"] forState:UIControlStateNormal];
        self.likeNumberLabel.text = [NSString stringWithFormat:@"%tu", favorNumber];
    }
}

- (void)planApi:(LCPlanApi *)api didCancelFavorPlan:(NSInteger)favorNumber withError:(NSError *)error
{
    ZLog(@"the didCancelFavorPlan Number %tu", favorNumber);
    if (!error)
    {
        self.plan.isFavored = NO;
        self.plan.favorNum = favorNumber;
        [self.favorButton setImage:[UIImage imageNamed:@"HomePageLikeBtn"] forState:UIControlStateNormal];
        self.likeNumberLabel.text = [NSString stringWithFormat:@"%tu", favorNumber];
    }
}

- (IBAction)sharePlanAction:(id)sender
{
    LCPlanApi *api = [[LCPlanApi alloc] initWithDelegate:self];
    [api addShareNumberToPlan:self.plan.planGuid planType:self.plan.planType];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareToSocialNetwork:)])
    {
        [self.delegate shareToSocialNetwork:self.plan];
    }
}

- (void)goToUserInfoPage:(NSInteger)index {
    if (nil != self.plan.memberList && self.plan.memberList.count > index) {
        LCUserInfo *user = [self.plan.memberList objectAtIndex:index];
        [LCViewSwitcher pushToShowUserInfo:user onNavigationVC:self.controller.navigationController];
    }else{
        [LCViewSwitcher pushToShowDetailOfPlan:self.plan onNavigationVC:self.controller.navigationController];
    }
}

- (IBAction)firstBtnAction:(id)sender {
    [self goToUserInfoPage:0];
}

- (IBAction)secondBtnAction:(id)sender {
    [self goToUserInfoPage:1];
}

- (IBAction)thirdBtnAction:(id)sender {
    [self goToUserInfoPage:2];
}

- (IBAction)fourBtnAction:(id)sender {
    [self goToUserInfoPage:3];
}

- (IBAction)fiveBtnAction:(id)sender {
    [self goToUserInfoPage:4];
}

- (IBAction)sixBtnAction:(id)sender {
    [self goToUserInfoPage:5];
}

- (IBAction)avatarBtnPressed:(id)sender {
    if (nil != self.plan && self.controller) {
        [LCViewSwitcher pushToShowDetailOfPlan:self.plan onNavigationVC:self.controller.navigationController];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
