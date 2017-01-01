//
//  LCBankcard.h
//  LinkCity
//
//  Created by 张宗硕 on 6/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCBankcard : LCBaseModel<NSCoding>
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *belongedBank;
@property (strong, nonatomic) NSString *bankcardNumber;

@end
