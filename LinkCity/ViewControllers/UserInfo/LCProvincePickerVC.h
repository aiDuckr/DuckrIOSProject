//
//  LCProvincePickerVC.h
//  LinkCity
//
//  Created by 张宗硕 on 05/20/16.
//  Copyright (c) 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCProvincePickerDelegate;

@interface LCProvincePickerVC : LCBaseVC
@property (nonatomic, assign) BOOL isChosingLocalCity;

@property (nonatomic,weak) id<LCProvincePickerDelegate> delegate;

+ (instancetype)createInstance;

@end

@protocol LCProvincePickerDelegate <NSObject>
@optional
- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city;
@end