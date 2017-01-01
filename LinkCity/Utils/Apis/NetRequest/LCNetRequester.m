//  并没有使用JSONModel或者YYModel等第三方库。
//  LCNetRequester.m
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNetRequester.h"
#import "LCProvinceModel.h"
#import "LCCityModel.h"

@implementation LCNetRequester

#pragma mark - Public Interface


#pragma mark Register & Login
+ (void)sendAuthCodeToTelephoneForRegister:(NSString *)phone
                                  callBack:(void(^)(LCAuthCode *, NSError *))callBack{
    [LCNetRequester sendAuthCodeToTelephone:phone type:@"Register" callBack:callBack];
}
+ (void)sendAuthCodeToTelephoneForResetPassword:(NSString *)phone
                                       callBack:(void(^)(LCAuthCode *, NSError *))callBack{
    [LCNetRequester sendAuthCodeToTelephone:phone type:@"ResetPass" callBack:callBack];
}
+ (void)sendAuthCodeToTelephone:(NSString *)phone
                           type:(NSString *)type
                       callBack:(void (^)(LCAuthCode *, NSError *))callBack{
    NSDictionary *param = @{@"Telephone":phone,
                            @"Type":type};
    [[self getInstance] doPost:URL_SEND_AUTHCODE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 LCAuthCode *authCode = [[LCAuthCode alloc] initWithDictionary:dataDic];
                 callBack(authCode, error);
             }else{
                 callBack(nil, error);
             }
         }
     }];
}

+ (void)verifyAuthCodeWithTelephone:(NSString *)phone
                           authCode:(NSString *)authCode
                           callBack:(void (^)(NSError *))callBack{
    if ([LCStringUtil isNullString:phone] ||
        [LCStringUtil isNullString:authCode]) {
        
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_VERIFY_AUTHCODE withParams:@{@"Telephone":phone,@"AuthCode":authCode} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

+ (void)registerUserWithTelephone:(NSString *)phone
                         password:(NSString *)password
                         authCode:(NSString *)authCode
                         callBack:(void (^)(LCUserModel *, NSError *))callBack{
    
    if ([LCStringUtil isNullString:phone] || [LCStringUtil isNullString:password] || [LCStringUtil isNullString:authCode]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"Telephone":phone,
                            @"Password":password,
                            @"AuthCode":authCode};
    [[self getInstance] doPost:URL_REGISTER_USER
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                 callBack(user,error);
             }else{
                 callBack(nil,error);
             }
         }
     }];
}
+ (void)updateUserInfoWithNick:(NSString *)nick
                           sex:(NSInteger)sex
                     avatarURL:(NSString *)avatarURL
                livingProvince:(NSString *)livingProvince
                   livingPlace:(NSString *)livingPlace
                      realName:(NSString *)realName
                        school:(NSString *)school
                       company:(NSString *)company
                      birthday:(NSString *)birthday
                     signature:(NSString *)signature
                    profession:(NSString *)professional
                  wantGoPlaces:(NSArray *)wantGoPlaces  //string array
                  haveGoPlaces:(NSArray *)haveGoPlaces  //string array
                      callBack:(void (^)(LCUserModel *, NSError *))callBack{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([LCStringUtil isNotNullString:nick]) {
        [dic setObject:nick forKey:@"Nick"];
    }
    
    [dic setObject:[NSNumber numberWithInteger:sex] forKey:@"Sex"];
    
    if ([LCStringUtil isNotNullString:avatarURL]) {
        [dic setObject:avatarURL forKey:@"AvatarUrl"];
    }
    if ([LCStringUtil isNotNullString:livingProvince]) {
        [dic setObject:livingProvince forKeyedSubscript:@"LivingProvince"];
    }else{
        [dic setObject:@"" forKeyedSubscript:@"LivingProvince"];
    }
    if ([LCStringUtil isNotNullString:livingPlace]) {
        [dic setObject:livingPlace forKey:@"LivingPlace"];
    }else{
        [dic setObject:@"" forKey:@"LivingPlace"];
    }
    if ([LCStringUtil isNotNullString:realName]) {
        [dic setObject:realName forKey:@"RealName"];
    }else{
        [dic setObject:@"" forKey:@"RealName"];
    }
    if ([LCStringUtil isNotNullString:school]) {
        [dic setObject:school forKey:@"School"];
    }else{
        [dic setObject:@"" forKey:@"School"];
    }
    if ([LCStringUtil isNotNullString:company]) {
        [dic setObject:company forKey:@"Company"];
    }else{
        [dic setObject:@"" forKey:@"Company"];
    }
    if ([LCStringUtil isNotNullString:birthday]) {
        [dic setObject:birthday forKey:@"Birthday"];
    }
    if ([LCStringUtil isNotNullString:signature]) {
        [dic setObject:signature forKey:@"Signature"];
    }else{
        [dic setObject:@"" forKey:@"Signature"];
    }
    if ([LCStringUtil isNotNullString:professional]) {
        [dic setObject:professional forKey:@"Professional"];
    }
    if (wantGoPlaces && wantGoPlaces.count>0) {
        NSString *wantGoStr = [LCStringUtil getJsonStrFromArray:wantGoPlaces];
        if ([LCStringUtil isNotNullString:wantGoStr]) {
            [dic setObject:wantGoStr forKey:@"WantGoPlaces"];
        }else{
            [dic setObject:@"" forKey:@"WantGoPlaces"];
        }
    }else{
        [dic setObject:@"" forKey:@"WantGoPlaces"];
    }
    if (haveGoPlaces && haveGoPlaces.count>0) {
        NSString *haveGoStr = [LCStringUtil getJsonStrFromArray:haveGoPlaces];
        if ([LCStringUtil isNotNullString:haveGoStr]) {
            [dic setObject:haveGoStr forKey:@"HaveGoPlaces"];
        }else{
            [dic setObject:@"" forKey:@"HaveGoPlaces"];
        }
    }else{
        [dic setObject:@"" forKey:@"HaveGoPlaces"];
    }
    if ([LCStringUtil isNotNullString:school]) {
        [dic setObject:school forKey:@"School"];
    }
    
    [[self getInstance] doPost:URL_UPDATE_USER withParams:dic requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                callBack(user,error);
            }else{
                callBack(nil,error);
            }
        }
    }];
}

