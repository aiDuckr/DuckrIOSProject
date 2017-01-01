//
//  LCCarIdentityModel.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCCarIdentityModel.h"

@implementation LCCarIdentityModel

+ (instancetype)createInstance{
    LCCarIdentityModel *carModel = [[LCCarIdentityModel alloc] init];
    carModel.status = LCIdentityStatus_None;
    
    return carModel;
}

- (LCIdentityStatus)getIdentityStatus{
    return self.status;
}

#pragma mark
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.userName = [LCStringUtil getNotNullStr:[dic objectForKey:@"UserName"]];
        self.idNumber = [LCStringUtil getNotNullStr:[dic objectForKey:@"IdNumber"]];
        
        self.carBrand = [LCStringUtil getNotNullStr:[dic objectForKey:@"CarBrand"]];
        self.carType = [LCStringUtil getNotNullStr:[dic objectForKey:@"CarType"]];
        self.carLicense = [LCStringUtil getNotNullStr:[dic objectForKey:@"CarLicense"]];
        
        self.carSeat = [[dic objectForKey:@"CarSeat"] integerValue];
        self.carYear = [[dic objectForKey:@"CarYear"] integerValue];
        self.drivingYear = [[dic objectForKey:@"DrivingYear"] integerValue];
        
        self.carArea = [LCStringUtil getNotNullStr:[dic objectForKey:@"CarArea"]];
        self.dayPrice = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"DayPrice"] decimalValue]];
        self.dayPrice = [LCDecimalUtil getTwoDigitRoundDecimal:self.dayPrice];
        self.serviceNumber = [[dic objectForKey:@"ServiceNumber"] integerValue];
        
        NSNumber *statusNum = [dic objectForKey:@"Status"];
        self.status = [statusNum integerValue];
        self.reason = [LCStringUtil getNotNullStr:[dic objectForKey:@"Reason"]];
        
        self.drivingLicenseUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"DrivingLicenseUrl"]];
        self.drivingLicenseThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"DrivingLicenseThumbUrl"]];
        self.carPictureUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CarPictureUrl"]];
        self.carPictureThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CarPictureThumbUrl"]];
        self.vehicleLicenseUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"VehicleLicenseUrl"]];
        self.vehicleLicenseThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"VehicleLicenseThumbUrl"]];
        
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.userName forKey:@"UserName"];
    [coder encodeObject:self.idNumber forKey:@"IdNumber"];
    
    [coder encodeObject:self.carBrand forKey:@"CarBrand"];
    [coder encodeObject:self.carType forKey:@"CarType"];
    [coder encodeObject:self.carLicense forKey:@"CarLicense"];
    
    [coder encodeInteger:self.carSeat forKey:@"CarSeat"];
    [coder encodeInteger:self.carYear forKey:@"CarYear"];
    [coder encodeInteger:self.drivingYear forKey:@"DrivingYear"];
    
    [coder encodeObject:self.carArea forKey:@"CarArea"];
    [coder encodeObject:self.dayPrice forKey:@"DayPrice"];
    [coder encodeInteger:self.serviceNumber forKey:@"ServiceNumber"];
    
    [coder encodeInteger:self.status forKey:@"Status"];
    [coder encodeObject:self.reason forKey:@"Reason"];
    
    [coder encodeObject:self.drivingLicenseUrl forKey:@"DrivingLicenseUrl"];
    [coder encodeObject:self.drivingLicenseThumbUrl forKey:@"DrivingLicenseThumbUrl"];
    [coder encodeObject:self.carPictureUrl forKey:@"CarPictureUrl"];
    [coder encodeObject:self.carPictureThumbUrl forKey:@"CarPictureThumbUrl"];
    [coder encodeObject:self.vehicleLicenseUrl forKey:@"VehicleLicenseUrl"];
    [coder encodeObject:self.vehicleLicenseThumbUrl forKey:@"VehicleLicenseThumbUrl"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.userName = [coder decodeObjectForKey:@"UserName"];
        self.idNumber = [coder decodeObjectForKey:@"IdNumber"];
        
        self.carBrand = [coder decodeObjectForKey:@"CarBrand"];
        self.carType = [coder decodeObjectForKey:@"CarType"];
        self.carLicense = [coder decodeObjectForKey:@"CarLicense"];
        
        self.carSeat = [coder decodeIntegerForKey:@"CarSeat"];
        self.carYear = [coder decodeIntegerForKey:@"CarYear"];
        self.drivingYear = [coder decodeIntegerForKey:@"DrivingYear"];
        
        self.carArea = [coder decodeObjectForKey:@"CarArea"];
        self.dayPrice = [coder decodeObjectForKey:@"DayPrice"];
        self.serviceNumber = [coder decodeIntegerForKey:@"ServiceNumber"];
        
        self.status = [coder decodeIntegerForKey:@"Status"];
        self.reason = [coder decodeObjectForKey:@"Reason"];
        
        self.drivingLicenseUrl = [coder decodeObjectForKey:@"DrivingLicenseUrl"];
        self.drivingLicenseThumbUrl = [coder decodeObjectForKey:@"DrivingLicenseThumbUrl"];
        self.carPictureUrl = [coder decodeObjectForKey:@"CarPictureUrl"];
        self.carPictureThumbUrl = [coder decodeObjectForKey:@"CarPictureThumbUrl"];
        self.vehicleLicenseUrl = [coder decodeObjectForKey:@"VehicleLicenseUrl"];
        self.vehicleLicenseThumbUrl = [coder decodeObjectForKey:@"VehicleLicenseThumbUrl"];
    }
    return self;
}
@end

