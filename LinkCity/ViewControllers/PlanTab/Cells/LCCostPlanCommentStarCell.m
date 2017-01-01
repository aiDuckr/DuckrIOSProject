//
//  LCCostPlanCommentStarCell.m
//  LinkCity
//
//  Created by lhr on 16/6/7.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanCommentStarCell.h"
#import "LCCommentScoreView.h"
#import "UIView+BlocksKit.h"
#import "LCCostPlanDetailCommentVC.h"
@interface LCCostPlanCommentStarCell()
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) LCCommentScoreView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *midView;
@end

@implementation LCCostPlanCommentStarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scoreView = [[LCCommentScoreView alloc] initWithFrame:CGRectMake(4, 0, 95, 45) scoreViewType:LCCommentScoreViewTypePlanDetail];
    //self.scoreView.backgroundColor = [UIColor redColor];
    //self.scoreView.backgroundColor = [UIColor redColor];
    [self.midView addSubview:self.scoreView];
        // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindWithData:(LCPlanModel *)model {
 

    //self.contentView.backgroundColor = [UIColor redColor];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%zd人评价", model.commentNumber];
    self.scoreLabel.text = [model.avgPoint stringValue];
    [self.scoreView updateShowWithScore:[model.avgPoint integerValue]];
    //__weak typeof(self) weakSelf = self;
    [self bk_whenTapped:^{
        LCCostPlanDetailCommentVC *vc = [LCCostPlanDetailCommentVC createInstance];
        vc.planGuid = model.planGuid;
        [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:vc animated:APP_ANIMATION];
    }];
    //model.avgPoint
}

@end