+ (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
              callBack:(void (^)(LCUserModel *, NSError *))callBack{
    if ([LCStringUtil isNullString:phone] || [LCStringUtil isNullString:password]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"Telephone":phone,
                            @"Password":password};
    
    [[self getInstance] doPost:URL_LOGIN
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSDictionary *userDic = [dataDic dicOfObjectForKey:@"User"];
                 LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                 callBack(user,error);
             }else{
                 callBack(nil,error);
             }
         }
     }];
}

+ (void)resetPasswordWithTelephone:(NSString *)phone
                          password:(NSString *)password
                          authCode:(NSString *)authCode
                          callBack:(void (^)(LCUserModel *, NSError *))callBack{
    
    if ([LCStringUtil isNullString:phone] || [LCStringUtil isNullString:password] || [LCStringUtil isNullString:authCode]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"Telephone":phone,
                            @"Password":password,
                            @"AuthCode":authCode};
    [[self getInstance] doPost:URL_RESET_PASSWORD
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                 callBack(user,error);
             }else{
                 callBack(nil,error);
             }
         }
     }];
}

#pragma mark Route
+ (void)sendRoute:(LCUserRouteModel *)userRoute type:(NSInteger)type callBack:(void (^)(LCUserModel *, LCUserRouteModel *, NSError *))callBack{
    NSMutableDictionary *userRouteDic = [userRoute getDicForNetRequest];
    [userRouteDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"Type"];
    
    [[self getInstance] doPost:URL_SEND_ROUTE withParams:userRouteDic requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                LCUserRouteModel *userRoute = [[LCUserRouteModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"UserRoute"]];
                callBack(user,userRoute,error);
            }else{
                callBack(nil,nil,error);
            }
        }
    }];
}
+ (void)deleteRoute:(NSInteger)userRouteID callBack:(void (^)(NSError *))callBack{
    NSDictionary *param = @{@"UserRouteId":[NSString stringWithFormat:@"%ld",(long)userRouteID]};
    
    [[self getInstance] doPost:URL_DELETE_ROUTE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}
+ (void)getRelevantPlanOfRoute:(NSInteger)userRouteID callBack:(void (^)(NSArray *, NSError *))callBack{
    NSDictionary *param = @{@"UserRouteId":[LCStringUtil integerToString:userRouteID]};
    [[self getInstance] doPost:URL_GET_RELAVANT_PLAN_OF_ROUTE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
                NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                for (NSDictionary *planDic in planDicArray){
                    LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (aPlan) {
                        [planArray addObject:aPlan];
                    }
                }
                
                callBack(planArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

#pragma mark Chat
+ (void)getNearbyChatGroupListByLocation:(LCUserLocation *)location callBack:(void (^)(NSArray *, NSError *))callBack{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Long"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    [[self getInstance] doPost:URL_GET_NEARBY_CHATGROUP withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *chatGroupArray = [[NSMutableArray alloc] init];
                for (NSDictionary *chatGroupDic in [dataDic arrayForKey:@"GroupList"]){
                    LCChatGroupModel *chatGroup = [[LCChatGroupModel alloc] initWithDictionary:chatGroupDic];
                    if (chatGroup) {
                        [chatGroupArray addObject:chatGroup];
                    }
                }
                callBack(chatGroupArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getMyChatGroupListWithCallBack:(void (^)(NSArray *, NSError *))callBack{
    [[self getInstance] doPost:URL_GET_MY_CHATGROUP withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *chatGroupArray = [[NSMutableArray alloc] init];
                for (NSDictionary *chatGroupDic in [dataDic arrayForKey:@"GroupList"]){
                    LCChatGroupModel *chatGroup = [[LCChatGroupModel alloc] initWithDictionary:chatGroupDic];
                    if (chatGroup) {
                        [chatGroupArray addObject:chatGroup];
                    }
                }
                callBack(chatGroupArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getChatGroupListByPlaceName:(NSString *)placeName callBack:(void (^)(NSArray *, NSError *))callBack{
    if ([LCStringUtil isNullString:placeName]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        
        return;
    }
    
    [[self getInstance] doPost:URL_GET_CHATGROUPLIST_BY_PLACENAME withParams:@{@"DestName":placeName} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *chatGroupArray = [[NSMutableArray alloc] init];
                for (NSDictionary *chatGroupDic in [dataDic arrayForKey:@"ChatGroups"]){
                    LCChatGroupModel *chatGroup = [[LCChatGroupModel alloc] initWithDictionary:chatGroupDic];
                    if (chatGroup) {
                        [chatGroupArray addObject:chatGroup];
                    }
                }
                callBack(chatGroupArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getChatGroupInfoForGroupGuid:(NSString *)guid callBack:(void (^)(LCChatGroupModel *, NSError *))callBack{
    if ([LCStringUtil isNullString:guid]){
        if (callBack){
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_GET_CHATGROUP_INFO withParams:@{@"Guid":guid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCChatGroupModel *chatGroup = [[LCChatGroupModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"ChatGroup"]];
                callBack(chatGroup, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)joinChatGroupWithChatGroupGuid:(NSString *)guid location:(LCUserLocation *)location callBack:(void (^)(LCChatGroupModel *, NSError *))callBack{
    if ([LCStringUtil isNullString:guid]){
        if (callBack){
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:guid forKey:@"Guid"];
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Longitude"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Latitude"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    [[self getInstance] doPost:URL_JOINE_CHATGROUP withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCChatGroupModel *chatGroup = [[LCChatGroupModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"ChatGroup"]];
                callBack(chatGroup, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)quitChatGroupWithChatGroupGuid:(NSString *)guid callBack:(void (^)(NSError *))callBack{
    if ([LCStringUtil isNullString:guid]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_QUIT_CHATGROUP withParams:@{@"Guid":guid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}


+ (void)getFavoredUserOfUserUuid:(NSString *)userUuid callBack:(void (^)(NSArray *, NSError *))callBack{
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:userUuid]) {
        param = @{@"UserUuid":userUuid};
    }
    
    [[self getInstance] doPost:URL_GET_FAVED_USER_IN_CHAT_CONTACT withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]){
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                callBack(userArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getChatContactInfoWith:(NSArray *)jidStringArray callBack:(void (^)(NSArray *, NSError *))callBack{
    NSString *jidString = [LCStringUtil getJsonStrFromArray:jidStringArray];
    
    if ([LCStringUtil isNullString:jidString]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_GET_CHAT_CONTACT_INFO withParams:@{@"JIDList":jidString} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *chatContactArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *chatContactDic in [dataDic arrayForKey:@"ContactList"]) {
                    LCChatContactModel *chatContact = [[LCChatContactModel alloc] initWithDictionary:chatContactDic];
                    if (chatContact) {
                        chatContact.lastUpdateContactInfoFromServerTime = [NSDate date];
                        [chatContactArray addObject:chatContact];
                    }
                }
                callBack (chatContactArray, error);
            }else{
                callBack (nil, error);
            }
        }
    }];
}

+ (void)getJoinedChatRoomJIDListWithCallback:(void(^)(NSArray *roomJidList, NSInteger maxAutoOnlineCount, NSError *error))callBack{
    [[self getInstance] doPost:URL_GET_JOINED_CHATROOM_LIST withParams:@{} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSArray *roomJidList = [dataDic arrayForKey:@"JidList"];
                NSInteger maxAutoOnlineCount = [LCStringUtil idToNSInteger:[dataDic objectForKey:@"MaxAutoOnlineCount"]];
                callBack(roomJidList, maxAutoOnlineCount, error);
            }else{
                callBack(nil, -1, error);
            }
        }
    }];
}

+ (void)getRecommendedUserListWithCallBack:(void (^)(NSArray *, NSError *))callBack{
    [[self getInstance] doPost:URL_GET_RECOMMEND_USER_LIST withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]){
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                callBack(userArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getInviteUserListInAddressBookWithCallBack:(void (^)(NSArray *, NSArray *, NSError *))callBack{
    [[self getInstance] doPost:URL_GET_INVITE_USER_LIST_IN_ADDRESSBOOK withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *registeredUserArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]){
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [registeredUserArray addObject:user];
                    }
                }
                
                NSMutableArray *invitedPhoneContactArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *phoneContactDic in [dataDic arrayForKey:@"InvitedUserList"]){
                    LCPhoneContactorModel *phoneContact = [[LCPhoneContactorModel alloc] initWithDictionary:phoneContactDic];
                    if (phoneContact) {
                        [invitedPhoneContactArray addObject:phoneContact];
                    }
                }
                
                callBack(registeredUserArray, invitedPhoneContactArray, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)inviteUserInAddressBookWithTelephone:(NSString *)telephone callBack:(void (^)(NSError *))callBack{
    if ([LCStringUtil isNullString:telephone]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_INVITE_USER_IN_ADDRESSBOOK withParams:@{@"InviteTel":telephone} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

+ (void)getUserInfoByTelephone:(NSString *)telephone planOrGroupGuid:(NSString *)guid callBack:(void (^)(LCUserModel *, NSError *))callBack{
    if ([LCStringUtil isNullString:telephone] || [LCStringUtil isNullString:guid]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_GET_USERINFO_BY_TELEPHONE withParams:@{@"Telephone":telephone, @"Guid":guid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"UserInfo"]];
                callBack(user, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)setPlanAlert:(NSInteger)isAlert planGuid:(NSString *)planGuid callBack:(void (^)(NSInteger, NSError *))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack(-1, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_SET_PLAN_ALERT withParams:@{@"Guid":planGuid, @"IsAlert":[LCStringUtil integerToString:isAlert]}
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSInteger isAlert = [LCStringUtil idToNSInteger:[dataDic objectForKey:@"IsAlert"]];
                 callBack(isAlert, error);
             }else{
                 callBack(-1, error);
             }
         }
     }];
}
+ (void)setChatGroupAlert:(NSInteger)isAlert groupGuid:(NSString *)groupGuid callBack:(void (^)(NSInteger, NSError *))callBack{
    if ([LCStringUtil isNullString:groupGuid]) {
        if (callBack) {
            callBack(-1, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_SET_CHATGROUP_ALERT withParams:@{@"Guid":groupGuid, @"IsAlert":[LCStringUtil integerToString:isAlert]}
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSInteger isAlert = [LCStringUtil idToNSInteger:[dataDic objectForKey:@"IsAlert"]];
                 callBack(isAlert, error);
             }else{
                 callBack(-1, error);
             }
         }
     }];
}

#pragma mark SearchResult
+ (void)searchMixPlanForDestionation:(NSString *)placeName
                           orderType:(LCPlanOrderType)orderType
                             themeId:(NSInteger)themeId
                         orderString:(NSString *)orderString
                            isDepart:(BOOL)isDepart    // 为1则根据出发地进行搜索,否则根据目的地
                            callBack:(void(^)(NSArray *typeList,
                                              NSArray *planList,
                                              LCDestinationPlaceModel *place,
                                              NSString *orderString,
                                              NSError *error))callBack
{
    
    if ([LCStringUtil isNullString:placeName]) {
        if (callBack) {
            callBack(nil, nil, nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:placeName forKey:@"DestName"];
    
    if ([LCStringUtil isNotNullString:orderString]) {
        [param setObject:orderString forKey:@"OrderStr"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)orderType] forKey:@"FilterType"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)themeId] forKey:@"ThemeId"];
    
    if (isDepart) {
        [param setObject:@"1" forKey:@"IsDepart"];
    }else{
        [param setObject:@"0" forKey:@"IsDepart"];
    }
    
    [[self getInstance] doPost:URL_SEARCH_MIX_PLAN_FOR_DESTINATION
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSArray *typeArray = [dataDic arrayForKey:@"MixedList"];
                 
                 NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                 NSMutableArray *planArray = [[NSMutableArray alloc] init];
                 
                 if (typeArray.count != planDicArray.count) {
                     LCLogError(@"searchMixPlanForDestionation error, data doesn't match");
                     
                 }else{
                     for (int i=0; i<typeArray.count; i++){
                         if ([typeArray[i] integerValue] == 0) {
                             LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                             if (plan) {
                                 [planArray addObject:plan];
                             }
                         }else if([typeArray[i] integerValue] == 1) {
                             LCWebPlanModel *webPlan = [[LCWebPlanModel alloc] initWithDictionary:planDicArray[i]];
                             if (webPlan) {
                                 [planArray addObject:webPlan];
                             }
                         }
                     }
                 }
                 
                 LCDestinationPlaceModel *place = [[LCDestinationPlaceModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"Place"]];
                 NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                 
                 callBack(typeArray, planArray, place, orderStr, error);
             }else{
                 callBack(nil, nil, nil, nil, error);
             }
         }
     }];
}
+ (void)searchHereForDestination:(NSString *)placeName callBack:(void(^)(NSArray *tourPicList, NSArray *duckrList, NSError *error))callBack{
    
    if ([LCStringUtil isNullString:placeName]) {
        if (callBack) {
            callBack(nil,nil,[NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_SEARCH_HERE_FOR_DESTINATION withParams:@{@"PlaceName":placeName} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *tourPicArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"TourPicList"]) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (tourpic) {
                        [tourPicArray addObject:tourpic];
                    }
                }
                
                NSMutableArray *duckrArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"DuckrList"]){
                    LCUserModel *aUser = [[LCUserModel alloc] initWithDictionary:dic];
                    if (aUser) {
                        [duckrArray addObject:aUser];
                    }
                }
                
                callBack(tourPicArray, duckrArray, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

/// 根据主题搜索计划
+ (void)searchMixPlanForTheme:(NSInteger)themeId
                      locName:(NSString *)locName
                  orderString:(NSString *)orderString
                     callBack:(void(^)(NSArray *planList,
                                       LCRouteThemeModel *theme,
                                       NSString *orderString,
                                       NSError *error))callBack
{
    orderString = [LCStringUtil getNotNullStr:orderString];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld", (long)themeId] forKey:@"ThemeId"];
    [param setObject:orderString forKey:@"OrderStr"];
    
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [[self getInstance] doPost:URL_SEARCH_MIX_PLAN_FOR_THEME
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
                   if (callBack) {
                       if (dataDic) {
                           NSArray *typeArray = [dataDic arrayForKey:@"MixedList"];
                           NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                           NSMutableArray *planArray = [[NSMutableArray alloc] init];
                           
                           if (typeArray.count != planDicArray.count) {
                               LCLogError(@"searchMixPlanForDestionation error, data doesn't match");
                               NSError *error = [NSError errorWithDomain:NETWORK_ERROR_MESSAGE code:NETWORK_ERROR_CODE userInfo:nil];
                               callBack(nil, nil, nil, error);
                           } else {
                               for (int i = 0; i < typeArray.count; i++) {
                                   if (0 == [typeArray[i] integerValue]) {
                                       LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                                       if (nil != plan) {
                                           [planArray addObject:plan];
                                       }
                                   } else if(1 == [typeArray[i] integerValue]) {
                                       LCWebPlanModel *webPlan = [[LCWebPlanModel alloc] initWithDictionary:planDicArray[i]];
                                       if (nil != webPlan) {
                                           [planArray addObject:webPlan];
                                       }
                                   }
                               }
                           }
                           
                           LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:[dataDic objectForKey:@"TourTheme"]];
                           NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                           
                           callBack(planArray, theme, orderStr, error);
                       } else {
                           callBack(nil, nil, nil, error);
                       }
                   }
               }];
}


#pragma mark Setting
+ (void)setInvitedUserTelephone:(NSString *)telephone callBack:(void(^)(NSError *error))callBack{
    if ([LCStringUtil isNullString:telephone]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_SET_INVITEUSER_TELEPHONE withParams:@{@"Telephone":telephone} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}
+ (void)getSystemUserInfoWithCallback:(void (^)(LCUserModel *, NSError *))callBack{
    [[self getInstance] doGet:URL_GET_SYSTEM_USERINFO withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *systemUser = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                callBack(systemUser, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}
+ (void)setNotify:(LCUserNotifyModel *)notifyModel callBack:(void (^)(LCUserNotifyModel *, NSError *))callBack{
    if (!notifyModel) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = [notifyModel getNetRequestDic];
    [[self getInstance] doPost:URL_SET_NOTIFY withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserNotifyModel *userNotify = [[LCUserNotifyModel alloc] initWithDictionary:dataDic];
                callBack(userNotify,error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}
+ (void)getUserNotificationListWithOrderStr:(NSString *)orderStr callBack:(void (^)(NSArray *, NSString *, LCRedDotModel *,NSError *))callBack{
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:orderStr]) {
        param = @{@"OrderStr":orderStr};
    }
    
    [[self getInstance] doPost:URL_GET_USER_NOTIFICATION_LIST withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *notificationArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *notificationDic in [dataDic arrayForKey:@"UserNotification"]){
                    LCUserNotificationModel *aNotification = [[LCUserNotificationModel alloc] initWithDictionary:notificationDic];
                    if (aNotification) {
                        [notificationArray addObject:aNotification];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                
                LCRedDotModel *redDot = [[LCRedDotModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"RedDot"]];
                callBack(notificationArray, orderStr, redDot,error);
            }else{
                callBack(nil, nil, nil, error);
            }
        }
    }];
}


#pragma mark Common
+ (void)updateRemoteNotificationDeviceToken:(NSString *)deviceToken
                                   callBack:(void (^)(NSError *))callBack{
    [[self getInstance] doPost:URL_UPDATE_REMOTENOTIFICATION_DEVICETOKEN withParams:@{@"DeviceToken":deviceToken} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             callBack(error);
         }
     }];
}
+ (void)updateLocationWithLat:(double)lat lon:(double)lon provinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName callBack:(void (^)(LCUserLocation *location, NSError *error))callBack{
    
    NSDictionary *requestParam = @{@"Long":[NSString stringWithFormat:@"%f",lon],
                                   @"Lat":[NSString stringWithFormat:@"%f",lat],
                                   @"ProvinceName":[LCStringUtil getNotNullStr:provinceName],
                                   @"CityName":[LCStringUtil getNotNullStr:cityName],
                                   @"AreaName":[LCStringUtil getNotNullStr:areaName]};
    
    [[self getInstance] doPost:URL_UPDATE_USER_LOCATION
                    withParams:requestParam
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 LCUserLocation *ul = [[LCUserLocation alloc]initWithDictionary:dataDic];
                 callBack(ul,error);
             }else{
                 callBack(nil,error);
             }
         }
     }];
}

+ (void)getQiniuUploadTokenOfImageType:(NSString *)imageType
                              callBack:(void (^)(NSString *, NSString *, NSError *))callBack{
    
    [[self getInstance] doPost:URL_GET_QINIU_UPLOAD_TOKEN
                    withParams:@{@"Type":imageType}
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic && !error) {
                 NSString *uploadToken = [dataDic objectForKey:@"UpToken"];
                 NSString *picKey = [dataDic objectForKey:@"PicKey"];
                 callBack(uploadToken,picKey,error);
                 NSLog(@"upToken:%@ picKey:%@",uploadToken,picKey);
             }else{
                 callBack(nil,nil,error);
             }
         }
     }];
}

