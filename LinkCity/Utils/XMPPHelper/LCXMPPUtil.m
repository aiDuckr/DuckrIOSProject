//
//  LCXMPPUtil.m
//  LinkCity
//
//  Created by 张宗硕 on 11/26/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCXMPPUtil.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "LCDateUtil.h"

@implementation LCXMPPUtil

+ (void)deleteJid:(NSString *)jidStr {
    NSString *accountJIDStr = [LCDataManager sharedInstance].userInfo.openfireAccount;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSString *predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr = %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, jidStr, accountJIDStr];
    request.predicate = predicate;
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *contactArr = [moc executeFetchRequest:request error:&error];
    
    if (!error) {
        for (XMPPMessageArchiving_Contact_CoreDataObject * contact in contactArr) {
            [moc deleteObject:contact];
        }
    }
    if ([moc hasChanges]) {
        [moc save:&error];
    }
}
+ (NSDate *)getGroupChatLastOneMsgDate:(NSString *)receiverJID {
    NSDate *date = [LCDateUtil nDaysBeforeDate:7];
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSString *userOpenfire = [LCDataManager sharedInstance].userInfo.openfireAccount;
    NSString *predicateFrmt = nil;
    NSPredicate *predicate = nil;
    predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@ AND outgoing = 0";
    predicate = [NSPredicate predicateWithFormat:predicateFrmt, receiverJID, userOpenfire];
    
    request.predicate = predicate;
    
    NSSortDescriptor *sortByTime = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByTime]];
    
    [request setEntity:entityDescription];
    [request setFetchLimit:1];
    
    NSError *error;
    NSArray *messageArr = [moc executeFetchRequest:request error:&error];
    [LCXMPPUtil printMessage:messageArr];
    if (messageArr && messageArr.count>0) {
        XMPPMessageArchiving_Message_CoreDataObject *msg = [messageArr firstObject];
        date = msg.timestamp;
    }
    
    return date;
}
+ (BOOL)amINewToGroupChat:(NSString *)receiverJID {
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSString *userOpenfire = [LCDataManager sharedInstance].userInfo.openfireAccount;
    NSString *predicateFrmt = nil;
    NSPredicate *predicate = nil;
    predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@ AND outgoing = 0";
    predicate = [NSPredicate predicateWithFormat:predicateFrmt, receiverJID, userOpenfire];
    
    request.predicate = predicate;
    
    NSSortDescriptor *sortByTime = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByTime]];
    
    [request setEntity:entityDescription];
    [request setFetchLimit:1];
    
    NSError *error;
    NSArray *messageArr = [moc executeFetchRequest:request error:&error];
    [LCXMPPUtil printMessage:messageArr];
    if (messageArr && messageArr.count>0) {
        return NO;
    }else{
        return YES;
    }
}

+ (NSArray *)loadRecentChatMsg:(NSString *)receiverJID isGroup:(BOOL)isGroup fromDate:(NSDate *)date {
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSString *userOpenfire = [LCDataManager sharedInstance].userInfo.openfireAccount;
    NSString *predicateFrmt = nil;
    NSPredicate *predicate = nil;
    
    if (!isGroup) {
        if (date) {
            predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@ AND timestamp < %@";
            predicate = [NSPredicate predicateWithFormat:predicateFrmt, receiverJID, userOpenfire, date];
        }else{
            predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@";
            predicate = [NSPredicate predicateWithFormat:predicateFrmt, receiverJID, userOpenfire];
        }
    }else{
        if (date) {
            predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@ AND timestamp < %@ AND outgoing = 0";
            predicate = [NSPredicate predicateWithFormat:predicateFrmt, receiverJID, userOpenfire, date];
        }else{
            predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@ AND outgoing = 0";
            predicate = [NSPredicate predicateWithFormat:predicateFrmt, receiverJID, userOpenfire];
        }
    }
    
    request.predicate = predicate;
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    [request setEntity:entityDescription];
    [request setFetchLimit:CHAT_MAX_PAGE_LIMIT];
    
    NSError *error;
    NSArray *messageArr = [moc executeFetchRequest:request error:&error];
    NSArray* reversedArray = [[messageArr reverseObjectEnumerator] allObjects];
    [LCXMPPUtil printMessage:messageArr];
    
    return reversedArray;
}

