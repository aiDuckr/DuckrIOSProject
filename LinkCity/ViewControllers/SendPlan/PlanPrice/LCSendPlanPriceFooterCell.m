//
//  LCSendPlanPriceFooterCell.m
//  LinkCity
//
//  Created by Roy on 8/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendPlanPriceFooterCell.h"

@interface LCSendPlanPriceFooterCell()<UITextViewDelegate>

@end
@implementation LCSendPlanPriceFooterCell

+ (CGFloat)getCellHeight{
    CGFloat refundIntroHeight = [LCStringUtil getHeightOfString:[LCDataManager sharedInstance].orderRule.refundDescription
                                                           withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                                          lineSpace:LCTextFieldLineSpace
                                                         labelWidth:DEVICE_WIDTH-12-12];
    return 674 - 60 + refundIntroHeight;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.priceIncludeBg];
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.priceExcludeBg];
    [self.priceIncludeTextView setPlaceholder:@"费用包含的项目"];
    [self.priceExcludeTextView setPlaceholder:@"费用不包含的项目"];
    
    self.priceIncludeTextView.delegate = self;
    self.priceExcludeTextView.delegate = self;
    
    [self.refundIntroLabel setText:[LCStringUtil getNotNullStr:[LCDataManager sharedInstance].orderRule.refundDescription] withLineSpace:LCTextFieldLineSpace];
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
    
    [self updateShow];
}

- (void)setEditingPlan:(LCPlanModel *)editingPlan{
    _editingPlan = editingPlan;
    
    [self updateShow];
}

- (void)updateShow{
    
    [self updateEarnestRadioBtnShow];
    [self.earnestRadioBtnA setTitle:[NSString stringWithFormat:@"%@%%",[[self getEarnestRadioByIndex:0] decimalNumberByMultiplyingByPowerOf10:2 withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]]] forState:UIControlStateNormal];
    [self.earnestRadioBtnB setTitle:[NSString stringWithFormat:@"%@%%",[[self getEarnestRadioByIndex:1] decimalNumberByMultiplyingByPowerOf10:2 withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]]] forState:UIControlStateNormal];
    [self.earnestRadioBtnC setTitle:[NSString stringWithFormat:@"%@%%",[[self getEarnestRadioByIndex:2] decimalNumberByMultiplyingByPowerOf10:2 withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]]] forState:UIControlStateNormal];
    
    self.priceIncludeTextView.text = [LCStringUtil getNotNullStr:self.editingPlan.costInclude];
    self.priceExcludeTextView.text = [LCStringUtil getNotNullStr:self.editingPlan.costExclude];
}

- (void)updateEarnestRadioBtnShow{
    if (self.editingPlan) {
        self.earnestRadioIndex = [self getIndexByEarnestRadio:self.editingPlan.costRadio];
//        if ([LCDecimalUtil isOverZero:self.editingPlan.costRadio]) {
//            for (int i=0; i<[LCDataManager sharedInstance].orderRule.earnestRadioList.count; i++){
//                NSDecimalNumber *e = [LCDataManager sharedInstance].orderRule.earnestRadioList[i];
//                if ([e compare:self.editingPlan.costRadio] == NSOrderedSame) {
//                    self.earnestRadioIndex = i;
//                    break;
//                }
//            }
//        }
        
        NSArray *btnArray = @[self.earnestRadioBtnA, self.earnestRadioBtnB, self.earnestRadioBtnC];
        for (UIButton *btn in btnArray){
            btn.backgroundColor = [UIColor whiteColor];
        }
        UIButton *btn = btnArray[self.earnestRadioIndex];
        btn.backgroundColor = UIColorFromRGBA(DUCKER_YELLOW, 1);
    }
}

- (void)mergeUIDataIntoModel{
    self.editingPlan.costInclude = self.priceIncludeTextView.text;
    self.editingPlan.costExclude = self.priceExcludeTextView.text;
    self.editingPlan.costRadio = [self getEarnestRadioByIndex:self.earnestRadioIndex];
}


#pragma mark Button Action
- (IBAction)earnestIntroBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendPlanPriceFooterCellDidClickEarnestIntroButton:)]) {
        [self.delegate sendPlanPriceFooterCellDidClickEarnestIntroButton:self];
    }
}

- (IBAction)earnestRadioBtnAction:(UIButton *)sender {
    if (sender == self.earnestRadioBtnA) {
        self.earnestRadioIndex = 0;
    }else if(sender == self.earnestRadioBtnB) {
        self.earnestRadioIndex = 1;
    }else if(sender == self.earnestRadioBtnC) {
        self.earnestRadioIndex = 2;
    }
    
    [self mergeUIDataIntoModel];
    [self updateShow];
}

- (IBAction)addStageButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendPlanPriceFooterCellDidClickAddStageButton:)]) {
        [self.delegate sendPlanPriceFooterCellDidClickAddStageButton:self];
    }
}

- (IBAction)submitButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendPlanPriceFooterCellDidClickSubmitButton:)]) {
        [self.delegate sendPlanPriceFooterCellDidClickSubmitButton:self];
    }
}



#pragma mark Inner Func
- (NSDecimalNumber *)getEarnestRadioByIndex:(NSInteger)index{
    if ([LCDataManager sharedInstance].orderRule &&
        [LCDataManager sharedInstance].orderRule.earnestRadioList.count > index) {
        return [[LCDataManager sharedInstance].orderRule.earnestRadioList objectAtIndex:index];
    }else{
        return [NSDecimalNumber decimalNumberWithString:@"1"];
    }
}
- (NSInteger)getIndexByEarnestRadio:(NSDecimalNumber *)earnestRadio{
    __block NSInteger index = 0;
    
    [[LCDataManager sharedInstance].orderRule.earnestRadioList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDecimalNumber *anRadio = (NSDecimalNumber *)obj;
        if ([anRadio compare:earnestRadio] == NSOrderedSame) {
            index = idx;
        }
    }];
    return index;
}

#pragma mark UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(sendPlanPriceFooterCell:requestToShowView:)]) {
        [self.delegate sendPlanPriceFooterCell:self requestToShowView:textView];
    }
}


@end