/// 获取应用初始化数据.
+ (void)getInitConfigWithCallBack:(void(^)(LCInitData *initData, NSError *error))callBack{
    [[self getInstance] doPost:URL_GET_INIT_CONFIG withParams:@{} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic && !error) {
                LCInitData *initData = [[LCInitData alloc] initWithDictionary:dataDic];
                callBack(initData, error);
            } else {
                callBack(nil,error);
            }
        }
    }];
}

/// 应用启动设置初始化数据.
+ (void)setAppConfigWithCallBack:(void(^)(NSError *error))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    LCUserLocation *location = [LCDataManager sharedInstance].userLocation;
    
    if (location && location.type != LocationTypeError) {
        [param setObject:[NSString stringWithFormat:@"%f", location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f", location.lat] forKey:@"Lat"];
    }
//    [param setObject:@"113.23" forKey:@"Lng"];
//    [param setObject:@"23.16" forKey:@"Lat"];
//    [param setObject:@"116.41667" forKey:@"Lng"];
//    [param setObject:@"39.91667" forKey:@"Lat"];
    
    NSString *clientID = [LCGeXinHelper sharedInstance].clientId;
    if ([LCStringUtil isNotNullString:clientID]) {
        [param setObject:clientID forKey:@"ClientId"];
    }
    
    NSString *idfa = [LCSharedFuncUtil getIdfa];
    if ([LCStringUtil isNotNullString:idfa]) {
        [param setObject:idfa forKey:@"IDFA"];
    }
    
    NSString *imei = [LCSharedFuncUtil getIMEI];
    if ([LCStringUtil isNotNullString:imei]) {
        [param setObject:imei forKey:@"IMEI"];
    }
    
    NSString *macAddress = [LCSharedFuncUtil getMacAddress];
    if ([LCStringUtil isNotNullString:macAddress]) {
        [param setObject:macAddress forKey:@"MacAddress"];
    }
    
    NSString *screenResolution = [LCSharedFuncUtil getScreenResolution];
    if ([LCStringUtil isNotNullString:screenResolution]) {
        [param setObject:screenResolution forKey:@"ScreenResolution"];
    }
    
    NSString *cpuType = [LCSharedFuncUtil getCPUType];
    if ([LCStringUtil isNotNullString:cpuType]) {
        [param setObject:cpuType forKey:@"CPUType"];
    }
    
    NSString *deviceName = [LCSharedFuncUtil getDeviceName];
    if ([LCStringUtil isNotNullString:deviceName]) {
        [param setObject:deviceName forKey:@"DeviceName"];
    }
    
    NSString *deviceModel = [LCSharedFuncUtil getDeviceModel];
    if ([LCStringUtil isNotNullString:deviceModel]) {
        [param setObject:deviceModel forKey:@"DeviceModel"];
    }
    
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [[self getInstance] doPost:URL_SET_APP_CONFIG
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
         if (callBack) {
             if (!error) {
                 LCCityModel *city = [[LCCityModel alloc] initWithDictionary:[dataDic objectForKey:@"CityInfo"]];
                 [LCDataManager sharedInstance].locationCity = city;
                 
                 LCCityModel *currentCity = [LCDataManager sharedInstance].currentCity;
                 if (nil != city) {
                     if (nil == currentCity) {
                         [LCDataManager sharedInstance].isAlertLocationCity = NO;
                     } else {
                         if (NO == [currentCity.cityName isEqualToString:city.cityName]) {
                             [LCDataManager sharedInstance].isAlertLocationCity = NO;
                         }
                     }
                 }
             }
             callBack(error);
         }
     }];
}