+ (NSArray *)loadRecentChatContact:(ChatContactType)contactType {
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSString *userOpenfire = [LCDataManager sharedInstance].userInfo.openfireAccount;
    NSString *predicateFrmt = @"streamBareJidStr == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, userOpenfire];
    
    if (CHAT_CONTACT_TYPE_ALL == contactType) {
        //do nothing
    }else if(CHAT_CONTACT_TYPE_GROUPCHAT == contactType){
        //Roy  为了兼容3.0以前的聊天，读会话是群聊要读这三种可能
        predicateFrmt = @"streamBareJidStr == %@ and (contactType == %d OR contactType == %d OR contactType == %d)";
        predicate = [NSPredicate predicateWithFormat:predicateFrmt, userOpenfire, CHAT_CONTACT_TYPE_PLAN, CHAT_CONTACT_TYPE_GROUP, CHAT_CONTACT_TYPE_GROUPCHAT];
    }else{
        predicateFrmt = @"streamBareJidStr == %@ and contactType == %d";
        predicate = [NSPredicate predicateWithFormat:predicateFrmt, userOpenfire, CHAT_CONTACT_FAVOR];
    }
    
    request.predicate = predicate;
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"mostRecentMessageTimestamp" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *contactArr = [moc executeFetchRequest:request error:&error];
    [LCXMPPUtil printContact:contactArr];
    if (!error) {
        return contactArr;
    }
    return [[NSArray alloc] init];
}

+ (void)deleteChatMsg:(NSString *)receiverJID{
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    
    NSString *userOpenfire = [LCDataManager sharedInstance].userInfo.openfireAccount;
    NSString *predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, receiverJID, userOpenfire];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.predicate = predicate;
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *messageArr = [moc executeFetchRequest:request error:&error];
    
    if (error) {
        LCLogError(@"delete chat msg error: %@",error);
    }else{
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messageArr) {
            [moc deleteObject:message];
        }
        
        if ([moc hasChanges]) {
            [moc save:&error];
        }
    }
}
+ (void)deleteChatContact:(NSString *)contactJID{
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSString *predicateFrmt = @"bareJidStr == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, contactJID];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = predicate;
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *contactArr = [moc executeFetchRequest:request error:&error];
    [LCXMPPUtil printContact:contactArr];
    if (error) {
        LCLogError(@"delete chat contact error: %@",error);
    }else{
        for (NSManagedObject *contact in contactArr){
            [moc deleteObject:contact];
        }
        
        if ([moc hasChanges]) {
            NSError *error;
            [moc save:&error];
        }
    }
}

+ (void)deleteAllChatMsg{
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *messageArr = [moc executeFetchRequest:request error:&error];
    
    LCChatLogInfo(@"DeleteChatMessages:*****************************");
    [LCXMPPUtil printMessage:messageArr];
    if (error) {
        LCLogError(@"deleteAllChatMsg: %@",error);
    }else{
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messageArr) {
            [moc deleteObject:message];
        }
        
        if (![moc save:&error]) {
            LCLogError(@"deleteAllChatMsg: %@",error);
        }
    }
}
+ (void)deleteAllChatContact{
    NSManagedObjectContext *moc = [self getMocOfXMPPMessageArchivingCoreDataStorage];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *contactArr = [moc executeFetchRequest:request error:&error];
    
    LCChatLogInfo(@"deleteAllChatContact:*****************************");
    [LCXMPPUtil printContact:contactArr];
    if (error) {
        LCLogError(@"delete chat contact error: %@",error);
    }else{
        for (NSManagedObject *contact in contactArr){
            [moc deleteObject:contact];
        }
        
        NSError *error;
        if (![moc save:&error]) {
            LCLogError(@"delete chat contact error: %@",error);
        }
    }
}






