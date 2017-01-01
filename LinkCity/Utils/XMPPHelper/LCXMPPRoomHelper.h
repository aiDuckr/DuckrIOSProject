//
//  LCXMPPRoomHelper.h
//  LinkCity
//
//  Created by roy on 3/31/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCXMPPRoomHelper : NSObject
@property (nonatomic, strong) NSMutableDictionary *onLineRoomDic; // key:jid, value:XMPPRoom


+ (instancetype)sharedInstance;
- (void)addRoomForJid:(NSString *)roomJid;
- (void)removeRoomForJid:(NSString *)roomJid;
@end
