//
//  LCHomeCellModel.m
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCHomeCellModel.h"

@implementation LCHomeCellModel


#pragma mark Public Interface
- (LCHomeCellType)getCellType{
    if (self.type > 6) {
        self.type = 0;
    }
    
    return self.type;
}

#pragma mark Life Cycle
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.type = [[dic objectForKey:@"Type"] integerValue];
        
        self.sectionHF = [[LCHomeSectionHFModel alloc] initWithDictionary:[dic objectForKey:@"SectionHF"]];
        self.partnerPlan = [[LCPlanModel alloc] initWithDictionary:[dic objectForKey:@"PartnerPlan"]];
        self.banner = [[LCHomeCategoryModel alloc] initWithDictionary:[dic objectForKey:@"Banner"]];
        self.user = [[LCUserModel alloc] initWithDictionary:[dic objectForKey:@"User"]];
        
        NSMutableArray *routeList = [[NSMutableArray alloc] init];
        for (NSDictionary *aHomeCategoryDic in [dic arrayForKey:@"RouteList"]) {
            LCHomeCategoryModel *aHomeCategory = [[LCHomeCategoryModel alloc] initWithDictionary:aHomeCategoryDic];
            if (aHomeCategory) {
                [routeList addObject:aHomeCategory];
            }
        }
        self.routeList = routeList;
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger:self.type forKey:@"Type"];
    
    [coder encodeObject:self.sectionHF forKey:@"SectionHF"];
    [coder encodeObject:self.partnerPlan forKey:@"PartnerPlan"];
    [coder encodeObject:self.banner forKey:@"Banner"];
    [coder encodeObject:self.user forKey:@"User"];
    [coder encodeObject:self.routeList forKey:@"RouteList"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.type = [coder decodeIntegerForKey:@"Type"];
        
        self.sectionHF = [coder decodeObjectForKey:@"SectionHF"];
        self.partnerPlan = [coder decodeObjectForKey:@"PartnerPlan"];
        self.banner = [coder decodeObjectForKey:@"Banner"];
        self.user = [coder decodeObjectForKey:@"User"];
        self.routeList = [coder decodeObjectForKey:@"RouteList"];
    }
    return self;
}
@end