+ (void)printContact:(NSArray *)messages_arc {
    @autoreleasepool {
        for (XMPPMessageArchiving_Contact_CoreDataObject *message in messages_arc) {
            LCChatLogInfo(@"**************************************************************************");
            /// 接收者的JID.
            LCChatLogInfo(@"bareJidStr param is %@",message.bareJidStr);
            LCChatLogInfo(@"recent message is %@", message.mostRecentMessageBody);
            LCChatLogInfo(@"most recent outgoing is %@", message.mostRecentMessageOutgoing);
            LCChatLogInfo(@"mostRecentMessageTimestamp is %@", message.mostRecentMessageTimestamp);
            /// 发送者的JID.
            LCChatLogInfo(@"streamBareJidStr param is %@",message.streamBareJidStr);
            LCChatLogInfo(@"the message type is %@", message.contactType);
            LCChatLogInfo(@"**************************************************************************");
        }
    }
}

+ (void)printMessage:(NSArray *)messages_arc {
    @autoreleasepool {
        LCChatLogInfo(@"printMessage........................");
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages_arc) {
            LCChatLogInfo(@"**************************************************************************");
            /// 接收者的JID.
            LCChatLogInfo(@"bareJidStr param is %@", message.bareJid);
            /// 发送者的JID.
            LCChatLogInfo(@"streamBareJidStr param is %@", message.streamBareJidStr);
            LCChatLogInfo(@"info param is %@", message.info);
            LCChatLogInfo(@"body param is %@", message.body);
            XMPPJID *jid = [XMPPJID jidWithString:message.streamBareJidStr];
            LCChatLogInfo(@"the jid telephone is %@", jid.user);
            LCChatLogInfo(@"isOutgoing param %d", message.isOutgoing);
            LCChatLogInfo(@"msg uuid param is %@", message.msgUuid);
            LCChatLogInfo(@"timestamp param %@", message.timestamp);
            LCChatLogInfo(@"local timestamp %@", [LCDateUtil getLocalDateFromGMTDate:message.timestamp]);
            LCChatLogInfo(@"**************************************************************************");
        }
    }
}

//+ (BOOL)saveChatPlanGroup:(LCPlan *)contactGroup {
//    if (nil == contactGroup || [LCStringUtil isNullString:contactGroup.roomID]) {
//        return NO;
//    }
//    BOOL isSaveSuccess = NO;
//    NSArray *arr = [self checkHaveContact:contactGroup.roomID];
//    
//    XMPPMessageArchiving_Contact_CoreDataObject *entityDescription = nil;
//    XMPPJID *contactJID = [XMPPJID jidWithString:contactGroup.roomID];
//    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
//    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
//    
//    if (!arr || 0 == arr.count) {
//        entityDescription = (XMPPMessageArchiving_Contact_CoreDataObject *)[NSEntityDescription insertNewObjectForEntityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:moc];
//        [entityDescription setMostRecentMessageBody:@""];
//    } else {
//        entityDescription = [arr objectAtIndex:0];
//        [LCXMPPUtil printContact:arr];
//    }
//    [entityDescription setBareJidStr:contactGroup.roomID];
//    [entityDescription setBareJid:contactJID];
//    [entityDescription setMostRecentMessageOutgoing:[NSNumber numberWithInt:1]];
//    [entityDescription setMostRecentMessageTimestamp:[NSDate new]];
//    NSString *accountJIDStr = [LCDataManager sharedInstance].userInfo.openfireAccount;
//    [entityDescription setStreamBareJidStr:accountJIDStr];
//    if ([PLAN_TYPE_PARNTER_STR isEqualToString:contactGroup.planType]) {
//        [entityDescription setContactType:[NSString stringWithFormat:@"%d", CHAT_CONTACT_PARTNER]];
//    } else if ([PLAN_TYPE_RECEPTION_STR isEqualToString:contactGroup.planType]) {
//        [entityDescription setContactType:[NSString stringWithFormat:@"%d", CHAT_CONTACT_RECEPTION]];
//    }
//    NSError* error;
//    isSaveSuccess = [moc save:&error];
//    return isSaveSuccess;
//}

