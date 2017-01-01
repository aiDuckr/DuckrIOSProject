//
//  LCSendPlanAllowOtherGenderCell.m
//  LinkCity
//
//  Created by lhr on 16/4/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendPlanAllowOtherGenderCell.h"
#import "UIView+BlocksKit.h"
@interface LCSendPlanAllowOtherGenderCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderCellHeight;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (weak, nonatomic) IBOutlet UIImageView *sendPlanChooseMaleIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sendPlanChooseFemaleIcon;
@property (weak, nonatomic) IBOutlet UIView *femaleGenderView;
@property (weak, nonatomic) IBOutlet UIView *maleGenderView;
@end

@implementation LCSendPlanAllowOtherGenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.genderCellHeight.constant = 45.f;
    self.genderLimit =  LCGenderLimitNone;
    [self.switchButton addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.femaleGenderView bk_whenTapped:^{
        self.sendPlanChooseFemaleIcon.hidden = NO;
        self.sendPlanChooseMaleIcon.hidden = YES;
        self.genderLimit =  LCGenderLimitGenderFemale;
    }];
    [self.maleGenderView bk_whenTapped:^{
        self.sendPlanChooseFemaleIcon.hidden = YES;
        self.sendPlanChooseMaleIcon.hidden = NO;
        self.genderLimit =  LCGenderLimitGenderMale;
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)switchIsChanged:(UISwitch *)sender {
    if ([sender isOn]) {
//        self.genderCellHeight.constant = 45.f;
        self.genderLimit =  LCGenderLimitNone;
    } else {
        //self.genderCellHeight.constant = 135.f;
        self.genderLimit =  LCGenderLimitGenderMale;
        //self.sendPlanChooseMaleIcon.hidden = NO;
        //self.sendPlanChooseFemaleIcon.hidden = YES;
    }
    //[self layoutIfNeeded];
    [self.delegate didStateChanged:self.genderLimit];
}

- (void)updateShowWithPlan:(LCPlanModel *)plan {
    if (plan.genderLimit == LCGenderLimitNone) {
        self.genderCellHeight.constant = 45.f;
    } else if (plan.genderLimit == LCGenderLimitGenderMale) {
        self.genderCellHeight.constant = 135.f;
        self.sendPlanChooseMaleIcon.hidden = NO;
        self.sendPlanChooseFemaleIcon.hidden = YES;
        //self.genderLimit =  LCGenderLimitGenderMale;
    } else {
        self.genderCellHeight.constant = 135.f;
        //self.genderLimit =  LCGenderLimitGenderMale;
        self.sendPlanChooseMaleIcon.hidden = YES;
        self.sendPlanChooseFemaleIcon.hidden = NO;


    }
}
@end
