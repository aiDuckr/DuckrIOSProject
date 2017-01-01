//
//  LCMerchantOrderDetailVC.h
//  LinkCity
//
//  Created by 张宗硕 on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMerchantOrderDetailVC : UIViewController
@property (retain, nonatomic) LCPlanModel *plan;
+ (instancetype)createInstance;
@end
