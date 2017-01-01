//
//  LCXMPPHelper.h
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPFramework.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPRoomHybridStorage.h"
#import "XMPPRoomMemoryStorage.h"
#import "XMPPPrivacy.h"
#import "XMPPLogging.h"
#import "XMPPBlocking.h"
#import "XMPPMUC.h"

#import "LCXMPPUtil.h"


@protocol YSMessageDelegate <NSObject>
- (void)didReceiveMessageFromServer:(XMPPMessage *)message;
@end







@interface LCXMPPHelper : NSObject


@property (retain, nonatomic) id<YSMessageDelegate> messageDelegate;

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong) XMPPBlocking *xmppBlocking;
@property (nonatomic, strong) XMPPPrivacy *xmppPrivacy;
@property (nonatomic, strong) XMPPMUC *xmppMUC;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSMutableArray *onlineXMPPRoomArray;

//+ (instancetype)sharedInstance;
- (void)setup;

- (BOOL)connect;
- (void)goOnline;
- (void)goOffline;
- (void)disconnect;
- (void)teardownStream;

- (XMPPRoom *)getRoomOnlineWithRoomBareJid:(NSString *)roomBareJidStr;
- (void)getRoomOfflineWithRoomBareJid:(NSString *)roomBareJidStr;
- (void)getAllRoomOnline;
- (void)getAllRoomOffline;


- (void)saveContext;

- (void)clearBlock;
- (void)blockUserOfJid:(NSString *)jid;
- (void)unBlockUserOfJid:(NSString *)jid;

@end
