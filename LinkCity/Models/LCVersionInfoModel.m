//
//  LCVersionInfoModel.m
//  LinkCity
//
//  Created by roy on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCVersionInfoModel.h"

@implementation LCVersionInfoModel
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.version = [LCStringUtil getNotNullStr:[dic objectForKey:@"Version"]];
        self.forceUpdate = [LCStringUtil getNotNullStr:[dic objectForKey:@"ForceUpdate"]];
        self.url = [LCStringUtil getNotNullStr:[dic objectForKey:@"Url"]];
        self.descriptionStr = [LCStringUtil getNotNullStr:[dic objectForKey:@"Description"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.version forKey:@"Version"];
    [coder encodeObject:self.forceUpdate forKey:@"ForceUpdate"];
    [coder encodeObject:self.url forKey:@"Url"];
    [coder encodeObject:self.descriptionStr forKey:@"Description"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.version = [coder decodeObjectForKey:@"Version"];
        self.forceUpdate = [coder decodeObjectForKey:@"ForceUpdate"];
        self.url = [coder decodeObjectForKey:@"Url"];
        self.descriptionStr = [coder decodeObjectForKey:@"Description"];
    }
    return self;
}
@end

