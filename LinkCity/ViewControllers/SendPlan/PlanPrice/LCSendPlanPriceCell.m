//
//  LCSendPlanPriceCell.m
//  LinkCity
//
//  Created by Roy on 8/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendPlanPriceCell.h"
#import "CalendarHomeViewController.h"


@interface LCSendPlanPriceCell()<CalendarHomeViewDelegate,UITextFieldDelegate>

@end
@implementation LCSendPlanPriceCell

+ (CGFloat)getCellHeight{
    return 54;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.holderView.layer.masksToBounds = YES;
    self.holderView.layer.cornerRadius = 4;
    self.holderView.layer.borderWidth = 1;
    self.holderView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    
    self.priceTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithStage:(LCPartnerStageModel *)stage isFirstStage:(BOOL)isFirst{
    self.stage = stage;
    
    if (isFirst) {
        self.deleteStageButton.hidden = YES;
    }else{
        self.deleteStageButton.hidden = NO;
    }
    
    [self updateShow];
}

- (void)updateShow{
    if ([LCStringUtil isNotNullString:self.stage.startTime] &&
        [LCStringUtil isNotNullString:self.stage.endTime]) {
        
        self.timeLabel.text = [self getTimeStrFromStartTime:self.stage.startTime endTime:self.stage.endTime];
    }else{
        self.timeLabel.text = @"选择起止时间";
        self.stage.startTime = nil;
        self.stage.endTime = nil;
    }
    
    if ([LCDecimalUtil isOverZero:self.stage.price]) {
        self.priceTextField.text = [NSString stringWithFormat:@"￥%@",self.stage.price];
    }else{
        self.priceTextField.text = @"";
    }
}



- (IBAction)timeButtonAction:(id)sender {
    CalendarHomeViewController *calVC = [[CalendarHomeViewController alloc] init];
    calVC.delegate = self;
    [calVC setHotelToDay:365 selectStartDateforString:[LCStringUtil getNotNullStr:self.stage.startTime] selectEndDateforString:[LCStringUtil getNotNullStr:self.stage.endTime]];
    
    UIViewController *topVC = [LCSharedFuncUtil getTopMostViewController].navigationController;
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topVC pushViewController:calVC animated:YES];
    }
}

- (IBAction)deleteStageButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendPlanPriceCellDidClickDeleteStageButton:)]) {
        [self.delegate sendPlanPriceCellDidClickDeleteStageButton:self];
    }
}


#pragma mark CalendarHomeView Delegate
/// 选择起止时间完成.
- (void)chooseDateFinished:(CalendarHomeViewController *)controller {
    self.stage.startTime = controller.startDateStr;
    self.stage.endTime = controller.endDateStr;
    
    self.timeLabel.text = [self getTimeStrFromStartTime:controller.startDateStr endTime:controller.endDateStr];
}


#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([LCStringUtil isNullString:textField.text]) {
        textField.text = @"￥";
    }
    
    if ([self.delegate respondsToSelector:@selector(sendPlanPriceCell:requestToShowView:)]) {
        [self.delegate sendPlanPriceCell:self requestToShowView:textField];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.priceTextField) {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (![str hasPrefix:@"￥"]) {
            return NO;
        }else{
            str = [str substringFromIndex:1];
            if ([str hasPrefix:@"0"] && str.length>1) {
                return NO;
            }
        }
    }

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([LCStringUtil isNullString:textField.text] ||
        [textField.text isEqualToString:@"￥"]) {
        //如果未填金额，或者0，设置文本为空，显示placeHolder
        textField.text = @"";
        
        self.stage.price = nil;
    }else{
        NSString *priceStr = textField.text;
        if ([priceStr hasPrefix:@"￥"]) {
            priceStr = [priceStr substringFromIndex:1];
        }
        self.stage.price = [NSDecimalNumber decimalNumberWithString:priceStr];
    }
}

#pragma mark InnerFunc
- (NSString *)getTimeStrFromStartTime:(NSString *)startTimeStr endTime:(NSString *)endTimeStr{
    
    NSDate *startDate = [LCDateUtil dateFromString:startTimeStr];
    NSDate *endDate = [LCDateUtil dateFromString:endTimeStr];
    static NSDateFormatter *monthAndDayFormatter = nil;
    if (!monthAndDayFormatter) {
        monthAndDayFormatter = [[NSDateFormatter alloc] init];
        monthAndDayFormatter.dateFormat = @"MM.dd";
    }
    return [NSString stringWithFormat:@"%@-%@",[monthAndDayFormatter stringFromDate:startDate],[monthAndDayFormatter stringFromDate:endDate]];
}

@end
