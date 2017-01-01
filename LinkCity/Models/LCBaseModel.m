//
//  LCBaseModel.m
//  LinkCity
//
//  Created by roy on 11/19/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@implementation LCBaseModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}



- (void)updateValueWithObject:(id)sender{
    //使用Runtime结合KVC进行更新数据
    if ([sender isKindOfClass:[LCBaseModel class]]) {
        unsigned int propertyCount, i;
        objc_property_t *properties = NULL;
        
        properties = class_copyPropertyList([LCBaseModel class], &propertyCount);
        
        for (i=0; i<propertyCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            
            NSString *propNameStr = [NSString stringWithUTF8String:propName];
            [self setValue:[sender valueForKey:propNameStr] forKey:propNameStr];
            
        }
        
        free(properties);
    }
}

- (instancetype)createNewInstance{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    id newIstance = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return newIstance;
}

@end
