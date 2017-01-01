//
//  LCXMPPHelper.m
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCXMPPHelper.h"

#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN | XMPP_LOG_FLAG_SEND_RECV; // | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif


#define XMPPQUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
//#define XMPPQUEUE dispatch_get_main_queue()

@interface LCXMPPHelper(){
    BOOL customCertEvaluation;
}
@end
@implementation LCXMPPHelper


#pragma mark - Public Interface
//+ (instancetype)sharedInstance{
//    static LCXMPPHelper *xmppHelper = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        xmppHelper = [[LCXMPPHelper alloc] init];
//    });
//    return xmppHelper;
//}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationReceiveChatMessageAddContact object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationDidReceiveXMPPMessage object:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setup{
    [self setupXMPPStream];
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [self.xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
    
    [[self xmppStream] sendElement:presence];
    
    //Roy
    //TODO:
    [self getAllRoomOnline];
//    [self.xmppMUC discoverServices];
//    [self.xmppMUC discoverRoomsForServiceNamed:@"proxy.duckrchat"];
//    [self.xmppMUC discoverRoomsForServiceNamed:@"conference.duckrchat"];
//    [self.xmppMUC discoverRoomsForServiceNamed:@"search.duckrchat"];
//    [self.xmppMUC discoverRoomsForServiceNamed:@"pubsub.duckrchat"];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
    //Roy
    [self getAllRoomOffline];
}


- (BOOL)connect
{
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    [self disconnect];
    [self goOffline];
    
    LCUserModel *userInfo = [[LCDataManager sharedInstance] userInfo];
    NSString *myJID =  userInfo.openfireAccount;
    
    if ([LCStringUtil isNullString:myJID] ||
        [LCStringUtil isNullString:userInfo.openfirePass])
    {
        return NO;
    }
    
    
    NSLog(@"my jid is %@", myJID);
    NSString *myPassword = [LCDataManager sharedInstance].userInfo.openfirePass;
    NSLog(@"my password is %@", myPassword);
    
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        LCLogError(@"Error connecting: %@", error);
        return NO;
    }
    
    NSLog(@"connect success and the jid is %@ password is %@", myJID, myPassword);
    return YES;
}

- (void)disconnect
{
    [self goOffline];
    [self.xmppStream disconnect];
}



#pragma mark - XMPP
- (void)setupXMPPStream
{
    NSAssert(self.xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    self.xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        self.xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    // xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
    /// 自动获取用户列表.
    self.xmppRoster.autoFetchRoster = YES;
    self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    
    self.xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppvCardStorage];
    
    self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppvCardTempModule];
    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
    // It can also be shared amongst multiple streams to further reduce hash lookups.
    
    self.xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    self.xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:self.xmppCapabilitiesStorage];
    
    self.xmppCapabilities.autoFetchHashedCapabilities = YES;
    self.xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    self.xmppBlocking = [[XMPPBlocking alloc] init];
    
    self.xmppPrivacy = [[XMPPPrivacy alloc] initWithDispatchQueue:XMPPQUEUE];
    
    self.xmppMUC = [[XMPPMUC alloc] initWithDispatchQueue:XMPPQUEUE];
    
    // Activate xmpp modules
    
    [self.xmppReconnect         activate:self.xmppStream];
//    [self.xmppRoster            activate:self.xmppStream];
//    [self.xmppvCardTempModule   activate:self.xmppStream];
//    [self.xmppvCardAvatarModule activate:self.xmppStream];
//    [self.xmppCapabilities      activate:self.xmppStream];
//    [self.xmppBlocking          activate:self.xmppStream];
//    [self.xmppMUC               activate:self.xmppStream];
    [self.xmppPrivacy            activate:self.xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [self.xmppStream addDelegate:self delegateQueue:XMPPQUEUE];
    [self.xmppRoster addDelegate:self delegateQueue:XMPPQUEUE];
    [self.xmppBlocking addDelegate:self delegateQueue:XMPPQUEUE];
    [self.xmppPrivacy addDelegate:self delegateQueue:XMPPQUEUE];
    [self.xmppMUC addDelegate:self delegateQueue:XMPPQUEUE];
    
    
    /// 创建消息保存策略（规则，规定）存储单聊的聊天记录.
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    
    /// 用消息保存策略创建消息保存组件.
    XMPPMessageArchiving *xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    /// 使组件生效.
    [xmppMessageArchivingModule activate:self.xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:XMPPQUEUE];
    
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    //
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    [self.xmppStream setHostName:[LCConstants xmppServerIp]];
    [self.xmppStream setHostPort:XMPP_SERVER_PORT];
    
    
    // You may need to alter these settings depending on the server you're connecting to
    customCertEvaluation = YES;
}

