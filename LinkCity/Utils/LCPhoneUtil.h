//
//  LCPhoneUtil.h
//  LinkCity
//
//  Created by 张宗硕 on 12/3/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPhoneContactorModel.h"

@interface LCPhoneUtil : NSObject
+ (BOOL)isPhoneNum:(NSString *)mobileNum;
+ (NSDictionary *)getTelphoneContactDic:(NSString *)telephone;

// @return  array of LCPhoneContactorModel
+ (NSArray *)getPhoneContactList;

+ (NSString *)formatPhoneString:(NSString *)origionPhone;

+ (void)checkAndUploadTelephoneContact;

@end
