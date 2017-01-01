//
//  LCUserInfo.m
//  CityLink
//
//  Created by zzs on 14-7-19.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import "LCUserInfo.h"

@implementation LCUserInfo

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.cid = [LCStringUtil getNotNullStr:[dic objectForKey:@"CID"]];
        self.uuid = [LCStringUtil getNotNullStr:[dic objectForKey:@"UUID"]];
        self.telephone = [LCStringUtil getNotNullStr:[dic objectForKey:@"Telephone"]];
        self.nick = [LCStringUtil getNotNullStr:[dic objectForKey:@"Nick"]];
        self.realName = [LCStringUtil getNotNullStr:[dic objectForKey:@"RealName"]];
        self.livingPlace = [LCStringUtil getNotNullStr:[dic objectForKey:@"LivingPlace"]];
        self.sex = [LCStringUtil getNotNullStr:[dic objectForKey:@"Sex"]];
        self.avatarUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"AvatarUrl"]];
        self.avatarThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"AvatarThumbUrl"]];
        self.signature = [LCStringUtil getNotNullStr:[dic objectForKey:@"Signature"]];
        self.birthday = [LCStringUtil getNotNullStr:[dic objectForKey:@"Birthday"]];
        self.age = [LCStringUtil idToNSInteger:[dic objectForKey:@"Age"]];
        self.school = [LCStringUtil getNotNullStr:[dic objectForKey:@"School"]];
        self.company = [LCStringUtil getNotNullStr:[dic objectForKey:@"Company"]];
        self.openfireAccount = [LCStringUtil getNotNullStr:[dic objectForKey:@"OpenfireAccount"]];
        self.openfirePass = [LCStringUtil getNotNullStr:[dic objectForKey:@"OpenfirePass"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.partnerTime = [LCStringUtil idToNSInteger:[dic objectForKey:@"PartnerTime"]];
        self.receptionTime = [LCStringUtil idToNSInteger:[dic objectForKey:@"ReceptionTime"]];
        self.isFavored = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsFavored"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.cid forKey:@"CID"];
    [coder encodeObject:self.uuid forKey:@"UUID"];
    [coder encodeObject:self.telephone forKey:@"Telephone"];
    [coder encodeObject:self.nick forKey:@"Nick"];
    [coder encodeObject:self.realName forKey:@"RealName"];
    [coder encodeObject:self.livingPlace forKey:@"LivingPlace"];
    [coder encodeObject:self.sex forKey:@"Sex"];
    [coder encodeObject:self.avatarUrl forKey:@"AvatarUrl"];
    [coder encodeObject:self.avatarThumbUrl forKey:@"AvatarThumbUrl"];
    [coder encodeObject:self.signature forKey:@"Signature"];
    [coder encodeObject:self.birthday forKey:@"Birthday"];
    [coder encodeInteger:self.age forKey:@"Age"];
    [coder encodeObject:self.school forKey:@"School"];
    [coder encodeObject:self.company forKey:@"Company"];
    [coder encodeObject:self.openfireAccount forKey:@"OpenfireAccount"];
    [coder encodeObject:self.openfirePass forKey:@"OpenfirePass"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeInteger:self.partnerTime forKey:@"PartnerTime"];
    [coder encodeInteger:self.receptionTime forKey:@"ReceptionTime"];
    [coder encodeInteger:self.isFavored forKey:@"IsFavored"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.cid = [coder decodeObjectForKey:@"CID"];
        self.uuid = [coder decodeObjectForKey:@"UUID"];
        self.telephone = [coder decodeObjectForKey:@"Telephone"];
        self.nick = [coder decodeObjectForKey:@"Nick"];
        self.realName = [coder decodeObjectForKey:@"RealName"];
        self.livingPlace = [coder decodeObjectForKey:@"LivingPlace"];
        self.sex = [coder decodeObjectForKey:@"Sex"];
        self.avatarUrl = [coder decodeObjectForKey:@"AvatarUrl"];
        self.avatarThumbUrl = [coder decodeObjectForKey:@"AvatarThumbUrl"];
        self.signature = [coder decodeObjectForKey:@"Signature"];
        self.birthday = [coder decodeObjectForKey:@"Birthday"];
        self.age = [coder decodeIntegerForKey:@"Age"];
        self.school = [coder decodeObjectForKey:@"School"];
        self.company = [coder decodeObjectForKey:@"Company"];
        self.openfireAccount = [coder decodeObjectForKey:@"OpenfireAccount"];
        self.openfirePass = [coder decodeObjectForKey:@"OpenfirePass"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.partnerTime = [coder decodeIntegerForKey:@"PartnerTime"];
        self.receptionTime = [coder decodeIntegerForKey:@"ReceptionTime"];
        self.isFavored = [coder decodeIntegerForKey:@"IsFavored"];
    }
    return self;
}

- (void)updateValueWithObject:(id)sender {
    [super updateValueWithObject:sender];
    
    if ([sender isKindOfClass:[LCUserInfo class]]) {
        unsigned int propertyCount, i;
        objc_property_t *properties = NULL;
        
        properties = class_copyPropertyList([LCUserInfo class], &propertyCount);
        
        for (i=0; i<propertyCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            
            NSString *propNameStr = [NSString stringWithUTF8String:propName];
            [self setValue:[sender valueForKey:propNameStr] forKey:propNameStr];
            
        }
        
        free(properties);
    }
}

- (UserSex)getUserSexEnumValue {
    return UserSex_Male;
}

- (NSString *)getSexStringForChinese {
        return @"男";
}

- (UIImage *)getSexImageForPlanDetailPage {
        return nil;
}

- (UIImage *)getSexImageForPlanCommentPage {
        return nil;
}

- (UIImage *)getSexImageForSelfInfoPage {
        return nil;
}
@end
