//
//  LCChatWithUserCell.m
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRecentChatCell.h"

@interface LCRecentChatCell()

@property (nonatomic, strong) UIView *spaLineView;

@property (nonatomic,strong) UIImageView *firstAvatarView;

@property (nonatomic,strong) UIImageView *secondAvatarView;

@property (nonatomic,strong) UIImageView *thirdAvatarView;

@property (nonatomic,strong) UIImageView *fourthAvatarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotViewWidth;
@end
static const CGFloat singleAvatarWidth = 31.0f;

//static const CGFloat avatarWidth = 53.0f;
@implementation LCRecentChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.spaLineView = [[UIView alloc] initWithFrame:CGRectMake(self.avatarImageView.maxX, self.height - 0.5, DEVICE_WIDTH - self.avatarImageView.maxX, 0.5)];
    self.spaLineView.backgroundColor = DefaultSpalineColor;
    self.dotView.layer.cornerRadius = 8.5;
    [self.contentView addSubview:self.spaLineView];
    self.firstAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, singleAvatarWidth, singleAvatarWidth)];
    self.firstAvatarView.layer.borderWidth = 1.5;
    self.firstAvatarView.layer.cornerRadius = singleAvatarWidth / 2;
    self.firstAvatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.secondAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, singleAvatarWidth, singleAvatarWidth)];
    self.secondAvatarView.layer.borderWidth = 1.5;
    self.secondAvatarView.layer.cornerRadius = singleAvatarWidth / 2;
    self.secondAvatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.thirdAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, singleAvatarWidth, singleAvatarWidth)];
    self.thirdAvatarView.layer.borderWidth = 1.5;
    self.thirdAvatarView.layer.cornerRadius = singleAvatarWidth / 2;
    self.thirdAvatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.fourthAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, singleAvatarWidth, singleAvatarWidth)];
    self.fourthAvatarView.layer.borderWidth = 1.5;
    self.fourthAvatarView.layer.cornerRadius = singleAvatarWidth / 2;
    self.fourthAvatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.firstAvatarView.layer.masksToBounds = YES;
    self.secondAvatarView.layer.masksToBounds = YES;
    self.thirdAvatarView.layer.masksToBounds = YES;
    self.fourthAvatarView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateShowWithTitle:(NSString *)title imageName:(NSString *)imageName updateTime:(NSString *)timeStr descString:(NSString *)descString unreadNum:(NSInteger)unreadNum{
    [self.firstAvatarView removeFromSuperview];
    [self.secondAvatarView removeFromSuperview];
    [self.thirdAvatarView removeFromSuperview];
    [self.fourthAvatarView removeFromSuperview];
    
    self.timeLabel.text = [LCStringUtil getNotNullStr:timeStr];
    self.titleLabel.text = title;
    self.avatarImageView.image = [UIImage imageNamed:imageName];
    self.contentLabel.text = descString;
    if (unreadNum > 0) {
        if (unreadNum > 99) {
            self.dotLabel.text = @"99+";
        } else {
            self.dotLabel.text = [NSString stringWithFormat:@"%zd",unreadNum];
        }
        self.dotView.hidden = NO;
        if (unreadNum > 9) {
            self.dotViewWidth.constant = 28.0f;
        } else {
            self.dotViewWidth.constant = 17.0f;
        }
    } else {
        self.dotView.hidden = YES;
    }
    
}

