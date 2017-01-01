//
//  LCTourPicDetailPlanInfoCell.m
//  LinkCity
//
//  Created by lhr on 16/5/9.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCTourPicDetailPlanInfoCell.h"

@interface LCTourPicDetailPlanInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *perCostLabel;
@property (nonatomic,strong) UIView *spaLineView;

@end



@implementation LCTourPicDetailPlanInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _spaLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, (self.width - 24), 0.5)];
    _spaLineView.backgroundColor = DefaultSpalineColor;
    [self.contentView addSubview:self.spaLineView];
}

- (void)bindWithData:(LCPlanModel *)model {
    //self.iconView
    [self.iconView setImageWithURL:[NSURL URLWithString:model.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.titleLabel.text = [model getDepartAndDestString];
    self.iconView.layer.cornerRadius = 1.0f;
    if ([LCDecimalUtil isOverZero:model.costPrice]) {
        self.costLabel.text = [LCDecimalUtil currencyStrFromDecimal:model.costPrice];
        self.costLabel.hidden = NO;
        self.perCostLabel.hidden = NO;
    } else {
        self.costLabel.hidden = YES;
        self.perCostLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
