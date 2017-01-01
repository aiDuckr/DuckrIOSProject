//
//  LCInputSchoolAndHometownView.m
//  LinkCity
//
//  Created by whb on 16/8/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCInputSchoolAndHometownView.h"
#import "KLCPopup.h"

#import "LCProvincePickerVC.h"
#import "LCSchoolPickerVC.h"
#import "LCChooseProfessionVC.h"
@interface LCInputSchoolAndHometownView()
@end

@implementation LCInputSchoolAndHometownView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCInputSchoolAndHometownView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCInputSchoolAndHometownView *inputSchoolAndHometownView = (LCInputSchoolAndHometownView *)v;
            return inputSchoolAndHometownView;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 360);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.nameLabel.text=[LCStringUtil getNotNullStr:[LCDataManager sharedInstance].userInfo.nick];//名字
    [self.imageView setImageWithURL:[NSURL URLWithString:[LCDataManager sharedInstance].userInfo.avatarUrl]];
    if ([LCDataManager sharedInstance].userInfo.livingPlace.length > 0)
    self.homeTitle.text = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].userInfo.livingPlace];
    if ([LCDataManager sharedInstance].userInfo.school.length > 0)
    self.schoolTitle.text = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].userInfo.school];
    if ([LCDataManager sharedInstance].userInfo.professional.length > 0)
    self.tradeTitle.text = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].userInfo.professional];
}

- (IBAction)nextButtonAction:(id)sender {
    [self doUpdateUserInfo];
}
- (IBAction)passButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputSchoolAndHometownViewDidClickPass:)]) {
        [self.delegate inputSchoolAndHometownViewDidClickPass:self];
    }
}

- (IBAction)selectHometown:(id)sender {

    if ([self.delegate respondsToSelector:@selector(inputUserinfoViewDidClickHomeButton:)]) {
        [self.delegate inputUserinfoViewDidClickHomeButton:self];
    }
}

- (IBAction)selectSchool:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputUserinfoViewDidClickSchoolButton:)]) {
        [self.delegate inputUserinfoViewDidClickSchoolButton:self];
    }
}

- (IBAction)selectTrade:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputUserinfoViewDidClickTradeButton:)]) {
        [self.delegate inputUserinfoViewDidClickTradeButton:self];
    }
}

- (void)doUpdateUserInfo {
    
    NSString *placeStr = [LCDataManager sharedInstance].userInfo.livingPlace;
    NSString *province = @"";
    NSString *city = @"";
    if ([LCStringUtil isNotNullString:placeStr]) {
        NSArray *strArr = [placeStr componentsSeparatedByString:LOCATION_CITY_SEPARATER];
        if (strArr && strArr.count>=2) {
            province = [LCStringUtil getNotNullStr:[strArr objectAtIndex:0]];
            city = [LCStringUtil getNotNullStr:[strArr objectAtIndex:1]];
        }else{
            city = placeStr;
        }
    }
    [LCNetRequester updateUserInfoWithNick:nil
                                       sex:[LCDataManager sharedInstance].userInfo.sex
                                 avatarURL:nil
                            livingProvince:province
                               livingPlace:city
                                  realName:nil
                                    school:[LCDataManager sharedInstance].userInfo.school
                                   company:nil
                                  birthday:nil
                                 signature:nil
                                profession:[LCDataManager sharedInstance].userInfo.professional
                              wantGoPlaces:nil
                              haveGoPlaces:nil
                                  callBack:^(LCUserModel *user, NSError *error)
     {
         [YSAlertUtil hideHud];
         
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
         }else{
             if ([self.delegate respondsToSelector:@selector(inputSchoolAndHometownView:didUpdateinfo:)]) {
                 [self.delegate inputSchoolAndHometownView:self didUpdateinfo:user];
             }
         }
     }];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