+ (void)getRouteThemesWithCallBack:(void (^)(NSArray *, NSError *))callBack {
    [[self getInstance] doGet:URL_GET_ROUTE_THEME
                   withParams:nil
              requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic && !error) {
                 NSMutableArray *routeThemes = [[NSMutableArray alloc] initWithCapacity:0];
                 NSArray *routeThemeArr = [dataDic arrayForKey:@"TourThemes"];
                 for (NSDictionary *themeDic in routeThemeArr){
                     LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
                     if (theme) {
                         [routeThemes addObject:theme];
                     }
                 }
                 callBack(routeThemes, error);
             }else{
                 callBack(nil, error);
             }
         }
     }];
}

+ (void)searchRelatedPlaceFor:(NSString *)placeName callBack:(void (^)(NSArray *, NSError *))callBack{
    if ([LCStringUtil isNullString:placeName]) {
        if (callBack) {
            callBack(nil,[NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doGet:URL_SEARCH_RELATED_PLACE withParams:@{@"palceName":placeName} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *placeArray = [[NSMutableArray alloc] init];
                for (NSDictionary *placeDic in [dataDic arrayForKey:@"PlaceList"]){
                    if ([placeDic isKindOfClass:[NSDictionary class]]) {
                        LCRoutePlaceModel *aPlace = [[LCRoutePlaceModel alloc] initWithDictionary:placeDic];
                        if (aPlace) {
                            [placeArray addObject:aPlace];
                        }
                    }
                }
                callBack(placeArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)uploadAddressBookWithDic:(NSDictionary *)addressBookDic callBack:(void (^)(NSError *))callBack{
    [[self getInstance] doPost:URL_UPLOAD_ADDRESSBOOK withParams:addressBookDic requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

+ (void)getRedDotNumWithCallBack:(void (^)(LCRedDotModel *, NSError *))callBack{
    [[self getInstance] doPost:URL_GET_REDDOT_NUM withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCRedDotModel *redDot = [[LCRedDotModel alloc] initWithDictionary:[dataDic objectForKey:@"RedDot"]];
                //[LCDataManager sharedInstance].redDot = redDot;
                callBack(redDot, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)didBlockUMengWithCallBack:(void (^)(NSError *))callBack{
    [[self getInstance] doPost:URL_BLOCK_UMENG withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}


#pragma mark Home//before V3.1
+ (void)getHomePageContentWithLocation:(LCUserLocation *)location
                              callBack:(void(^)(NSArray *topList,            //array of LCHomeCategoryModel
                                                NSArray *nearbyPlanList,     //array of LCPlanModel
                                                NSArray *domesticList,       //array of LCHomeCategoryModel
                                                NSArray *foreignList,        //array of LCHomeCategoryModel
                                                NSArray *themeList,          //array of LCHomeCategoryModel
                                                LCPlanModel *myselfPlan,
                                                NSError *error))callBack;{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location && location.type != LocationTypeError) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Long"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    [[self getInstance] doPost:URL_GET_HOMEPAGE_CONTENT withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *topList = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"TopList"]){
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        LCHomeCategoryModel *categoryModel = [[LCHomeCategoryModel alloc] initWithDictionary:dic];
                        if (categoryModel) {
                            [topList addObject:categoryModel];
                        }
                    }
                }
                
                NSMutableArray *nearbyPlanList = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"NearbyPlanList"]){
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        LCPlanModel *planModel = [[LCPlanModel alloc] initWithDictionary:dic];
                        if (planModel) {
                            [nearbyPlanList addObject:planModel];
                        }
                    }
                }
                
                NSMutableArray *domesticList = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"DomesticList"]){
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        LCHomeCategoryModel *categoryModel = [[LCHomeCategoryModel alloc] initWithDictionary:dic];
                        if (categoryModel) {
                            [domesticList addObject:categoryModel];
                        }
                    }
                }
                
                NSMutableArray *foreignList = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"ForeignList"]){
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        LCHomeCategoryModel *categoryModel = [[LCHomeCategoryModel alloc] initWithDictionary:dic];
                        if (categoryModel) {
                            [foreignList addObject:categoryModel];
                        }
                    }
                }
                
                NSMutableArray *themeList = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"ThemeList"]){
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        LCHomeCategoryModel *categoryModel = [[LCHomeCategoryModel alloc] initWithDictionary:dic];
                        if (categoryModel) {
                            [themeList addObject:categoryModel];
                        }
                    }
                }
                
                LCPlanModel *myselfPlan = nil;
                NSDictionary *myselfPlanDic = [dataDic dicOfObjectForKey:@"MyselfPlan"];
                if (myselfPlanDic && [myselfPlanDic isKindOfClass:[NSDictionary class]]) {
                    myselfPlan = [[LCPlanModel alloc] initWithDictionary:myselfPlanDic];
                }
                
                callBack(topList, nearbyPlanList, domesticList, foreignList, themeList, myselfPlan, error);
            }else{
                callBack(nil, nil, nil, nil, nil, nil, error);
            }
        }
    }];
}

