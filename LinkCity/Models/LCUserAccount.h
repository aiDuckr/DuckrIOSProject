//
//  LCUserAccount.h
//  LinkCity
//
//  Created by 张宗硕 on 6/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUserAccount : LCBaseModel<NSCoding>
@property (strong, nonatomic) NSDecimalNumber *totalBalance;    //!> 余额.
@property (strong, nonatomic) NSDecimalNumber *availBalance;    //!> 余额.
@property (strong, nonatomic) NSArray *bankcardArr;     //!> 银行卡
@property (strong, nonatomic) NSDecimalNumber *uncollected;

@end
