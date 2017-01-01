//
//  LCParticipatedTableCell.m
//  LinkCity
//
//  Created by roy on 11/19/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCParticipatedTableCell.h"
#import "EGOImageView.h"
#import "LCDateUtil.h"
#import "LCPlanApi.h"
#import "YSAlertUtil.h"

@interface LCParticipatedTableCell()<LCPlanApiDelegate>

@property (weak, nonatomic) IBOutlet UIView *cellTopLine;
@property (weak, nonatomic) IBOutlet UIView *cellLeftBottomLine;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *footPrintImageView;
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@property (weak, nonatomic) IBOutlet EGOImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLineRightToDestination;

@property (nonatomic, strong) UIView *selectedBGView;
@end
@implementation LCParticipatedTableCell

- (void)showPlan:(LCPlan *)plan asLastCell:(BOOL)lastCell asFirstCell:(BOOL)firstCell{
    [self setPlan:plan];
    if (lastCell) {
        self.cellTopLine.hidden = NO;
        self.cellLeftBottomLine.hidden = YES;
        self.contentContainerView.hidden = YES;
    }else if(firstCell){
        self.cellTopLine.hidden = YES;
        self.cellLeftBottomLine.hidden = NO;
        self.contentContainerView.hidden = NO;
    }else{
        self.cellTopLine.hidden = NO;
        self.cellLeftBottomLine.hidden = NO;
        self.contentContainerView.hidden = NO;
    }
}

- (void)setPlan:(LCPlan *)plan{
    _plan = plan;
    
    if (!plan) {
        self.createDateLabel.text = @"The End";
        [self updateFootPrintImageView:NO];
    }else{
        if (plan.memberList && plan.memberList.count>0) {
            LCUserInfo *user = [plan.memberList objectAtIndex:0];
            self.avatarImageView.imageURL = [NSURL URLWithString:user.avatarThumbUrl];
            self.nickLabel.text = user.nick;
        }
        
        [self updateFootPrintImageView:plan.isCheckedIn];
        [self updateSignButton:plan.isCheckedIn];
        self.createDateLabel.text = [self getMonthStrFromString:plan.startTime];
        
        self.coverImageView.backgroundColor = [LCImageUtil getColorFromColorStr:plan.coverColor];
        [self.coverImageView setImageWithURL:[NSURL URLWithString:plan.imageCover]];
        self.destinationLabel.text = plan.destinationName;
        self.startDateLabel.text = [LCDateUtil getDotDateFromHorizontalLineStr:plan.startTime];
        NSInteger days = [LCDateUtil numberOfDaysFromTwoStr:plan.startTime withAnotherStr:plan.endTime];
        self.daysLabel.text = [NSString stringWithFormat:@"玩%tu天",days];
    }
}

- (void)awakeFromNib {
    self.contentContainerView.layer.cornerRadius = 5;
    self.contentContainerView.layer.masksToBounds = YES;
    self.bottomBarView.layer.cornerRadius = 5;
    self.bottomBarView.layer.masksToBounds = YES;
    self.bottomBarView.layer.borderColor = UIColorFromR_G_B_A(229, 229, 229, 1).CGColor;
    self.bottomBarView.layer.borderWidth = 1;
    
    CALayer *verticalLineLayer = [CALayer layer];
    verticalLineLayer.frame = CGRectMake(0, 0, 50, 50);
    verticalLineLayer.backgroundColor = self.verticalLineRightToDestination.backgroundColor.CGColor;
    [self.verticalLineRightToDestination.layer addSublayer:verticalLineLayer];
    self.verticalLineRightToDestination.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)signButtonClick:(UIButton *)sender {
    ZLog(@"signButtonClick...");
    if (!self.plan.isCheckedIn) {
        LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
        [planApi signPlan:self.plan.planGuid planType:self.plan.planType];
    }
}

- (void)updateSignButton:(BOOL)hasSigned{
    if (!hasSigned) {
        [self.signButton setImage:[UIImage imageNamed:@"ParticipatedPlanUnsign"] forState:UIControlStateNormal];
    }else{
        [self.signButton setImage:[UIImage imageNamed:@"ParticipatedPlanSign"] forState:UIControlStateNormal];
    }
}
- (void)updateFootPrintImageView:(BOOL)hasSigned{
    if (!hasSigned) {
        self.footPrintImageView.image = [UIImage imageNamed:@"ParticipatedPlanFprintOff"];
    }else{
        self.footPrintImageView.image = [UIImage imageNamed:@"ParticipatedPlanFprintOn"];
    }
}


- (NSString *)getMonthStrFromString:(NSString *)dateString{
    NSDate *date = [LCDateUtil dateFromString:dateString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM";
    NSString *str = [formatter stringFromDate:date];
    return str;
}

#pragma mark - PlanApi Delegate
- (void)planApi:(LCPlanApi *)api didSignPlanWithError:(NSError *)error{
    if (error) {
        if ([self.plan isKindOfClass:[LCReceptionPlan class]]) {
            [MobClick event:MobECheckinReception];
        }else if([self.plan isKindOfClass:[LCPartnerPlan class]]){
            [MobClick event:MobECheckinPartner];
        }
        RLog(@"did sign plan error %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"did sign plan succeed!");
        self.plan.isCheckedIn = 1;
        [self setPlan:self.plan];
        [YSAlertUtil tipOneMessage:@"签到成功!" delay:TIME_FOR_RIGHT_TIP];
    }
}

@end
