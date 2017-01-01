//
//  LCPartnerStageModel.m
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPartnerStageModel.h"

@implementation LCPartnerStageModel


#pragma mark - 
- (NSString *)getDepartTimeStr{
    NSDate *startDate = [LCDateUtil dateFromString:self.startTime];
    static NSDateFormatter *monthAndDayFormatter = nil;
    if (!monthAndDayFormatter) {
        monthAndDayFormatter = [[NSDateFormatter alloc] init];
        monthAndDayFormatter.dateFormat = @"MM.dd出发";
    }
    return [monthAndDayFormatter stringFromDate:startDate];
}

#pragma mark -
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.planGuid = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanGuid"]];
        self.startTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"StartTime"]];
        self.endTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"EndTime"]];
        
        self.price = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"Price"]decimalValue]];
        self.price = [LCDecimalUtil getTwoDigitRoundDecimal:self.price];
        self.earnest = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"Earnest"]decimalValue]];
        self.earnest = [LCDecimalUtil getTwoDigitRoundDecimal:self.earnest];
        self.totalEarnest = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"TotalEarnest"]decimalValue]];
        self.totalEarnest = [LCDecimalUtil getTwoDigitRoundDecimal:self.totalEarnest];
        
        self.joinNumber = [[dic objectForKey:@"JoinNumber"] integerValue];
        self.totalNumber = [[dic objectForKey:@"TotalNumber"] integerValue];
        
        self.isMember = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsMember"]];
        
        NSMutableArray *memberArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *memberDic in [dic arrayForKey:@"Member"]) {
            LCUserModel *userModel = [[LCUserModel alloc] initWithDictionary:memberDic];
            if (userModel) {
                [memberArray addObject:userModel];
            }
        }
        self.member = memberArray;
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.planGuid forKey:@"PlanGuid"];
    [coder encodeObject:self.startTime forKey:@"StartTime"];
    [coder encodeObject:self.endTime forKey:@"EndTime"];
    
    [coder encodeObject:self.price forKey:@"Price"];
    [coder encodeObject:self.earnest forKey:@"Earnest"];
    
    [coder encodeInteger:self.joinNumber forKey:@"JoinNumber"];
    [coder encodeInteger:self.totalNumber forKey:@"TotalNumber"];
    
    [coder encodeInteger:self.isMember forKey:@"IsMember"];
    [coder encodeObject:self.member forKey:@"Member"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.planGuid = [coder decodeObjectForKey:@"PlanGuid"];
        self.startTime = [coder decodeObjectForKey:@"StartTime"];
        self.endTime = [coder decodeObjectForKey:@"EndTime"];
        
        self.price = [coder decodeObjectForKey:@"Price"];
        self.earnest = [coder decodeObjectForKey:@"Earnest"];
        
        self.joinNumber = [coder decodeIntegerForKey:@"JoinNumber"];
        self.totalNumber = [coder decodeIntegerForKey:@"TotalNumber"];
        
        self.isMember = [coder decodeIntegerForKey:@"IsMember"];
        self.member = [coder decodeObjectForKey:@"Member"];
    }
    return self;
}
@end


