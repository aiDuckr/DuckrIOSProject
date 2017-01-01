//
//  LCMerchantConfirmRefundVC.h
//  LinkCity
//
//  Created by 张宗硕 on 6/15/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCMerchantConfirmRefundVCDelegate<NSObject>
- (void)confirmRefundSuccess;

@end

@interface LCMerchantConfirmRefundVC : LCAutoRefreshVC
@property (strong, nonatomic) LCUserModel *user;
@property (strong, nonatomic) id<LCMerchantConfirmRefundVCDelegate> delegate;
@end
