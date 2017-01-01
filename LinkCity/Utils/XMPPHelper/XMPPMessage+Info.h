//
//  XMPPMessage+Info.h
//  LinkCity
//
//  Created by roy on 1/14/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "XMPPMessage.h"
#import "NSXMLElement+XEP_0203.h"

@interface XMPPMessage (Info)

/**获取一个XMPPMessage的发送时间
    如果该消息有delay项，即后期拉取的信息，则返回当前时间减去delay时间
    如果没有delay项，即实时收到的信息，则返回当前时间
 */
- (NSDate *)sendDate;

@end
