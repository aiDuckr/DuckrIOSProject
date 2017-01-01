//
//  XMPPMessage+Info.m
//  LinkCity
//
//  Created by roy on 1/14/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "XMPPMessage+Info.h"

@implementation XMPPMessage (Info)

- (NSDate *)sendDate{
    NSDate *sendDate = [self delayedDeliveryDate];
    if (sendDate) {
        return sendDate;
    }else{
        return [NSDate date];
    }
}

@end