+ (BOOL)saveChatContact:(LCUserModel *)contactUser withType:(ChatContactType)contactType {
    NSString *accountJIDStr = [LCDataManager sharedInstance].userInfo.openfireAccount;
    if ([accountJIDStr isEqualToString:contactUser.openfireAccount]) {
        return NO;
    }
    BOOL isSaveSuccess = NO;
    NSArray *arr = [self checkHaveContact:contactUser.openfireAccount];
    
    XMPPJID *contactJID = [XMPPJID jidWithString:contactUser.openfireAccount];
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    XMPPMessageArchiving_Contact_CoreDataObject *entityDescription = nil;
    
    if (nil == arr || 0 == arr.count)
    {
        entityDescription = (XMPPMessageArchiving_Contact_CoreDataObject *)[NSEntityDescription insertNewObjectForEntityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:moc];
        [entityDescription setMostRecentMessageBody:@""];
    }
    else
    {
        entityDescription = [arr objectAtIndex:0];
    }

    [entityDescription setBareJidStr:contactUser.openfireAccount];
    [entityDescription setBareJid:contactJID];
    [entityDescription setMostRecentMessageOutgoing:[NSNumber numberWithInt:1]];
    [entityDescription setMostRecentMessageTimestamp:[NSDate new]];
    [entityDescription setStreamBareJidStr:accountJIDStr];
    [entityDescription setContactType:[NSString stringWithFormat:@"%d", contactType]];
    NSError* error;
    isSaveSuccess = [moc save:&error];
    return isSaveSuccess;
}

+ (NSArray *)checkHaveContact:(NSString *)contactJIDStr {
    NSString *accountJIDStr = [LCDataManager sharedInstance].userInfo.openfireAccount;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSString *predicateFrmt = @"bareJidStr == %@ AND streamBareJidStr == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, contactJIDStr, accountJIDStr];
    request.predicate = predicate;
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *contactArr = [moc executeFetchRequest:request error:&error];
    LCChatLogInfo(@"contact arr count is %tu", contactArr.count);
    return contactArr;
}


//+ (XMPPJID *)getJIDFromUserOrPlan:(id)userOrPlan{
//    if ([userOrPlan isKindOfClass:[LCUserModel class]]) {
//        return [LCXMPPUtil getJIDFromUserInfo:(LCUserModel *)userOrPlan];
//    }else if([userOrPlan isKindOfClass:[LCPlan class]]){
//        return [LCXMPPUtil getJIDFromLCPlan:(LCPlan *)userOrPlan];
//    }else{
//        return nil;
//    }
//}
+ (XMPPJID *)getJIDFromUserInfo:(LCUserModel *)userInfo{
    if (userInfo && [LCStringUtil isNotNullString:userInfo.openfireAccount]) {
        return [XMPPJID jidWithString:userInfo.openfireAccount];
    }else{
        return nil;
    }
}
//+ (XMPPJID *)getJIDFromLCPlan:(LCPlan *)plan{
//    if (plan && [LCStringUtil isNotNullString:plan.roomID]) {
//        return [XMPPJID jidWithString:plan.roomID];
//    }else{
//        return nil;
//    }
//}

+ (NSManagedObjectContext *)getMocOfXMPPMessageArchivingCoreDataStorage{
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
//    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
//    moc.persistentStoreCoordinator = storage.persistentStoreCoordinator;
//    moc.undoManager = nil;
    return moc;
}

+ (NSString *)getMessagteDateStringFromDate:(NSDate *)date{
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    
    [formatter setDateFormat:@"dd"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    NSString *msgDay = [formatter stringFromDate:date];
    if ([today isEqualToString:msgDay]) {
        [formatter setDateFormat:@"HH:mm"];
    }else{
        [formatter setDateFormat:@"MM-dd HH:mm"];
    }
    
    return [formatter stringFromDate:date];
}

@end
