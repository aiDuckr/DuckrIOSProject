//
//  LCMerchantInfoVC.h
//  LinkCity
//
//  Created by Roy on 8/28/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    MerchantInfoVCTab_Service,
    MerchantInfoVCTab_User,
} MerchantInfoVCTab;

@interface LCMerchantInfoVC : LCAutoRefreshVC
@property (nonatomic, strong) LCUserModel *user;
@property (nonatomic, strong) LCCarIdentityModel *carIdentity;
@property (nonatomic, strong) NSArray *planArray; //plans created by this user;   array of LCPlanModel
@property (nonatomic, strong) NSArray *tourpicArray;

@property (nonatomic, assign) MerchantInfoVCTab showingTab;
@end
