//
//  LCCostPlanDescptionCell.m
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanDescptionCell.h"
#import "LCPlanModel.h"
#import "LCSharedFuncUtil.h"
#import "LCUserModel.h"
#import "UILabel+LineSpace.h"
#import "TextHelper.h"
@interface LCCostPlanDescptionCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introCellHeight;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *destLabel;//详情

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) IBOutlet UIImageView *extendImageIcon;
@property (assign,nonatomic) BOOL isExtend;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomIntroInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introCellTopInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewHeight;

@property (nonatomic, strong) LCPlanModel *planModel;
@end

@implementation LCCostPlanDescptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.extendButton addTarget:self action:@selector(extendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.telButton addTarget:self action:@selector(telAction) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarButton addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
    //dialPhoneNumber:(NSString *)phoneNumber
    //self.descLabelHeight.constant = 100;
    self.destLabel.numberOfLines = 6;
   
    
    // Initialization code
}

- (void)bindWithData:(LCPlanModel *)model {
    self.planModel = model;
    //self.destLabel.backgroundColor = [UIColor blueColor];
    if (model.routeType == LCRouteTypeFreePlanCostCommon) {
        //self.destLabel.text = model.descriptionStr;
        NSString *string = [NSString stringWithFormat:@"%@",model.descriptionStr];
        [self.destLabel setText:string withLineSpace:10];
        
    
         //LCDefaultFontSize(14) andLineSpacing:10];
        self.infoLabel.text = @"";
    } else {
        //个人页改版之后这部分需要添加个人简介 by lhr
        //self.destLabel.text = [NSString stringWithFormat:@"%@ %@",model.descriptionStr,model.descriptionStr];
        //[self.destLabel setText:model.descriptionStr withLineSpace:10];
        
        NSString *string = [NSString stringWithFormat:@"%@",model.descriptionStr];
        [self.destLabel setText:string withLineSpace:10];
        self.infoLabel.text = @"";

    }
    LCUserModel * userModel =  [self.planModel.memberList objectAtIndex:0];
    if (userModel) {
        self.nameLabel.text =userModel.nick;
        [self.avatarView setImageWithURL:[NSURL URLWithString:userModel.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    }
    //绑定数据
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Extend Sender
- (void)extendAction {
    if (self.isExtend) {
        //UI切换成（展开）
        self.isExtend = NO;
        [self.extendButton setTitle:@"展开" forState:UIControlStateNormal];
        [self.extendImageIcon setImage:[UIImage imageNamed:@"PlanDetailExtendIcon"]];
        self.destLabel.numberOfLines = 6;
       
        //self.descLabelHeight.constant = 100;
        [self.delegate LCCostPlanDescptionDidChangedHeight];
        //[self layoutIfNeeded];
    } else {
        //UI切换成(不展开)
        self.isExtend = YES;
        [self.extendButton setTitle:@"收起" forState:UIControlStateNormal];
        [self.extendImageIcon setImage:[UIImage imageNamed:@"PlanDetailUnextendIcon"]];
        self.destLabel.numberOfLines = 0;
//        CGFloat textHeight = [TextHelper getTextHeightWithText:self.planModel.descriptionStr ConstraintWidth:self.destLabel.frame.size.width andFont:LCDefaultFontSize(14.0f) andLineSpacing:10];
        //self.descLabelHeight.constant = 200;
        //self.introCellHeight.constant = 0;
         //self.bottomViewHeight.constant = 210;
        [self.delegate LCCostPlanDescptionDidChangedHeight];
       
        
        //[self layoutIfNeeded];
    }
}

- (void)telAction {
    if (self.planModel.isAllowPhoneContact == 0) {
        [YSAlertUtil tipOneMessage:@"组织者不允许电话联系，请在线联系"];
    } else {
        LCUserModel * userModel =  [self.planModel.memberList objectAtIndex:0];
        [LCSharedFuncUtil dialPhoneNumber:userModel.telephone];
        
    }
    //self.planModel.IsAllowPhoneContact
    //[LCSharedFuncUtil dialPhoneNumber:self.planModel.telephone];
}

- (void)avatarAction {
    LCUserModel *user = [self.planModel.memberList objectAtIndex:0];
    [self.delegate LCCostPlanDescptionCellToViewUserDetail:user];
}

@end
