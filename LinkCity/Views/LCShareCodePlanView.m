//
//  LCShareCodePlanView.m
//  LinkCity
//
//  Created by Roy on 12/24/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCShareCodePlanView.h"

@implementation LCShareCodePlanView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCShareCodePlanView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCShareCodePlanView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCShareCodePlanView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(250, 200);
}

- (void)updateShowWith:(LCPlanModel *)plan callBack:(void (^)(BOOL confirmed))callBack{
    self.plan = plan;
    self.callBack = callBack;
    
    //plan images
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoThumbUrl]) {
        self.imgA.hidden = NO;
        [self.imgA setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultPlaceImageName]];
    }else{
        self.imgA.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoThumbUrl]) {
        self.imgB.hidden = NO;
        [self.imgB setImageWithURL:[NSURL URLWithString:self.plan.secondPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultPlaceImageName]];
    }else{
        self.imgB.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoThumbUrl]) {
        self.imgC.hidden = NO;
        [self.imgC setImageWithURL:[NSURL URLWithString:self.plan.thirdPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultPlaceImageName]];
    }else{
        self.imgC.hidden = YES;
    }
    
    if ([plan isMerchantCostPlan]) {
        self.freePlanDescCell.hidden = YES;
        self.costPlanDescCell.hidden = NO;
        
        //declaration
        self.costPlanTitleLabel.text = [LCStringUtil getNotNullStr:self.plan.declaration];
        
        //price label
        NSDecimalNumber *lowestPrice = [NSDecimalNumber maximumDecimalNumber];
        for (LCPartnerStageModel *stage in self.plan.stageArray){
            if ([LCDecimalUtil isOverZero:stage.price] &&
                [stage.price compare:lowestPrice] == NSOrderedAscending) {
                lowestPrice = stage.price;
            }
        }
        self.costPlanPriceLabel.text = [NSString stringWithFormat:@"￥%@起",lowestPrice];
    }else{
        self.freePlanDescCell.hidden = NO;
        self.costPlanDescCell.hidden = YES;
        
        //depart and destination label
        NSString *departAndDestStr = [self.plan getDepartAndDestString];
        self.freePlanDepartAndDestLabel.text = [LCStringUtil getNotNullStr:departAndDestStr];
        
        //time label
        NSString *timeStr = [NSString stringWithFormat:@"出发日期：%@   全程%ld天",
                             [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime],
                             (long)self.plan.daysLong];
        self.freePlanTimeLabel.text = timeStr;
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if (self.callBack) {
        self.callBack(NO);
    }
}

- (IBAction)confirmBtnAction:(id)sender {
    if (self.callBack) {
        self.callBack(YES);
    }
}



@end
