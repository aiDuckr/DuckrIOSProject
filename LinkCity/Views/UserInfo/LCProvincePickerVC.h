//
//  LCLocationPickerVC.h
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCProvincePickerDelegate;
@interface LCProvincePickerVC : LCBaseVC
@property (nonatomic,weak) id<LCProvincePickerDelegate> delegate;

+ (instancetype)createInstance;
@end

@protocol LCProvincePickerDelegate <NSObject>
- (void)provincePrcker:(LCProvincePickerVC *)provincePickerVC didSelectCity:(NSString *)cityName;
@end