+ (void)getHomePageContentWithLocation:(LCUserLocation *)location
                              province:(NSString *)province
                                  city:(NSString *)city
                          locationName:(NSString *)locName
                              callBack:(void (^)(NSString *, NSInteger, NSArray *, NSArray *, NSArray *, NSInteger, NSArray *, NSArray *, NSError *))callBack{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location && location.type != LocationTypeError) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    if ([LCStringUtil isNotNullString:province]) {
        [param setObject:province forKey:@"Province"];
    }
    
    if ([LCStringUtil isNotNullString:city]) {
        [param setObject:city forKey:@"City"];
    }
    
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [[self getInstance] doPost:URL_GET_HOMEPAGE_CONTENT_V3_1 withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSString *locName = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"LocName"]];
                
                
                //parse recmd plans
                NSInteger recmdPlanNum = [LCStringUtil idToNSInteger:[dataDic objectForKey:@"RecmdPlanNum"]];
                
                NSArray *typeArray = [dataDic arrayForKey:@"MixedList"];
                NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                
                if (typeArray.count != planDicArray.count) {
                    LCLogError(@"searchMixPlanForDestionation error, data doesn't match");
                }else{
                    for (int i=0; i<typeArray.count; i++){
                        if ([typeArray[i] integerValue] == 0) {
                            LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (plan) {
                                [planArray addObject:plan];
                            }
                        }else if([typeArray[i] integerValue] == 1) {
                            LCWebPlanModel *webPlan = [[LCWebPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (webPlan) {
                                [planArray addObject:webPlan];
                            }
                        }
                    }
                }
                
                //parse favored user plan array
                NSMutableArray *favorPlanArray = [[NSMutableArray alloc] init];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"FavorList"]){
                    LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (aPlan) {
                        [favorPlanArray addObject:aPlan];
                    }
                }
                
                
                //parse place array
                NSMutableArray *placeArray = [[NSMutableArray alloc] init];
                for (NSDictionary *placeDic in [dataDic arrayForKey:@"PlaceList"]){
                    LCDestinationPlaceModel *place = [[LCDestinationPlaceModel alloc] initWithDictionary:placeDic];
                    if (place) {
                        [placeArray addObject:place];
                    }
                }
                
                //parse recmd users
                NSInteger recmdUserNum = [LCStringUtil idToNSInteger:[dataDic objectForKey:@"RecmdDuckrNum"]];
                
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"DuckrList"]){
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                
                //parse prmt
                NSMutableArray *prmtArray = [[NSMutableArray alloc] init];
                for (NSDictionary *prmtDic in [dataDic arrayForKey:@"PrmtList"]){
                    LCHomeCategoryModel *categoryModel = [[LCHomeCategoryModel alloc] initWithDictionary:prmtDic];
                    if (categoryModel) {
                        [prmtArray addObject:categoryModel];
                    }
                }
                
                
                callBack(locName, recmdPlanNum, planArray, favorPlanArray, placeArray, recmdUserNum, userArray, prmtArray, error);
            }else{
                callBack(nil, 0, nil, nil, nil, 0, nil, nil, error);
            }
        }
    }];
}

