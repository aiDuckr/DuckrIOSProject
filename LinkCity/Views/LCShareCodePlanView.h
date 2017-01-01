//
//  LCShareCodePlanView.h
//  LinkCity
//
//  Created by Roy on 12/24/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCShareCodePlanView : UIView
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) void(^callBack)(BOOL confirmed);

@property (weak, nonatomic) IBOutlet UIImageView *imgA;
@property (weak, nonatomic) IBOutlet UIImageView *imgB;
@property (weak, nonatomic) IBOutlet UIImageView *imgC;

@property (weak, nonatomic) IBOutlet UIView *costPlanDescCell;
@property (weak, nonatomic) IBOutlet UILabel *costPlanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costPlanPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *freePlanDescCell;
@property (weak, nonatomic) IBOutlet UILabel *freePlanDepartAndDestLabel;
@property (weak, nonatomic) IBOutlet UILabel *freePlanTimeLabel;


+ (instancetype)createInstance;
- (void)updateShowWith:(LCPlanModel *)plan callBack:(void(^)(BOOL confirmed))callBack;
@end


