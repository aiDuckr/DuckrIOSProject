//
//  LCProvinceModel.h
//  LinkCity
//
//  Created by 张宗硕 on 5/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCProvinceModel : LCBaseModel<NSCoding>
@property (strong, nonatomic) NSString *provinceID;
@property (strong, nonatomic) NSString *provniceName;
@property (strong, nonatomic) LCCityModel *city;

@end