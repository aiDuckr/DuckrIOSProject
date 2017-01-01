//
//  LCWebPlanCell.m
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCWebPlanCell.h"

@implementation LCWebPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.createrContactButton addTarget:self action:@selector(contactButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateShowWebPlan:(LCWebPlanModel *)webPlanModel {
    self.webPlanModel = webPlanModel;
    if (nil == webPlanModel) {
        return ;
    }
    [self.planImageView setImageWithURL:[NSURL URLWithString:self.webPlanModel.coverUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    NSString *departAndDestStr = [webPlanModel getDepartAndDestString];
    self.routeLabel.text = [LCStringUtil getNotNullStr:departAndDestStr];
    NSString *timeStr = [LCDateUtil getDotDateFromHorizontalLineStr:self.webPlanModel.startTime];
    self.timeLabel.text = [LCStringUtil getNotNullStr:timeStr];
    
    self.descriptionLabel.text = [LCStringUtil getNotNullStr:self.webPlanModel.content];
    
    self.createrNickLabel.text = [LCStringUtil getNotNullStr:self.webPlanModel.nick];
    if ([LCStringUtil isNotNullString:self.webPlanModel.telephone]) {
        NSMutableAttributedString *telephoneStr = [[NSMutableAttributedString alloc] initWithString:self.webPlanModel.telephone attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:UIColorFromR_G_B_A(168, 164, 160, 1),                                                                                                                                                 NSFontAttributeName:[UIFont fontWithName:FONT_FUTURA size:14]}];
        
        NSMutableAttributedString *phoneTitle = [[NSMutableAttributedString alloc] initWithString:@"手机:" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:UIColorFromR_G_B_A(168, 164, 160, 1),                                                                                                                                                 NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:14]}];
        
        
        [phoneTitle appendAttributedString:telephoneStr];
        [self.createrContactButton setAttributedTitle:phoneTitle forState:UIControlStateNormal];
    } else if ([LCStringUtil isNotNullString:self.webPlanModel.wechat]) {
        [self.createrContactButton setTitle:[NSString stringWithFormat:@"微信:%@",self.webPlanModel.wechat] forState:UIControlStateNormal];
    } else if ([LCStringUtil isNotNullString:self.webPlanModel.qq]) {
        [self.createrContactButton setTitle:[NSString stringWithFormat:@"QQ:%@",self.webPlanModel.qq] forState:UIControlStateNormal];
    } else {
        [self.createrContactButton setTitle:nil forState:UIControlStateNormal];
    }
    
    self.fromWhereLabel.text = [LCStringUtil getNotNullStr:self.webPlanModel.source];
}

- (void)contactButtonAction{
    if ([LCStringUtil isNotNullString:self.webPlanModel.telephone]) {
        [LCSharedFuncUtil dialPhoneNumber:self.webPlanModel.telephone];
    }else if([LCStringUtil isNotNullString:self.webPlanModel.wechat]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webPlanModel.wechat;
        [YSAlertUtil tipOneMessage:@"已复制微信号" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
    }else if([LCStringUtil isNotNullString:self.webPlanModel.qq]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webPlanModel.qq;
        [YSAlertUtil tipOneMessage:@"已复制QQ号" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
    }
}

@end
