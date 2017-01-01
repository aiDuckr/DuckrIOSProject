//
//  LCPhoneUtil.m
//  LinkCity
//
//  Created by 张宗硕 on 12/3/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCPhoneUtil.h"
#import <AddressBook/AddressBook.h>

@implementation LCPhoneUtil
+ (BOOL)isPhoneNum:(NSString *)mobileNum
{
    NSString *wideRegex = [NSString stringWithFormat:@"^1[\\d]{10}$"];
    NSPredicate *regextesWide = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", wideRegex];
    if (NO == [regextesWide evaluateWithObject:mobileNum]) {
        return NO;
    }
    return YES;
    
    
    //    /**
    //     * 手机号码
    //     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     * 联通：130,131,132,152,155,156,185,186
    //     * 电信：133,1349,153,180,189
    //     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    /**
    //     10         * 中国移动：China Mobile
    //     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    /**
    //     25         * 大陆地区固话及小灵通
    //     26         * 区号：010,020,021,022,023,024,025,027,028,029
    //     27         * 号码：七位或八位
    //     28         */
    //    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //
    //
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //
    //    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
    //        || ([regextestct evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    //    {
    //        return YES;
    //    }
    //    else
    //    {
    //        return NO;
    //    }
}

+ (NSDictionary *)getTelphoneContactDic:(NSString *)telephone
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:telephone])
    {
        [dic setObject:telephone forKey:@"SelfTelephone"];
    }
    NSArray *phoneList = [LCPhoneUtil getPhoneContactList];
    NSMutableArray *phoneDicList = [[NSMutableArray alloc] init];
    for (LCPhoneContactorModel *aPhoneContactor in phoneList){
        NSDictionary *aPhoneDic = [aPhoneContactor getDicOfModel];
        [phoneDicList addObject:aPhoneDic];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phoneDicList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if ([LCStringUtil isNotNullString:jsonStr])
    {
        [dic setObject:jsonStr forKey:@"TelephoneList"];
    }
    return dic;
}

+ (NSArray *)getPhoneContactList
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     accessGranted = granted;
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        accessGranted = YES;
    }
    NSArray *phoneList = nil;
    
    if (accessGranted)
    {
        //NSLog(@"we got the access right");
        phoneList = [LCPhoneUtil getAdressInfo:addressBook];
    }
    else
    {
        phoneList = [[NSArray alloc] init];
    }
    return phoneList;
    //CFRelease(addressBook);
}

/// 访问通讯录.
+ (NSArray *)getAdressInfo:(ABAddressBookRef)addressBook
{
    NSArray *phoneList = nil;
    
    CFArrayRef peoples = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(peoples),
                                                               peoples
                                                               );
    
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering()
                      );
    
    
    
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    phoneList = [LCPhoneUtil getAllPhoneData:peopleMutable withNumbers:nPeople];
    
    CFRelease(peoples);
    CFRelease(addressBook);
    CFRelease(peopleMutable);
    
    return phoneList;
}

+ (NSArray *)getAllPhoneData:(CFArrayRef)results withNumbers:(CFIndex)nPeople {
    NSMutableArray *phoneInfos = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < nPeople; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        /// 读取firstname.
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        firstName = [LCStringUtil getNotNullStr:firstName];
        lastName = [LCStringUtil getNotNullStr:lastName];
        
        NSString *personName = [NSString stringWithFormat:@"%@%@", lastName, firstName];
        
        NSString *personPhone = nil;
        
        if([LCStringUtil isNotNullString:personName])
        {
            /// 读取电话多值.
            ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for (int k = 0; k < ABMultiValueGetCount(phone); k++)
            {
                /// 获取电话Label.
                personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                personPhone = [LCStringUtil getNotNullStr:personPhone];
                personPhone = [LCPhoneUtil formatPhoneString:personPhone];
                
                //V3.0      get person as Model
                LCPhoneContactorModel *aPhoneContactor = [[LCPhoneContactorModel alloc] init];
                aPhoneContactor.phone = personPhone;
                aPhoneContactor.name = personName;
                aPhoneContactor.avatarUrl = nil;
                aPhoneContactor.isSelected = NO;
                [phoneInfos addObject:aPhoneContactor];
                
                //LCLogInfo(@"name:%@, phone:%@",personName,personPhone);
            }
        }
    }
    return phoneInfos;
}

+ (NSString *)formatPhoneString:(NSString *)origionPhone{
    NSString *ret = [origionPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    ret = [origionPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([ret hasPrefix:@"+86"]) {
        ret = [ret substringFromIndex:3];
    }else if([ret hasPrefix:@"86"]) {
        ret = [ret substringFromIndex:2];
    }
    return ret;
}

+ (void)checkAndUploadTelephoneContact {
    
    if ([LCStringUtil isNullString:[LCDataManager sharedInstance].userInfo.uUID]) {
        return;
    }
    
    NSString *telephone = [LCDataManager sharedInstance].userInfo.telephone;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self getPhoneContactList]];
    NSMutableArray *uploadArray = [NSMutableArray arrayWithArray:array];
    [uploadArray removeObjectsInArray:[LCDataManager sharedInstance].phoneContactList];
    
    // 更新本地存储的通讯录
    [LCDataManager sharedInstance].phoneContactList = [NSArray arrayWithArray:array];
    
    if (uploadArray.count > 0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if ([LCStringUtil isNotNullString:telephone])
        {
            [dic setObject:telephone forKey:@"SelfTelephone"];
        }
        
        NSMutableArray *phoneDicList = [[NSMutableArray alloc] init];
        for (LCPhoneContactorModel *aPhoneContactor in uploadArray){
            NSDictionary *aPhoneDic = [aPhoneContactor getDicOfModel];
            [phoneDicList addObject:aPhoneDic];
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phoneDicList options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if ([LCStringUtil isNotNullString:jsonStr])
        {
            [dic setObject:jsonStr forKey:@"TelephoneList"];
        }
        
        if ([[dic allKeys] containsObject:@"SelfTelephone"] && [[dic allKeys] containsObject:@"TelephoneList"]) {
            [LCNetRequester uploadAddressBookWithDic:dic callBack:^(NSError *error) {
                if (error) {
                    LCLogWarn(@"upload phone contact error:%@", error);
                } else {
                    LCLogInfo(@"upload phone contact succeed!");
                }
            }];
        }
    }
    
}



@end
