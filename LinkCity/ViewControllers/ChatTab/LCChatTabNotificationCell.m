//
//  LCChatTabNotificationCell.m
//  LinkCity
//
//  Created by lhr on 16/6/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCChatTabNotificationCell.h"
#import "LCNotificationModel.h"
#import "LCCellTopView.h"

typedef NS_ENUM(NSInteger, LCDetailViewType) {
    LCDetailViewTypePlan = 0,
    LCDetailViewTypeTourpic = 1,
};

@interface LCChatTabNotificationCell()

@property (weak, nonatomic) IBOutlet UIImageView *planOrTourpicImageView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelLeftConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *locationImageIcon;

@property (weak, nonatomic) IBOutlet UIImageView *playIcon;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

//@property (weak, nonatomic) IBOutlet LCCellTopView *cellTopView;

@property (strong, nonatomic) LCCellTopView *cellTopView;

@property (strong, nonatomic) UIButton *replyOrFollowButton;

@property (nonatomic, assign) LCNotificationType notificationType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *focusWidthConstraint;
@end


@implementation LCChatTabNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.focusButton.layer.borderColor = [UIColorFromRGBA(0xd7d5d2, 1.0) CGColor];
    self.focusButton.layer.borderWidth = 0.5f;
    self.cellTopView = [LCCellTopView createInstance];
    [self.topView addSubview:self.cellTopView];
    self.cellTopView.frame = CGRectMake(0, 0, self.width, self.topView.height);
    self.replyOrFollowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replyOrFollowButton addTarget:self action:@selector(replyOrFollowAction) forControlEvents:UIControlEventTouchUpInside];
    self.replyOrFollowButton.layer.cornerRadius = 2.0f;
    self.replyOrFollowButton.layer.borderWidth = 1.0f;
    self.replyOrFollowButton.layer.borderColor = [UIColorFromRGBA(0xD7D7D2, 1.0) CGColor];
    self.replyOrFollowButton.titleLabel.textColor = UIColorFromRGBA(0x85817D, 1.0);
    self.replyOrFollowButton.titleLabel.font = LCDefaultFontSize(13);
    
//    self.detailInfoView = [LCPlanOrTourpicDetailInfoView createInstance];
//    self.detailInfoView.frame = CGRectMake(12, 6, self.width - 12*2, 100);
//    [self.bottomView addSubview:self.detailInfoView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithNotificationModel:(LCNotificationModel *)model {
    self.model = model;
    self.notificationType = model.notificaionType;
    if (model.notificaionType == LCNotificationTypeUserFollow) {
        [self updateUserRelation:model.fromUser];
        self.bottomViewHeight.constant = 0;
    } else if (model.notificaionType == LCNotificationTypePlan) {
        self.focusButton.hidden = YES;
        self.bottomViewHeight.constant = 132;
        [self updateDetailViewWithModel:model.planInfo withType:LCDetailViewTypePlan];
    } else if (model.notificaionType == LCNotificationTypeTourpic) {
        self.focusButton.hidden = YES;
        self.bottomViewHeight.constant = 132;
        [self updateDetailViewWithModel:model.tourPicInfo withType:LCDetailViewTypeTourpic];
    }
    self.contentLabel.text = model.content;
    [self.cellTopView updateShowWithUserModel:model.fromUser withTimeLabelText:model.createdTime];
    //[LCDateUtil]
}

- (void)updateDetailViewWithModel:(id)model withType:(LCDetailViewType)type {
//    self.planOrTourpicImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.playIcon.hidden = YES;
    if (type == LCDetailViewTypeTourpic && [model isKindOfClass:[LCTourpic class]]) {
        //旅图
        LCTourpic *tourpic = (LCTourpic *)model;
        if (tourpic.type == LCTourpicType_Video) {
            self.playIcon.hidden = NO;
        }
        NSLog(@"zzs come in tourpic thumb pic url is %@", tourpic.thumbPicUrl);
        [self.planOrTourpicImageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPicUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        self.topLabel.text = tourpic.desc;
        self.topLabel.numberOfLines = 3;
        self.descLabel.text = @"";
        self.timeLabelLeftConstraint.constant = 29.0f;
        self.timeLabel.text = [NSString stringWithFormat:@"于 %@",tourpic.placeName];
        self.locationImageIcon.hidden = NO;
    } else if (type == LCDetailViewTypePlan && [model isKindOfClass:[LCPlanModel class]]){
        //邀约
        LCPlanModel *plan = (LCPlanModel *)model;
        
        [self.planOrTourpicImageView setImageWithURL:[NSURL URLWithString:plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        self.topLabel.numberOfLines = 1;
        self.topLabel.text = [plan getDepartAndDestString];
        self.descLabel.text = plan.descriptionStr;
        self.timeLabelLeftConstraint.constant = 12.0f;
        self.timeLabel.text = [plan getPlanTimeString];
        self.locationImageIcon.hidden = YES;
    }
}

- (void)replyOrFollowAction {
    if (self.notificationType == LCNotificationTypeUserFollow) {
        
    } else if (self.notificationType == LCNotificationTypePlan) {
        
    } else if (self.notificationType == LCNotificationTypeTourpic) {
        
    }
}

- (void)updateUserRelation:(LCUserModel *)user {
    self.focusButton.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:12.0f];
    if (([LCDataManager sharedInstance].userInfo && [user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID])) {
        self.focusButton.hidden = YES;
    } else {
        self.focusButton.hidden = NO;
        self.focusButton.backgroundColor = [UIColor clearColor];
        self.focusButton.layer.borderColor = [UIColorFromRGBA(0xd7d5d2, 1.0) CGColor];
        self.focusButton.layer.borderWidth = 0.5f;
        
        if (LCUserModelRelation_EachFavored == user.relation) {
            self.focusButton.enabled = NO;
            self.focusWidthConstraint.constant = 75.0f;
            [self.focusButton setTitleColor:UIColorFromRGBA(0x7d7975, 1.0) forState:UIControlStateNormal];
            [self.focusButton setTitle:@"互相关注" forState:UIControlStateNormal];
            [self.focusButton setImage:nil forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        } else if (LCUserModelRelation_Favored == user.isFavored) {
            self.focusButton.enabled = NO;
            self.focusWidthConstraint.constant = 64.0f;
            [self.focusButton setTitleColor:UIColorFromRGBA(0x7d7975, 1.0) forState:UIControlStateNormal];
            [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.focusButton setImage:nil forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        } else {
            self.focusButton.enabled = YES;
            self.focusWidthConstraint.constant = 52.0f;
            [self.focusButton setTitleColor:UIColorFromRGBA(0x2c2a28, 1.0) forState:UIControlStateNormal];
            [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
            [self.focusButton setImage:[UIImage imageNamed:@"TourpicFocusAdd"] forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, -2.0f, 0.0f, 0.0f)];
        }
    }
}

- (IBAction)focusButtonAction:(id)sender {
    if (self.model.notificaionType == LCNotificationTypeUserFollow) {
        if (![[LCDataManager sharedInstance] haveLogin]) {
            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
            return ;
        }
        
        LCUserModel *user = self.model.fromUser;
        if (0 == user.isFavored) {
            user.isFavored = 1;
            [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                } else {
                    user.isFavored = 1;
                }
            }];
        }
        [self updateUserRelation:user];
    }
}
@end
