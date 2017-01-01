//
//  LCChooseBankVC.h
//  LinkCity
//
//  Created by 张宗硕 on 6/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCChooseBankVCDelegate <NSObject>
- (void)didSelectedBankName:(NSString *)bankName;

@end

@interface LCChooseBankVC : LCAutoRefreshVC
@property (strong, nonatomic) id<LCChooseBankVCDelegate> delegate;
@end
