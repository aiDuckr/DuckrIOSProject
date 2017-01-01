//
//  LCCityPickerVC.h
//  LinkCity
//
//  Created by 张宗硕 on 05/20/16.
//  Copyright (c) 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCProvinceModel.h"

@protocol LCCityPickerVCDelegate;
@interface LCCityPickerVC : UIViewController
@property (strong, nonatomic) id<LCCityPickerVCDelegate> delegate;
@property (strong, nonatomic) LCProvinceModel *province;
+ (instancetype)createInstance;
@end

@protocol LCCityPickerVCDelegate <NSObject>
- (void)cityPrcker:(LCCityPickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city;
@end