//
//  LCUserInfo.h
//  CityLink
//
//  Created by zzs on 14-7-19.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCStringUtil.h"
#import "LCBaseModel.h"

#define SEX_MALE_STRING @"1"
#define SEX_FEMALE_STRING @"2"

@interface LCUserInfo : LCBaseModel

- (id)initWithDictionary:(NSDictionary *)dic;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

@property (retain, nonatomic) NSString *cid;
@property (retain, nonatomic) NSString *uuid;
@property (retain, nonatomic) NSString *telephone;
@property (retain, nonatomic) NSString *nick;
@property (retain, nonatomic) NSString *realName;
/**
 livingPlace 使用#号划分，例如 河北#石家庄， 香港#
 */
@property (retain, nonatomic) NSString *livingPlace;
@property (retain, nonatomic) NSString *sex;
@property (retain, nonatomic) NSString *avatarUrl;
@property (retain, nonatomic) NSString *avatarThumbUrl;
@property (retain, nonatomic) NSString *signature;
@property (retain, nonatomic) NSString *birthday;
@property (assign, nonatomic) NSInteger age;
@property (retain, nonatomic) NSString *school;
@property (retain, nonatomic) NSString *company;
@property (retain, nonatomic) NSString *openfireAccount;
@property (retain, nonatomic) NSString *openfirePass;
@property (retain, nonatomic) NSString *createdTime;
@property (assign, nonatomic) NSInteger partnerTime;
@property (assign, nonatomic) NSInteger receptionTime;
@property (assign, nonatomic) NSInteger isFavored;  //A 看 B 的个人信息， 1:A收藏了B 0:A未收藏B

- (UserSex)getUserSexEnumValue;
- (NSString *)getSexStringForChinese;
- (UIImage *)getSexImageForPlanDetailPage;
- (UIImage *)getSexImageForPlanCommentPage;
- (UIImage *)getSexImageForSelfInfoPage;
@end
