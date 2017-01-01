//
//  LCCostPlanArrangementCell.m
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanArrangementCell.h"
#import "UILabel+LineSpace.h"
#import "LCPlanModel.h"
@interface LCCostPlanArrangementCell ()


@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) IBOutlet UIImageView *extendIcon;

@property (assign ,nonatomic) BOOL isExtend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introCellHeight;
@property (nonatomic, strong) LCPlanModel *planModel;
@end

@implementation LCCostPlanArrangementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isExtend = NO;
    [self.extendButton addTarget:self action:@selector(extendAction) forControlEvents:UIControlEventTouchUpInside];
    self.includeLabel.numberOfLines = 3;
    self.excludeLabel.numberOfLines = 3;
    self.refundLabel.numberOfLines = 3;
    // Initialization code
    
}

- (void)bindWithData:(LCPlanModel *)model {
    self.planModel = model;
    self.includeLabel.text = model.costInclude;
    self.excludeLabel.text = model.costExclude;
    self.refundLabel.text = model.refundIntro;
    //self.refundLabel.text = model. //[NSString stringWithFormat:@"",];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)extendAction {
    if (self.isExtend) {
        //UI切换成（展开）
        self.isExtend = NO;
        [self.extendButton setTitle:@"展开" forState:UIControlStateNormal];
        [self.extendIcon setImage:[UIImage imageNamed:@"PlanDetailExtendIcon"]];
        self.includeLabel.numberOfLines = 3;
        self.excludeLabel.numberOfLines = 3;
        self.refundLabel.numberOfLines = 3;
        [self.delegate LCCostPlanArrangementDidChangedHeight];
        //self.refundLabel.text = self.planModel.refundIntro;
        //self.introCellHeight.constant = 200;
        //self.destLabel.numberOfLines = 6;
        //self.introCellHeight.constant = 0;
        //self.descLabelHeight.constant = 100;
        //self.bottomViewHeight.constant = 60;
        //[self layoutIfNeeded];
    } else {
        //UI切换成(不展开)
        self.isExtend = YES;
        [self.extendButton setTitle:@"收起" forState:UIControlStateNormal];
        [self.extendIcon setImage:[UIImage imageNamed:@"PlanDetailUnextendIcon"]];
        self.includeLabel.numberOfLines = 0;
        self.excludeLabel.numberOfLines = 0;
        self.refundLabel.numberOfLines = 0;
        [self.delegate LCCostPlanArrangementDidChangedHeight];
        //self.refundLabel.text = @"";
        //self.introCellHeight.constant = 315;
        //self.destLabel.numberOfLines = 0;
        //        CGFloat textHeight = [TextHelper getTextHeightWithText:self.planModel.descriptionStr ConstraintWidth:self.destLabel.frame.size.width andFont:LCDefaultFontSize(14.0f) andLineSpacing:10];
        //self.descLabelHeight.constant = 200;
        //self.introCellHeight.constant = 0;
        //self.bottomViewHeight.constant = 210;
        
        
        //[self layoutIfNeeded];
    }
}

@end
