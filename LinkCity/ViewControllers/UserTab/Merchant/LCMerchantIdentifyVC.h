//
//  LCMerchantIdentifyVC.h
//  LinkCity
//
//  Created by godhangyu on 16/6/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    LCMerchantIdentifyType_TravelAgency,      //旅行社/俱乐部
    LCMerchantIdentifyType_Guide,             //导游/领队
    LCMerchantIdentifyType_LocalEntertainment,//本地娱乐活动服务商
    
} LCMerchantIdentifyType;

@interface LCMerchantIdentifyVC : LCAutoRefreshVC

@property (nonatomic, assign) LCMerchantIdentifyType vcType;

@end
