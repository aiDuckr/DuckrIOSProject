//
//  LCCityModel.h
//  LinkCity
//
//  Created by 张宗硕 on 5/23/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCCityModel : LCBaseModel
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *cityShortName;
@property (strong, nonatomic) NSString *cityImage;
@property (strong, nonatomic) NSString *cityThumbImage;
@property (assign, nonatomic) NSInteger isOpened;
@end
