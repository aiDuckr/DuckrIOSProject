//
//  LCConfig.h
//  LinkCity
//
//  Created by 张宗硕 on 11/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCConfig : NSObject

- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

@property (nonatomic, assign) BOOL isNotifyComment;
@property (nonatomic, assign) BOOL isNotifyLike;

@end
