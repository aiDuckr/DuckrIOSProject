//
//  LCWxPrepayModel.m
//  LinkCity
//
//  Created by Roy on 8/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCWxPrepayModel.h"

@implementation LCWxPrepayModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.dic = dic;
        
        self.appid = [LCStringUtil getNotNullStr:[dic objectForKey:@"appid"]];
        self.mch_id = [LCStringUtil getNotNullStr:[dic objectForKey:@"mch_id"]];
        self.nonce_str = [LCStringUtil getNotNullStr:[dic objectForKey:@"nonce_str"]];
        self.prepay_id = [LCStringUtil getNotNullStr:[dic objectForKey:@"prepay_id"]];
        
        self.result_code = [LCStringUtil getNotNullStr:[dic objectForKey:@"result_code"]];
        self.return_code = [LCStringUtil getNotNullStr:[dic objectForKey:@"return_code"]];
        
        self.return_msg = [LCStringUtil getNotNullStr:[dic objectForKey:@"return_msg"]];
        self.sign = [LCStringUtil getNotNullStr:[dic objectForKey:@"sign"]];
        self.trade_type = [LCStringUtil getNotNullStr:[dic objectForKey:@"trade_type"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.dic forKey:@"dic"];
    
    [coder encodeObject:self.appid forKey:@"appid"];
    [coder encodeObject:self.mch_id forKey:@"mch_id"];
    [coder encodeObject:self.nonce_str forKey:@"nonce_str"];
    [coder encodeObject:self.prepay_id forKey:@"prepay_id"];
    
    [coder encodeObject:self.result_code forKey:@"result_code"];
    [coder encodeObject:self.return_code forKey:@"return_code"];
    
    [coder encodeObject:self.return_msg forKey:@"return_msg"];
    [coder encodeObject:self.sign forKey:@"sign"];
    [coder encodeObject:self.trade_type forKey:@"trade_type"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.dic = [coder decodeObjectForKey:@"dic"];
        
        self.appid = [coder decodeObjectForKey:@"appid"];
        self.mch_id = [coder decodeObjectForKey:@"mch_id"];
        self.nonce_str = [coder decodeObjectForKey:@"nonce_str"];
        self.prepay_id = [coder decodeObjectForKey:@"prepay_id"];
        
        self.result_code = [coder decodeObjectForKey:@"result_code"];
        self.return_code = [coder decodeObjectForKey:@"return_code"];
        
        self.return_msg = [coder decodeObjectForKey:@"return_msg"];
        self.sign = [coder decodeObjectForKey:@"sign"];
        self.trade_type = [coder decodeObjectForKey:@"trade_type"];
        
    }
    return self;
}


@end