+ (void)getHomePageRecmdPlanByLocation:(LCUserLocation *)location
                               locName:(NSString *)locName
                            filterType:(LCPlanOrderType)filterType
                           orderString:(NSString *)orderStr
                              callBack:(void (^)(NSArray *, NSString *, NSError *))callBack
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location && location.type != LocationTypeError) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)filterType] forKey:@"FilterType"];
    
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_HOMEPAGE_RECMD_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSArray *typeArray = [dataDic arrayForKey:@"MixedList"];
                NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                
                if (typeArray.count != planDicArray.count) {
                    LCLogError(@"searchMixPlanForDestionation error, data doesn't match");
                }else{
                    for (int i=0; i<typeArray.count; i++){
                        if ([typeArray[i] integerValue] == 0) {
                            LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (plan) {
                                [planArray addObject:plan];
                            }
                        }else if([typeArray[i] integerValue] == 1) {
                            LCWebPlanModel *webPlan = [[LCWebPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (webPlan) {
                                [planArray addObject:webPlan];
                            }
                        }
                    }
                }
                
                NSString *orderStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"OrderStr"]];
                
                callBack(planArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}
+ (void)getHomePageRecmdUserByLocation:(LCUserLocation *)location
                               locName:(NSString *)locName
                            filterType:(LCUserFilterType)filterType
                           orderString:(NSString *)orderStr
                              callBack:(void (^)(NSArray *, NSString *, NSError *))callBack
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location && location.type != LocationTypeError) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)filterType] forKey:@"FilterType"];
    
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_HOMEPAGE_RECMD_USER withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"DuckrList"]){
                    LCUserModel *aUser = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (aUser) {
                        [userArray addObject:aUser];
                    }
                }
                
                NSString *orderStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"OrderStr"]];
                
                callBack(userArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getHomePageFavorPlanByOrderString:(NSString *)orderStr callBack:(void (^)(NSArray *, NSString *, NSError *))callBack{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_HOMEPAGE_FAVOR_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        
        if (callBack) {
            if (dataDic) {
                
                //parse favored user plan array
                NSMutableArray *favorPlanArray = [[NSMutableArray alloc] init];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"PlanList"]){
                    LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (aPlan) {
                        [favorPlanArray addObject:aPlan];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(favorPlanArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
        
    }];
}


//+ (void)getHomePageContent_V_Four_WithLocation:(LCUserLocation *)location
//                                      province:(NSString *)province
//                                          city:(NSString *)city
//                                  locationName:(NSString *)locName
//                                   tourThemeId:(NSInteger)tourThemeId
//                                     orderType:(LCPlanOrderType)orderType
//                                      orderStr:(NSString *)orderStr
//                                      callBack:(void(^)(NSString *locName,
//                                                        NSArray *homeCellArray,
//                                                        NSInteger tourThemeId,
//                                                        LCPlanOrderType orderType,
//                                                        NSString *orderStr,
//                                                        NSString *requestOrderStr,
//                                                        NSError *error))callBack
//{
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    if (location && location.type != LocationTypeError) {
//        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
//        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
//        NSInteger type = (NSInteger)location.type;
//        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
//    }
//    
//    if ([LCStringUtil isNotNullString:province]) {
//        [param setObject:province forKey:@"Province"];
//    }
//    
//    if ([LCStringUtil isNotNullString:city]) {
//        [param setObject:city forKey:@"City"];
//    }
//    
//    if ([LCStringUtil isNotNullString:locName]) {
//        [param setObject:locName forKey:@"LocName"];
//    }
//    
//    [param setObject:[NSNumber numberWithInteger:tourThemeId] forKey:@"TourThemeId"];
//    [param setObject:[NSNumber numberWithInteger:orderType] forKey:@"FilterType"];
//    
//    if ([LCStringUtil isNotNullString:orderStr]) {
//        [param setObject:orderStr forKey:@"OrderStr"];
//    }
//    
//    [[self getInstance] doPost:URL_GET_HOMEPAGE_CONTENT_V4 withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
//        if (callBack) {
//            if (dataDic) {
//                NSString *locName = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"LocName"]];
//                
//                NSMutableArray *homeCellArray = [[NSMutableArray alloc] initWithCapacity:0];
//                for(NSDictionary *homeCellDic in [dataDic arrayForKey:@"HomeViewList"]){
//                    LCHomeCellModel *aHomeCell = [[LCHomeCellModel alloc] initWithDictionary:homeCellDic];
//                    if (aHomeCell) {
//                        if ([aHomeCell getCellType] == LCHomeCellType_Banner) {
//                            [homeCellArray addObject:aHomeCell];
//                        }else if([aHomeCell getCellType] == LCHomeCellType_Plan){
//                            id plan = aHomeCell.partnerPlan;
//                            if ([plan isKindOfClass:[LCPlanModel class]]) {
//                                [homeCellArray addObject:aHomeCell];
//                            }
//                        }
//                    }
//                }
//                
//                NSInteger orderType = [[dataDic objectForKey:@"FilterType"] integerValue];
//                NSString *resOrderStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"OrderStr"]];
//                
//                callBack(locName, homeCellArray, tourThemeId, orderType, resOrderStr, orderStr, error);
//            }else{
//                callBack(nil, nil, tourThemeId, orderType, nil, nil, error);
//            }
//        }
//    }];
//}

+ (void)getHomePageRecmdPlan_V_Four_ByLocation:(LCUserLocation *)location
                                       locName:(NSString *)locName
                                    filterType:(LCPlanOrderType)filterType
                                   orderString:(NSString *)orderStr
                                      planType:(NSInteger)planType
                                       themeId:(NSInteger)themeId
                                      callBack:(void(^)(NSArray *planArray,
                                                        NSString *orderStr,
                                                        NSError *error))callBack{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location && location.type != LocationTypeError) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)filterType] forKey:@"FilterType"];
    
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)planType] forKey:@"PlanType"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)themeId] forKey:@"ThemeId"];
    
    [[self getInstance] doPost:URL_GET_HOMEPAGE_RECMD_PLAN_V4 withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSArray *typeArray = [dataDic arrayForKey:@"MixedList"];
                NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                
                if (typeArray.count != planDicArray.count) {
                    LCLogError(@"searchMixPlanForDestionation error, data doesn't match");
                }else{
                    for (int i=0; i<typeArray.count; i++){
                        if ([typeArray[i] integerValue] == 0) {
                            LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (plan) {
                                [planArray addObject:plan];
                            }
                        }else if([typeArray[i] integerValue] == 1) {
                            LCWebPlanModel *webPlan = [[LCWebPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (webPlan) {
                                [planArray addObject:webPlan];
                            }
                        }
                    }
                }
                
                NSString *orderStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"OrderStr"]];
                
                callBack(planArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getCalendarPlan_V_Five_ByLocationName:(NSString *)locName
                                 startDate:(NSDate *)date
                                  orderStr:(NSString *)orderStr
                                  callBack:(void (^)(NSArray *, NSString *, NSError *))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    NSString *dateStr = [LCDateUtil stringFromDate:date];
    if ([LCStringUtil isNotNullString:dateStr]) {
        [param setObject:dateStr forKey:@"StartDate"];
    }
    
    [[self getInstance] doPost:URL_GET_CALENDAR_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < planDicArray.count; i ++) {
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                    if (plan) {
                        [planArray addObject:plan];
                    }
                }
                
                NSString *orderStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"OrderStr"]];
                
                callBack(planArray, orderStr, error);
            }
        }
    }];
    
}