- (void)teardownStream
{
    [self.xmppStream removeDelegate:self];
    [self.xmppRoster removeDelegate:self];
    
    [self.xmppReconnect         deactivate];
    [self.xmppRoster            deactivate];
    [self.xmppvCardTempModule   deactivate];
    [self.xmppvCardAvatarModule deactivate];
    [self.xmppCapabilities      deactivate];
    
    [self.xmppStream disconnect];
    
    self.xmppStream = nil;
    self.xmppReconnect = nil;
    self.xmppRoster = nil;
    self.xmppRosterStorage = nil;
    self.xmppvCardStorage = nil;
    self.xmppvCardTempModule = nil;
    self.xmppvCardAvatarModule = nil;
    self.xmppCapabilities = nil;
    self.xmppCapabilitiesStorage = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
//    [socket performBlock:^{
//        [socket enableBackgroundingOnSocket];
//    }];
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *expectedCertName = [self.xmppStream.myJID domain];
    if (expectedCertName)
    {
        [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
    }
    
    if (customCertEvaluation)
    {
        [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
    }
}

/**
 * Allows a delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if the stream is secured with settings that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 * That is, if a delegate implements xmppStream:willSecureWithSettings:, and plugs in that key/value pair.
 *
 * Thus this delegate method is forwarding the TLS evaluation callback from the underlying GCDAsyncSocket.
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * This is why this method uses a completionHandler block rather than a normal return value.
 * The idea is that you should be performing SecTrustEvaluate on a background thread.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 *
 * Keep in mind that you can do all kinds of cool stuff here.
 * For example:
 *
 * If your development server is using a self-signed certificate,
 * then you could embed info about the self-signed cert within your app, and use this callback to ensure that
 * you're actually connecting to the expected dev server.
 *
 * Also, you could present certificates that don't pass SecTrustEvaluate to the client.
 * That is, if SecTrustEvaluate comes back with problems, you could invoke the completionHandler with NO,
 * and then ask the client if the cert can be trusted. This is similar to how most browsers act.
 *
 * Generally, only one delegate should implement this method.
 * However, if multiple delegates implement this method, then the first to invoke the completionHandler "wins".
 * And subsequent invocations of the completionHandler are ignored.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // The delegate method should likely have code similar to this,
    // but will presumably perform some extra security code stuff.
    // For example, allowing a specific self-signed certificate that is known to the app.
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    });
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSError *error = nil;
    NSString *myPassword = [LCDataManager sharedInstance].userInfo.openfirePass;
    if (![[self xmppStream] authenticateWithPassword:myPassword error:&error])
    {
        XMPPLogError(@"Error authenticating: %@", error);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self goOnline];
    [self.xmppPrivacy retrieveListWithName:XMPPPrivacyListName];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveXMPPConnected object:nil];
    ZLog(@"- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender");
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    LCLogInfo(@"didReceiveMessage**********************************%@",message);
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    // A simple example of inbound message handling.
    
//    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
//        //        if ([message isChatMessageWithBody]) {
//        //
//        //            if ([[LCDataManager sharedInstance].userInfo.openfireAccount isEqualToString:message.to.bare]) {
//        //                //收到发给我的消息
//        //                [[LCDataManager sharedInstance] addUnreadNumForBareJidStr:message.from.bare];
//        //
//        //                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDidReceiveXMPPChatMessage object:nil userInfo:@{XMPPMessageKey:message}];
//        //            }
//        //        }else if([message isGroupMessageWithBody]) {
//        //
//        //        }
//    }else{
//        // We are not active, so use a local notification instead
//        if ([message isChatMessageWithBody] ||
//            [message isGroupMessageWithBody]) {
//            
//            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//            localNotification.alertAction = @"Ok";
//            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",message.from.bare,message.body];
//            
//            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//        }
//    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
//    //DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
//    //取得好友状态
//    NSString *presenceType = [presence type]; //online/offline
//    //当前用户
//    NSString *userId = [[sender myJID] user];
//    //在线用户
//    NSString *presenceFromUser = [[presence from] user];
//    
//    if (![presenceFromUser isEqualToString:userId])
//    {
//        if ([presenceType isEqualToString:@"available"])
//        {
//            //NSLog(@"online user is %@", presenceFromUser);
//            [self.chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, XMPP_SERVER_NAME]];
//        }
//    }
//    NSLog(@"the presence is %@", [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [YSAlertUtil tipOneMessage:LCChatSendMessageFailToast yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
    });
}



#pragma mark XMPPRosterDelegate

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    XMPPLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [self.xmppRosterStorage userForJID:[presence from]
                                                                  xmppStream:self.xmppStream
                                                        managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    
}



#pragma mark - XMPP Room
- (NSMutableArray *)onlineXMPPRoomArray{
    if (!_onlineXMPPRoomArray) {
        _onlineXMPPRoomArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _onlineXMPPRoomArray;
}


- (void)getAllRoomOnline{
    LCLogInfo(@"getAllRoomOnline");
    [self getAllRoomOffline];
    
    [LCNetRequester getJoinedChatRoomJIDListWithCallback:^(NSArray *roomJidList, NSInteger maxAutoOnlineCount, NSError *error) {
        if (error) {
            LCLogWarn(@"getJoinedChatRoomJIDListWithCallback error:%@",error);
        }else if(roomJidList && roomJidList.count>0){
            
            LCLogInfo(@"getJoinedChatRoomJIDListWithCallback %@   %ld",roomJidList,(long)roomJidList.count);
            NSArray *coreDataRoomChatContact = [LCXMPPUtil loadRecentChatContact:CHAT_CONTACT_TYPE_GROUPCHAT];
            NSArray *coreDataRoomJidList = [coreDataRoomChatContact valueForKey:@"bareJidStr"];
            
            NSMutableSet *jidSet = [[NSMutableSet alloc] init];
            for (int i=0; i<coreDataRoomJidList.count && jidSet.count<=maxAutoOnlineCount; i++){
                [jidSet addObject:[coreDataRoomJidList objectAtIndex:i]];
            }
            
            for (int i=0; i<roomJidList.count && jidSet.count<=maxAutoOnlineCount; i++){
                [jidSet addObject:[roomJidList objectAtIndex:i]];
            }
            
            for (NSString *aRoomJid in jidSet){
                [self getRoomOnlineWithRoomBareJid:aRoomJid];
            }
        }
    }];
}
- (XMPPRoom *)getRoomOnlineWithRoomBareJid:(NSString *)roomBareJidStr{
    //    LCLogInfo(@"getRoomOnline:%@   \r\n%@",roomBareJidStr,[NSThread callStackSymbols]);
    LCLogInfo(@"getRoomOnline:%@",roomBareJidStr);
    
    if ([LCStringUtil isNullString:roomBareJidStr]) {
        return nil;
    }
    
    XMPPJID *roomJid = [XMPPJID jidWithString:roomBareJidStr];
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance]
                                                       jid:roomJid
                                             dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
    [room activate:self.xmppStream];
    
    NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
    //拉取未读消息
    //如果是首次加入群(数据库中没有以往聊天记录)，则拉取之前一定数量的消息
    NSDate *lastMsgDate = [LCXMPPUtil getGroupChatLastOneMsgDate:roomBareJidStr];
    NSString *lastMsgDateStr = [LCDateUtil getUTCStringFromLocalDate:[NSDate dateWithTimeInterval:1 sinceDate:lastMsgDate]];
    if ([LCXMPPUtil amINewToGroupChat:roomBareJidStr]) {
        [history addAttributeWithName:@"maxstanzas" stringValue:[NSString stringWithFormat:@"%d",MESAAGE_COUNT_USER_FIRST_JOIN_GROUP_CHAT]];
    }else{
        [history addAttributeWithName:@"since" stringValue:lastMsgDateStr];
    }
    
    [room joinRoomUsingNickname:[LCDataManager sharedInstance].userInfo.telephone history:history];
    
    
    [self.onlineXMPPRoomArray addObject:room];
    LCLogInfo(@"did getRoomOnline:%@",roomBareJidStr);
    return room;
}
- (void)getAllRoomOffline{
    for (XMPPRoom *room in self.onlineXMPPRoomArray){
        [room leaveRoom];
    }
    [self.onlineXMPPRoomArray removeAllObjects];
}
- (void)getRoomOfflineWithRoomBareJid:(NSString *)roomBareJidStr{
    if ([LCStringUtil isNotNullString:roomBareJidStr]) {
        for (XMPPRoom *room in self.onlineXMPPRoomArray){
            if ([room.roomJID.bare isEqualToString:roomBareJidStr]) {
                [room leaveRoom];
                [self.onlineXMPPRoomArray removeObject:room];
                break;
            }
        }
    }
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [self.xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [self.xmppCapabilitiesStorage mainThreadManagedObjectContext];
}



#pragma mark Core Data stack
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LinkCity" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LinkCity.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}




- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.baiying.LinkCity" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




#pragma mark - NSNotification Action
- (void)notificationAction:(NSNotification *)notification{
    if ([notification.name isEqualToString:NotificationReceiveChatMessageAddContact]) {
        //如果是由于收到消息，添加了一个新聊天会话
        //如果该会话是群聊，刚将该聊上线
        XMPPMessage *message = [notification.userInfo objectForKey:XMPPMessageKey];
        if ([message isGroupMessage]) {
            [self getRoomOnlineWithRoomBareJid:message.from.bare];
        }
    }else if([notification.name isEqualToString:NotificationDidReceiveXMPPMessage]) {
        //如果是收到一条聊天消息，区分单聊和群聊，分别添加未读消息数，并发通知
        XMPPMessage *message = [notification.userInfo objectForKey:XMPPMessageKey];
        if ([message isChatMessageWithBody] &&
            [[LCDataManager sharedInstance].userInfo.openfireAccount isEqualToString:message.to.bare]) {
            //收到发给我的消息
            [[LCDataManager sharedInstance] addUnreadNumForBareJidStr:message.from.bare];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDidReceiveXMPPChatMessage object:nil userInfo:@{XMPPMessageKey:message}];
        }else if([message isGroupMessageWithBody] &&
                 [[LCDataManager sharedInstance].userInfo.openfireAccount isEqualToString:message.to.bare] &&
                 ![message.from.resource isEqualToString:[LCDataManager sharedInstance].userInfo.telephone]) {
            //如果是群聊
            //并且是发给我的消息
            //并且发送者不是我
            
            if ([LCStringUtil isNotNullString:message.info]) {
                //存在info字段
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDidReceiveXMPPGroupMessage object:nil userInfo:@{XMPPMessageKey:message}];
                [[LCDataManager sharedInstance] addUnreadNumForBareJidStr:message.from.bare];
                
            }
        }
    }
}


#pragma mark - XMPPMUC Delegate
- (void)xmppMUC:(XMPPMUC *)sender didDiscoverServices:(NSArray *)services{
    LCLogInfo(@"didDiscoverServices:%@",services);
}
- (void)xmppMUCFailedToDiscoverServices:(XMPPMUC *)sender withError:(NSError *)error{
    LCLogInfo(@"xmppMUCFailedToDiscoverServices:%@",error);
}
- (void)xmppMUC:(XMPPMUC *)sender didDiscoverRooms:(NSArray *)rooms forServiceNamed:(NSString *)serviceName{
    LCLogInfo(@"didDiscoverRooms:%@,rooms:%@  %ld",serviceName,rooms,(long)[rooms count]);
    if (rooms) {
        LCLogInfo(@"didDiscoverRooms:%@,rooms:%@  %ld",serviceName,rooms,(long)[rooms count]);
        NSString *logMsg = @"";
        for (NSXMLElement *aRoom in rooms){
            NSString *jid = [[aRoom attributeForName:@"jid"] stringValue];
            NSString *name = [[aRoom attributeForName:@"name"] stringValue];
            logMsg = [logMsg stringByAppendingFormat:@"%@   %@",jid,name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getRoomOnlineWithRoomBareJid:jid];
            });
        }
        LCLogInfo(@"didDiscoverRooms \r\n%@",logMsg);
    }
}
- (void)xmppMUC:(XMPPMUC *)sender failedToDiscoverRoomsForServiceNamed:(NSString *)serviceName withError:(NSError *)error{
    LCLogInfo(@"didFailedToDiscoverRooms %@   %@",serviceName,error);
}


#pragma mark Block User
- (void)clearBlock{
    [self.xmppPrivacy setListWithName:XMPPPrivacyListName items:nil];
    [self.xmppPrivacy setDefaultListName:XMPPPrivacyListName];
}
- (void)blockUserOfJid:(NSString *)jid{
    if ([LCStringUtil isNotNullString:jid]) {
        NSArray *curPrivacyList = [self.xmppPrivacy listWithName:XMPPPrivacyListName];
        NSMutableArray *mutablePrivacyList;
        
        if (!curPrivacyList || curPrivacyList.count<=0) {
            NSInteger order = 1;
            NSXMLElement *denyJidXML = [XMPPPrivacy privacyItemWithType:@"jid" value:jid action:@"deny" order:order++];
            NSXMLElement *allowXML = [XMPPPrivacy privacyItemWithAction:@"allow" order:order++];
            mutablePrivacyList = [[NSMutableArray alloc] initWithCapacity:2];
            [mutablePrivacyList addObject:denyJidXML];
            [mutablePrivacyList addObject:allowXML];
        }else{
            mutablePrivacyList = [[NSMutableArray alloc] initWithCapacity:curPrivacyList.count];
            
            /*Roy 2015.5.25
             如果直接复制curPrivacyList, 会在后续组装XML时异常
             [DDXMLElement addChild:]   /Libs/XMPP/Vendor/KissXML/DDXMLElement.m:701
             所以这里重新根据已有items生成了一遍XML
             */
            for (NSXMLElement *xml in curPrivacyList){
                if ([LCStringUtil isNullString:[xml attributeStringValueForName:@"type"]]) {
                    [mutablePrivacyList addObject:[XMPPPrivacy privacyItemWithAction:[xml attributeStringValueForName:@"action"] order:[xml attributeIntegerValueForName:@"order"]]];
                }else{
                    [mutablePrivacyList addObject:[XMPPPrivacy privacyItemWithType:[xml attributeStringValueForName:@"type"] value:[xml attributeStringValueForName:@"value"] action:[xml attributeStringValueForName:@"action"] order:[xml attributeIntegerValueForName:@"order"]]];
                }
            }
            
            NSXMLElement *lastXML = [mutablePrivacyList lastObject];
            NSInteger order = [lastXML attributeIntegerValueForName:@"order"];
            
            NSXMLElement *denyJidXML = [XMPPPrivacy privacyItemWithType:@"jid" value:jid action:@"deny" order:order++];
            [lastXML addAttributeWithName:@"order" integerValue:order++];
            
            [mutablePrivacyList removeLastObject];
            [mutablePrivacyList addObject:denyJidXML];
            [mutablePrivacyList addObject:lastXML];
        }
        
        [self.xmppPrivacy setListWithName:XMPPPrivacyListName items:mutablePrivacyList];
        [self.xmppPrivacy setDefaultListName:XMPPPrivacyListName];
    }
}
- (void)unBlockUserOfJid:(NSString *)jid{
    if ([LCStringUtil isNotNullString:jid]) {
        NSArray *curPrivacyList = [self.xmppPrivacy listWithName:XMPPPrivacyListName];
        NSMutableArray *mutablePrivacyList = [[NSMutableArray alloc] initWithCapacity:curPrivacyList.count];
        
        /*Roy 2015.5.25
         如果直接复制curPrivacyList, 会在后续组装XML时异常
         [DDXMLElement addChild:]   /Libs/XMPP/Vendor/KissXML/DDXMLElement.m:701
         所以这里重新根据已有items生成了一遍XML
         */
        for (NSXMLElement *xml in curPrivacyList){
            if ([LCStringUtil isNullString:[xml attributeStringValueForName:@"type"]]) {
                [mutablePrivacyList addObject:[XMPPPrivacy privacyItemWithAction:[xml attributeStringValueForName:@"action"] order:[xml attributeIntegerValueForName:@"order"]]];
            }else{
                [mutablePrivacyList addObject:[XMPPPrivacy privacyItemWithType:[xml attributeStringValueForName:@"type"] value:[xml attributeStringValueForName:@"value"] action:[xml attributeStringValueForName:@"action"] order:[xml attributeIntegerValueForName:@"order"]]];
            }
        }
        
        for (NSXMLElement *privacyItem in mutablePrivacyList){
            NSString *value = [privacyItem attributeStringValueForName:@"value"];
            if ([value isEqualToString:jid]) {
                [mutablePrivacyList removeObject:privacyItem];
                break;
            }
        }
        
        NSInteger order = 1;
        for (NSXMLElement *privacyItem in mutablePrivacyList){
            [privacyItem addAttributeWithName:@"order" integerValue:order++];
        }
        
        [self.xmppPrivacy setListWithName:XMPPPrivacyListName items:mutablePrivacyList];
        [self.xmppPrivacy setDefaultListName:XMPPPrivacyListName];
    }
}
#pragma mark - XMPPPrivacy Delegate
- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListNames:(NSArray *)listNames{
    LCLogInfo(@"%@ %@ ",[[NSThread callStackSymbols] firstObject],listNames);
    
    [self.xmppPrivacy retrieveListWithName:XMPPPrivacyListName];
}
- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListNamesDueToError:(id)error{
    LCLogInfo(@"%@ %@ ",[[NSThread callStackSymbols] firstObject],error);
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListWithName:(NSString *)name items:(NSArray *)items{
    LCLogInfo(@"%@ %@ %@",[[NSThread callStackSymbols] firstObject],name,items);
    
//    if ([LCStringUtil isNotNullString:name] && [name isEqualToString:XMPPPrivacyListName]) {
//        [LCDataManager sharedInstance].xmppPrivacyList = [self.xmppPrivacy listWithName:XMPPPrivacyListName];
//        [[LCDataManager sharedInstance] saveData];
//    }
}
- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListWithName:(NSString *)name error:(id)error{
    LCLogInfo(@"%@ %@ %@",[[NSThread callStackSymbols] firstObject],name,error);
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceivePushWithListName:(NSString *)name{
    LCLogInfo(@"%@ %@ ",[[NSThread callStackSymbols] firstObject],name);
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetActiveListName:(NSString *)name{
    LCLogInfo(@"%@ %@ ",[[NSThread callStackSymbols] firstObject],name);
}
- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetActiveListName:(NSString *)name error:(id)error{
    LCLogInfo(@"%@ %@ %@",[[NSThread callStackSymbols] firstObject],name,error);
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetDefaultListName:(NSString *)name{
    LCLogInfo(@"%@ %@ ",[[NSThread callStackSymbols] firstObject],name);
}
- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetDefaultListName:(NSString *)name error:(id)error{
    LCLogInfo(@"%@ %@ %@",[[NSThread callStackSymbols] firstObject],name,error);
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetListWithName:(NSString *)name{
    LCLogInfo(@"%@ %@ ",[[NSThread callStackSymbols] firstObject],name);
}
- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetListWithName:(NSString *)name error:(id)error{
    LCLogInfo(@"%@ %@ %@",[[NSThread callStackSymbols] firstObject],name,error);
}

@end
