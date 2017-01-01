//
//  LCMerchantBankcardVC.h
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCMerchantBankcardVCDelegate <NSObject>
- (void)didSelectedBankcard:(LCBankcard *)bankcard;

@end

@interface LCMerchantBankcardVC : LCAutoRefreshVC
@property (strong, nonatomic) id<LCMerchantBankcardVCDelegate> delegate;
@end
