//
//  LCSendPlanFillUserInfoView.m
//  LinkCity
//
//  Created by Roy on 6/19/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSendPlanFillUserInfoView.h"


@interface LCSendPlanFillUserInfoView()
@property (nonatomic, assign) BOOL sexIsMale;
@end

@implementation LCSendPlanFillUserInfoView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCSendPlanFillUserInfoView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCSendPlanFillUserInfoView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCSendPlanFillUserInfoView *sendPlanFillUserInfoView = (LCSendPlanFillUserInfoView *)v;
            return sendPlanFillUserInfoView;
        }
    }
    
    return nil;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(300, 312);
}

- (void)setEditingUser:(LCUserModel *)editingUser{
    _editingUser = editingUser;
    
    self.sexIsMale = [editingUser getUserSex] == SexMale;
    self.birthdayTextField.text = [LCStringUtil getNotNullStr:self.editingUser.birthday];
    self.livingPlaceTextField.text = [LCStringUtil getNotNullStr:self.editingUser.livingPlace];
    
    [self updateShow];
}

- (void)updateShow{
    if (self.sexIsMale) {
        [self setSexButton:self.maleBtn selected:YES];
        [self setSexButton:self.femaleBtn selected:NO];
    }else{
        [self setSexButton:self.maleBtn selected:NO];
        [self setSexButton:self.femaleBtn selected:YES];
    }
}

- (void)setSexButton:(UIButton *)btn selected:(BOOL)selected{
    if (selected) {
        [btn setImage:[UIImage imageNamed:@"RegisterSexSelected"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromR_G_B_A(112, 107, 102, 1) forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"RegisterSexDeselect"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromR_G_B_A(168, 164, 160, 1) forState:UIControlStateNormal];
    }
}


- (IBAction)maleButtonAction:(id)sender {
    self.sexIsMale = YES;
    [self updateShow];
}
- (IBAction)femaleButtonAction:(id)sender {
    self.sexIsMale = NO;
    [self updateShow];
}
- (IBAction)birthdayButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendPlanFillUserInfoViewPickBirthday:)]) {
        [self.delegate sendPlanFillUserInfoViewPickBirthday:self];
    }
}
- (IBAction)livingPlaceButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendPlanFillUserInfoViewPickLivingPlace:)]) {
        [self.delegate sendPlanFillUserInfoViewPickLivingPlace:self];
    }
}
- (IBAction)submitButtonAction:(id)sender {
    NSString *province = nil;
    NSString *city = nil;
    if (self.livingPlaceTextField.text) {
        NSArray *strArr = [self.livingPlaceTextField.text componentsSeparatedByString:LOCATION_CITY_SEPARATER];
        if (strArr && strArr.count==2) {
            province = strArr[0];
            city = strArr[1];
        }
    }
    
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester updateUserInfoWithNick:self.editingUser.nick
                                       sex:(self.sexIsMale ? SexMale : SexFemale)
                                 avatarURL:self.editingUser.avatarUrl
                            livingProvince:province
                               livingPlace:city
                                  realName:self.editingUser.realName
                                    school:self.editingUser.school
                                   company:nil
                                  birthday:self.birthdayTextField.text
                                 signature:self.editingUser.signature
                                profession:self.editingUser.professional
                              wantGoPlaces:self.editingUser.wantGoList
                              haveGoPlaces:self.editingUser.haveGoList
                                  callBack:^(LCUserModel *user, NSError *error)
     {
         [YSAlertUtil hideHud];
         
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
         }else{
             [LCDataManager sharedInstance].userInfo = user;
             
             if ([self.delegate respondsToSelector:@selector(sendPlanFillUserInfoView:finishSucceed:)]) {
                 [self.delegate sendPlanFillUserInfoView:self finishSucceed:YES];
             }
         }
     }];
}

@end
