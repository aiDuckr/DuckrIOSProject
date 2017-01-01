//
//  LCSendCostPlanStageCell.m
//  LinkCity
//
//  Created by Roy on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendCostPlanStageCell.h"

@interface LCSendCostPlanStageCell()<UITextFieldDelegate>

@end
@implementation LCSendCostPlanStageCell

- (void)awakeFromNib {
    self.priceTextField.delegate = self;
}

- (void)updateShowWithStage:(LCPartnerStageModel *)stage stageIndex:(NSInteger)index{
    self.stage = stage;
    self.stageLabel.text = [NSString stringWithFormat:@"第%ld期",(index+1)];
    
    if ([LCStringUtil isNotNullString:self.stage.startTime] &&
        [LCStringUtil isNotNullString:self.stage.endTime]) {
        NSString *startDateStr = [LCDateUtil getDotDateFromHorizontalLineStr:self.stage.startTime];
        NSString *endDateStr = [LCDateUtil getDotDateFromHorizontalLineStr:self.stage.endTime];
        [self.startDateBtn setTitle:[NSString stringWithFormat:@"%@-%@", startDateStr, endDateStr]
                           forState:UIControlStateNormal];
        [self.startDateBtn setTitleColor:UIColorFromRGBA(0x2c2a28, 1) forState:UIControlStateNormal];
    }else{
        [self.startDateBtn setTitle:@"选择活动出发日期" forState:UIControlStateNormal];
        [self.startDateBtn setTitleColor:UIColorFromRGBA(0xc9c5c1, 1) forState:UIControlStateNormal];
    }

    if ([LCDecimalUtil isOverZero:self.stage.price]) {
        self.priceTextField.text = [NSString stringWithFormat:@"%@元/人",self.stage.price];
    }else{
        self.priceTextField.text = @"";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"元/人" withString:@""];
    textField.text = str;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *endStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([self.delegate respondsToSelector:@selector(sendCostPlanStageCell:willChangePriceTextTo:)]) {
        [self.delegate sendCostPlanStageCell:self willChangePriceTextTo:endStr];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([LCStringUtil isNotNullString:textField.text]){
        self.stage.price = [NSDecimalNumber decimalNumberWithString:textField.text];
    }else{
        self.stage.price = nil;
    }
    
    if ([LCDecimalUtil isOverZero:self.stage.price]) {
        textField.text = [NSString stringWithFormat:@"%@元/人",self.stage.price];
    }else{
        textField.text = @"";
    }
    
    if ([self.delegate respondsToSelector:@selector(sendCostPlanStageCellDidInputPrice:)]) {
        [self.delegate sendCostPlanStageCellDidInputPrice:self];
    }
}


- (IBAction)startDateBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendCostPlanStageCellDidClickDate:)]) {
        [self.delegate sendCostPlanStageCellDidClickDate:self];
    }
}



@end
