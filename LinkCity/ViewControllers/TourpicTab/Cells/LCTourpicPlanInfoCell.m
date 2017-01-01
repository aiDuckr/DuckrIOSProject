//
//  LCTourpicPlanInfoCell.m
//  LinkCity
//
//  Created by lhr on 16/5/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCTourpicPlanInfoCell.h"
#import "UIView+BlocksKit.h"
@interface LCTourpicPlanInfoCell()

@property (strong,nonatomic) LCPlanModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (weak, nonatomic) IBOutlet UIView *detailInfoView;

@property (weak, nonatomic) IBOutlet UIView *descView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@property (nonatomic,strong) UIView *spaLineView;
@end

@implementation LCTourpicPlanInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _spaLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.detailInfoView.height - 0.5, self.detailInfoView.width, 0.5)];
    _spaLineView.backgroundColor = DefaultSpalineColor;
    [self.detailInfoView bk_whenTapped:^{
        [self.delegate didJumpInfoDetailCell:self];

    }];
    [self.radioButton addTarget:self action:@selector(pressAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailInfoView addSubview:_spaLineView];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindWithData:(LCPlanModel *)model isSelected:(BOOL)selected{
    _model = model;
    [self.photoView setImageWithURL:[NSURL URLWithString:model.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.titleLabel.text = [model getDepartAndDestString];
    self.timeLabel.text = [model getPlanStartDateText];
    self.descLabel.text = model.descriptionStr;
    
    if ([LCDecimalUtil isOverZero:model.costPrice]) {
        self.costLabel.hidden = NO;
        self.costLabel.text = [NSString stringWithFormat:@"￥%@",model.costPrice];
    }else{
        self.costLabel.hidden = YES;
    }
    self.radioButton.selected = selected;
    
    //self.timeLabel.text = [model getDepartAndDestString];
}

- (IBAction)pressAction:(RadioButton *)sender {
    [self.delegate didSelectedDetailCell:self];
//    if (self.radioButton.selectedButton != sender) {
//
//    } else {
//        sender.Selected = NO;
//        [self.delegate didUnSelectedDetailCell];
//    }
    
}
@end
