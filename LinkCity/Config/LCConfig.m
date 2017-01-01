//
//  LCConfig.m
//  LinkCity
//
//  Created by 张宗硕 on 11/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCConfig.h"

@implementation LCConfig

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isNotifyComment = YES;
        self.isNotifyLike = NO;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.isNotifyComment forKey:@"IsNotifyComment"];
    ZLog(@"In LCConfig encodeWithCoder the NotifyComment is %d", self.isNotifyComment);
    [coder encodeBool:self.isNotifyLike forKey:@"IsNotifyLike"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.isNotifyComment = [coder decodeBoolForKey:@"IsNotifyComment"];
        ZLog(@"In LCConfig encodeWithCoder the NotifyComment is %d", self.isNotifyComment);
        self.isNotifyLike = [coder decodeBoolForKey:@"IsNotifyLike"];
    }
    return self;
}

@end
