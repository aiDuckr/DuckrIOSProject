//
//  LCAllCountryCityVC.h
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
@protocol LCAllCountryCityVCDelegate;
@interface LCAllCountryCityVC : LCAutoRefreshVC
@property (nonatomic, strong) id<LCAllCountryCityVCDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *alphaArray;
@property (nonatomic, strong) NSMutableArray *arrayOfCityArray;
@end

@protocol LCAllCountryCityVCDelegate <NSObject>

- (void)allCountryCityVC:(LCAllCountryCityVC *)vc didSelectCityDic:(NSDictionary *)cityDic;

@end