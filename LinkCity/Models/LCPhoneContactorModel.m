//
//  LCPhoneContactorModel.m
//  LinkCity
//
//  Created by roy on 3/15/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPhoneContactorModel.h"

@implementation LCPhoneContactorModel

// 重写判等方法
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[LCPhoneContactorModel class]]) {
        return NO;
    }
    
    return [self isEqualToPhoneContactorModel:(LCPhoneContactorModel *)object];
}

- (BOOL)isEqualToPhoneContactorModel:(LCPhoneContactorModel *)model {
    if (![LCStringUtil isEqualStringOrBothEmpty:self.name second:model.name]) {
        return NO;
    }
    if (![LCStringUtil isEqualStringOrBothEmpty:self.phone second:model.phone]) {
        return NO;
    }
    if (![LCStringUtil isEqualStringOrBothEmpty:self.avatarUrl second:model.avatarUrl]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return [self.name hash] ^ [self.phone hash] ^ [self.avatarUrl hash];
}

- (NSDictionary *)getDicOfModel{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:self.name]) {
        [dic setObject:self.name forKey:@"Name"];
    }
    if ([LCStringUtil isNotNullString:self.phone]) {
        [dic setObject:self.phone forKey:@"Phone"];
    }
    if ([LCStringUtil isNotNullString:self.avatarUrl]) {
        [dic setObject:self.avatarUrl forKey:@"AvatarUrl"];
    }
    return dic;
}


- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.name = [LCStringUtil getNotNullStr:[dic objectForKey:@"Name"]];
        self.phone = [LCStringUtil getNotNullStr:[dic objectForKey:@"Phone"]];
        self.avatarUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"AvatarUrl"]];
        self.uuid = [LCStringUtil getNotNullStr:@"UUID"];
        
        self.isSelected = NO;
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"Name"];
    [coder encodeObject:self.phone forKey:@"Phone"];
    [coder encodeObject:self.avatarUrl forKey:@"AvatarUrl"];
    [coder encodeObject:self.uuid forKey:@"UUID"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.name = [coder decodeObjectForKey:@"Name"];
        self.phone = [coder decodeObjectForKey:@"Phone"];
        self.avatarUrl = [coder decodeObjectForKey:@"AvatarUrl"];
        self.uuid = [coder decodeObjectForKey:@"UUID"];
    }
    return self;
}


@end