- (void)updateShowWithChatContact:(LCChatContactModel *)chatContact coreDataContact:(XMPPMessageArchiving_Contact_CoreDataObject *)coreDataContact unreadNum:(NSInteger)unreadNum{
    [self.firstAvatarView removeFromSuperview];
    [self.secondAvatarView removeFromSuperview];
    [self.thirdAvatarView removeFromSuperview];
    [self.fourthAvatarView removeFromSuperview];
    if (chatContact) {
        switch (chatContact.type){
            case LCChatContactType_Default:
                break;
            case LCChatContactType_User:{
                self.avatarImageView.layer.cornerRadius = 25;
                self.avatarImageView.layer.masksToBounds = YES;
                if (chatContact.chatWithUser) {
                    LCUserModel *user = chatContact.chatWithUser;
                    [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
                    self.titleLabel.text = [LCStringUtil getNotNullStr:user.nick];
                }
            }
                break;
            case LCChatContactType_Plan:{
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2;
                self.avatarImageView.layer.masksToBounds = YES;
                if (chatContact.chatWithPlan) {
                    LCPlanModel *plan = chatContact.chatWithPlan;
                    if (plan.memberList.count > 1) {
                        self.avatarImageView.layer.cornerRadius = 0;
                        [self layoutAvatarImageView:plan];
                        self.avatarImageView.image = nil;
                    } else {
                        [self.avatarImageView setImageWithURL:[NSURL URLWithString:plan.roomAvatar] placeholderImage:nil];
                    }
                    
                    
                    self.titleLabel.text = [LCStringUtil getNotNullStr:plan.roomTitle];
                }
            }
                break;
            case LCChatContactType_Group:{//以前的大群，未做修改。
                
                self.avatarImageView.layer.cornerRadius = 3;
                self.avatarImageView.layer.masksToBounds = YES;
                if (chatContact.chatWithGroup) {
                    LCChatGroupModel *group = chatContact.chatWithGroup;
                    [self.avatarImageView setImageWithURL:[NSURL URLWithString:group.coverThumbUrl] placeholderImage:nil];
                    self.titleLabel.text = [LCStringUtil getNotNullStr:group.name];
                }
            }
                break;
        }
    }
    
    if (coreDataContact) {
        self.contentLabel.text = [LCStringUtil getNotNullStr:coreDataContact.mostRecentMessageBody];
        self.timeLabel.text = [LCDateUtil getChatTimeStringFromDate:coreDataContact.mostRecentMessageTimestamp];
    }
    
    if (unreadNum <= 0) {
        self.dotView.hidden = YES;
    }else{
        self.dotView.hidden = NO;
        if (unreadNum < 100) {
            self.dotLabel.text = [LCStringUtil integerToString:unreadNum];
        }else{
            self.dotLabel.text = @"...";
        }
    }
}


+ (CGFloat)getCellHeight{
    return 80;
}




#pragma mark InnerFunction

- (void)layoutAvatarImageView:(LCPlanModel *)model {
    
    self.avatarImageView.clipsToBounds = NO;
    if (model.memberList.count > 1) {
        LCUserModel *userModel = model.memberList[0];
        [self.firstAvatarView setImageWithURL:[NSURL URLWithString:userModel.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        userModel = model.memberList[1];
        [self.secondAvatarView setImageWithURL:[NSURL URLWithString:userModel.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        [self.avatarImageView addSubview:self.secondAvatarView];
        [self.avatarImageView addSubview:self.firstAvatarView];
        
        
    }
    
    if (model.memberList.count > 2) {
        LCUserModel *userModel = model.memberList[2];
        [self.thirdAvatarView setImageWithURL:[NSURL URLWithString:userModel.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        [self.avatarImageView addSubview:self.thirdAvatarView];
    }
    
    if (model.memberList.count > 3) {
        LCUserModel *userModel = model.memberList[3];
        [self.fourthAvatarView setImageWithURL:[NSURL URLWithString:userModel.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        [self.avatarImageView addSubview:self.fourthAvatarView];
        
    }

    if (model.memberList.count <= 1) {
        return;
    }
    
    CGFloat singleAvatarInnerWidth = singleAvatarWidth - 3;
    if (model.memberList.count == 4) {
        self.firstAvatarView.origin = CGPointMake(0, 0);
        self.secondAvatarView.origin = CGPointMake(singleAvatarInnerWidth, 0);
        self.thirdAvatarView.origin = CGPointMake(0, singleAvatarInnerWidth);
        self.fourthAvatarView.origin = CGPointMake(singleAvatarInnerWidth, singleAvatarInnerWidth);
    } else if (model.memberList.count == 3) {
        self.firstAvatarView.y = 0;
        self.firstAvatarView.xCenter = self.avatarImageView.width / 2;
        self.secondAvatarView.origin = CGPointMake(0, singleAvatarInnerWidth);
        self.thirdAvatarView.origin = CGPointMake(singleAvatarInnerWidth, singleAvatarInnerWidth);

    } else if (model.memberList.count == 2) {
        self.firstAvatarView.yCenter = self.avatarImageView.height / 2;
        self.firstAvatarView.x = 0;
        self.secondAvatarView.yCenter = self.avatarImageView.height / 2;
        self.secondAvatarView.x = singleAvatarInnerWidth;
    }
    
}
@end