+ (void)getLocationTourpic_V_Five_ByLocationName:(NSString *)locName
                                        orderStr:(NSString *)orderStr
                                        callBack:(void (^)(NSArray *, NSString *, NSError *))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_LOCATION_TOURPIC withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSArray *tourpicDicArray = [dataDic arrayForKey:@"TourPicList"];
                NSMutableArray *tourpicArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < tourpicDicArray.count; i ++) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:tourpicDicArray[i]];
                    if (tourpic) {
                        [tourpicArray addObject:tourpic];
                    }
                }
                
                NSString *orderStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"OrderStr"]];
                
                callBack(tourpicArray, orderStr, error);
            }
        }
    }];
}

+ (void)getLocationNearbyPlan_V_Five_ByLocationName:(NSString *)locName
                                           location:(LCUserLocation *)location
                                           orderStr:(NSString *)orderStr
                                           callBack:(void (^)(NSArray *, NSString *, NSError *))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
    }
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_LOCATION_NEARBY_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < planDicArray.count; i ++) {
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                    if (plan) {
                        [planArray addObject:plan];
                    }
                }
                
                NSString *orderStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"OrderStr"]];
                
                callBack(planArray, orderStr, error);
            }
        }
    }];
}

/// 获取省份.
+ (void)getHotCitysAndProvincesWithCallBack:(void(^)(NSArray *provinceArr, NSArray *hotCityArr, NSError *error))callBack {
    [[self getInstance] doGet:URL_COMMON_PROVINCE withParams:@{} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (nil != dataDic) {
                NSMutableArray *provinceArr = [[NSMutableArray alloc] init];
                NSMutableArray *hotCityArr = @[].mutableCopy;
                NSArray *provinceJsonArr = [dataDic objectForKey:@"ProvinceList"];
                NSArray *hotCityJsonArr = [dataDic objectForKey:@"HotCityList"];
                for (NSDictionary *dic in provinceJsonArr) {
                    LCProvinceModel *province = [[LCProvinceModel alloc] initWithDictionary:dic];
                    [provinceArr addObject:province];
                }
                for (NSDictionary *dic in hotCityJsonArr) {
                    LCCityModel *hotcity = [[LCCityModel alloc] initWithDictionary:dic];
                    [hotCityArr addObject:hotcity];
                }
                callBack(provinceArr, hotCityArr, error);
            } else {
                callBack(nil, nil, error);
            }
            
        }
    }];
}

/// 获取省份的城市.
+ (void)getCitysByProvinceID:(NSString *)provinceID callBack:(void(^)(NSArray *contentArr, NSError *error))callBack {
    provinceID = [LCStringUtil getNotNullStr:provinceID];
    [[self getInstance] doPost:URL_COMMON_CITY withParams:@{@"ProvinceId":provinceID} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (nil != dataDic) {
                NSMutableArray *contentArr = [[NSMutableArray alloc] init];
                NSArray *cityJsonArr = [dataDic objectForKey:@"CityList"];
                for (NSDictionary *cityDic in cityJsonArr) {
                    LCCityModel *model = [[LCCityModel alloc] initWithDictionary:cityDic];
                    [contentArr addObject:model];
                }
                callBack(contentArr, error);
            } else {
                callBack(nil, error);
            }
        }
    }];
}


#pragma mark - InnerFunction

/**
 目前，每个请求创建一个新的NetRequester
 以后，有可能使用Session等，优化时可以使用NetRequester的单例
 */
+ (instancetype)getInstance{
    return [[LCNetRequester alloc]init];
}
@end



