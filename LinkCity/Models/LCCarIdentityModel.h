//
//  LCCarIdentityModel.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"
#import "LCConstants.h"



@interface LCCarIdentityModel : LCBaseModel
@property (nonatomic, strong) NSString *userName;   //用户真实姓名 4.1
@property (nonatomic, strong) NSString *idNumber;   //身份证号 4.1
@property (nonatomic, strong) NSString *carBrand;   //CarBrand: "奔驰"  // 必填，品牌
@property (nonatomic, strong) NSString *carType;     //"GLK280"    // 车型
@property (nonatomic, strong) NSString *carLicense; //CarLicense: "京A22322" // 必填，车牌号
@property (nonatomic, assign) NSInteger carSeat;    //CarSeat: 7   // 必填，车座数
@property (nonatomic, assign) NSInteger carYear;    //CarYear: 3   // 必填，车龄
@property (nonatomic, assign) NSInteger drivingYear;    //DrivingYear: 6    // 驾龄
@property (nonatomic, strong) NSString *carArea;    //CarArea: "拉萨－林芝"    // 服务路线
@property (nonatomic, strong) NSDecimalNumber *dayPrice;   //DayPrice: "400"    // 每天的价格
@property (nonatomic, assign) NSInteger serviceNumber;  // 服务过的人数
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *drivingLicenseUrl;
@property (nonatomic, strong) NSString *drivingLicenseThumbUrl;
@property (nonatomic, strong) NSString *carPictureUrl;
@property (nonatomic, strong) NSString *carPictureThumbUrl;
@property (nonatomic, strong) NSString *vehicleLicenseUrl;
@property (nonatomic, strong) NSString *vehicleLicenseThumbUrl;

+ (instancetype)createInstance;
- (LCIdentityStatus)getIdentityStatus;
@end
