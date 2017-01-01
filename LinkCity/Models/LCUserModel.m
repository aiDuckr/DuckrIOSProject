//
//  LCUserModel.m
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserModel.h"

@implementation LCUserModel

#pragma mark - PublicInterface
- (BOOL)isMerchant {
    BOOL isMerchantInfo = NO;
    if (LCIdentityStatus_Done == self.isTourGuideVerify || LCIdentityStatus_Done == self.isTravelAgency || LCIdentityStatus_Done == self.isLocalMerchant) {
        isMerchantInfo = YES;
    }
    return isMerchantInfo;
}
- (BOOL)isCarServer{
    return self.isCarVerify==LCIdentityStatus_Done;
}

- (NSInteger)getMaxPlanMember{
    if (self.isCarVerify==LCIdentityStatus_Done || self.isTourGuideVerify==LCIdentityStatus_Done) {
        return MaxPlanScaleOfMerchant;
    }else{
        return MaxPlanScaleOfUsualUser;
    }
}

- (UserSex)getUserSex{
    UserSex sex = UserSex_Male;
    
    if (self.sex == UserSex_Male) {
        sex = UserSex_Male;
    }else if(self.sex == UserSex_Female){
        sex = UserSex_Female;
    }
    
    return sex;
}

- (NSString *)getSexStringForChinese{
    if ([self getUserSex] == UserSex_Male) {
        return @"男";
    }else if([self getUserSex] == UserSex_Female){
        return @"女";
    }else{
        return @"未知";
    }
}

- (NSString *)getUserAgeString{
    if (self.age < 0) {
        return @"—";
    }else{
        return [NSString stringWithFormat:@"%ld",(long)self.age];
    }
}

- (LCIdentityStatus)getUserIdentityStatus{
    return self.isIdentify;
}

+ (NSMutableArray *)addAndFiltDuplicateStageUserArr:(NSArray *)userArr toOriginalUserArr:(NSArray *)originalUserArr{
    NSMutableArray *retArr = [NSMutableArray new];
    if (originalUserArr && originalUserArr.count > 0) {
        [retArr addObjectsFromArray:originalUserArr];
    }
    
    [userArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LCUserModel class]]) {
            LCUserModel *aUser = (LCUserModel *)obj;
            BOOL isSameItem = NO;
            for (int i = 0; i <retArr.count; i++) {
                LCUserModel *userItem = (LCUserModel *)retArr[i];
                if ([aUser.telephone isEqualToString:userItem.telephone]) {
                    isSameItem = YES;
                    break;
                }
            }
            if (!isSameItem) {
                [retArr addObject:aUser];
            }
//            if (![self isStageMaster:aUser.stageMaster inUserArray:retArr]) {
//                [retArr addObject:obj];
//            }
        }    }];
    
    return retArr;
}


- (NSString *)getUserRelationString {
    NSString *ret = @"";
    switch (self.relation) {
        case LCUserModelRelation_None:
            ret = @"";
            break;
        case LCUserModelRelation_Favored:
            ret = @"已关注";
            break;
        case LCUserModelRelation_Invited:
            ret = @"已邀请";
            break;
        case LCUserModelRelation_AddreeBookFriend:
            ret = @"通讯录好友";
            break;
        case LCUserModelRelation_TravelExpert:
            ret = @"旅行达人";
            break;
        case LCUserModelRelation_TwoDimensionFriend:
            ret = @"朋友的朋友";
            break;
        case LCUserModelRelation_EachFavored:
            ret = @"互相关注";
            break;
        case LCUserModelRelation_BeFavored:
            ret = @"粉丝";
            break;
        default:
            break;
    }
    
    return ret;
}

- (NSString *)getUserStatusStr {
    NSString *ret = @"";
    switch (self.localStatus) {
        case LCUserModelStatusType_OfflineLocal:
            ret = self.signature;
            break;
        case LCUserModelStatusType_OnlineLocal:
            ret = @"在线";
            break;
        case LCUserModelStatusType_TelephoneFriend:
            ret = @"通讯录好友";
            break;
        default: {
            if (self.localStatus > 0) {
                ret = [NSString stringWithFormat:@"%ld个共同好友", self.localStatus];
            }
        }
            break;
    }
    
    return ret;
}

- (BOOL)paidEarnest{
    if (self.partnerOrder && [LCDecimalUtil isOverZero:self.partnerOrder.orderPrice]) {
        return YES;
    }
    
    return NO;
}
- (BOOL)isEarnestOnly{
    if (self.partnerOrder &&
        [LCDecimalUtil isOverZero:self.partnerOrder.orderPrice] &&
        [self.partnerOrder.orderPrice compare:self.partnerOrder.orderEarnest]==NSOrderedSame) {
        return YES;
    }
    
    return NO;
}
- (BOOL)paidTail{
    //已支付尾款
    //或订金金额等于全款金额
    if ((self.tailOrder && [LCDecimalUtil isOverZero:self.tailOrder.orderPrice]) ||
        ([self paidEarnest] && [self.partnerOrder.orderPrice compare:self.partnerOrder.orderEarnest]==NSOrderedSame)) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Init & Encode & Decode
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.cID = [LCStringUtil getNotNullStr:[dic objectForKey:@"CID"]];
        self.avatarUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"AvatarUrl"]];
        NSNumber *isIdentifyNum = [dic objectForKey:@"IsIdentify"];
        self.isIdentify = [isIdentifyNum integerValue];
        self.signature = [LCStringUtil getNotNullStr:[dic objectForKey:@"Signature"]];
        NSNumber *distanceNum = [dic objectForKey:@"Distance"];
        self.distance = [distanceNum integerValue];
        self.livingPlace = [LCStringUtil getNotNullStr:[dic objectForKey:@"LivingPlace"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        NSNumber *sexNum = [dic objectForKey:@"Sex"];
        self.sex = [sexNum integerValue];
        NSNumber *isCarVerfiyNum = [dic objectForKey:@"IsCarVerify"];
        self.isCarVerify = [isCarVerfiyNum integerValue];
        NSNumber *livingPlaceIdNum = [dic objectForKey:@"LivingPlaceId"];
        self.livingPlaceId = [livingPlaceIdNum integerValue];
        self.birthday = [LCStringUtil getNotNullStr:[dic objectForKey:@"Birthday"]];
        self.uUID = [LCStringUtil getNotNullStr:[dic objectForKey:@"UUID"]];
        self.nick = [LCStringUtil getNotNullStr:[dic objectForKey:@"Nick"]];
        NSNumber *isTourGuideVerifyNum = [dic objectForKey:@"IsTourGuideVerify"];
        self.isTourGuideVerify = [isTourGuideVerifyNum integerValue];
        self.isTravelAgency = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsTravelAgency"]];
        self.isLocalMerchant = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsLocalMerchant"]];
        self.realName = [LCStringUtil getNotNullStr:[dic objectForKey:@"RealName"]];
        self.professional = [LCStringUtil getNotNullStr:[dic objectForKey:@"Professional"]];
        self.school = [LCStringUtil getNotNullStr:[dic objectForKey:@"School"]];
        NSNumber *partnerFinishNumNum = [dic objectForKey:@"PartnerFinishNum"];
        self.partnerFinishNum = [partnerFinishNumNum integerValue];
        NSNumber *ageNum = [dic objectForKey:@"Age"];
        self.age = [ageNum integerValue];
        NSNumber *favorNumNum = [dic objectForKey:@"FavorNum"];
        self.favorNum = [favorNumNum integerValue];
        NSNumber *fansNumNum = [dic objectForKey:@"FansNum"];
        self.fansNum = [fansNumNum integerValue];
        NSNumber *evaluationNumNum = [dic objectForKey:@"EvaluationNum"];
        self.evaluationNum = [evaluationNumNum integerValue];
        self.relation = [LCStringUtil idToNSInteger:[dic objectForKey:@"Relation"]];
        self.point = [LCStringUtil idToNSInteger:[dic objectForKey:@"Point"]];
        self.haveGoNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"HaveGoNum"]];
        
        self.wantGoList = [dic objectForKey:@"WantGoList"];
        self.haveGoList = [dic objectForKey:@"HaveGoList"];

        NSMutableArray *userEvaluationsArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *aEvaluationDic in [dic arrayForKey:@"UserEvaluations"]){
            LCUserEvaluationModel *aEvaluation = [[LCUserEvaluationModel alloc] initWithDictionary:aEvaluationDic];
            if (aEvaluation) {
                [userEvaluationsArray addObject:aEvaluation];
            }
        }
        self.userEvaluations = userEvaluationsArray;
        
        self.loginTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"LoginTime"]];
        self.constellation = [LCStringUtil getNotNullStr:[dic objectForKey:@"Constellation"]];
        NSDictionary*inviteJsonDic=[dic objectForKey:@"InviteTheme"];
        if(inviteJsonDic.count>0){
        self.inviteThemeStr = [LCStringUtil getNotNullStr:[inviteJsonDic objectForKey:@"Title"]];
//        self.inviteThemeID = [LCStringUtil getNotNullStr:[inviteJsonDic objectForKey:@"TourThemeId"]];
        }
        
        self.avatarThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"AvatarThumbUrl"]];
        self.telephone = [LCStringUtil getNotNullStr:[dic objectForKey:@"Telephone"]];
        NSNumber *isFavoredNum = [dic objectForKey:@"IsFavored"];
        self.isFavored = [isFavoredNum integerValue];
        self.openfireAccount = [LCStringUtil getNotNullStr:[dic objectForKey:@"OpenfireAccount"]];
        self.openfirePass = [LCStringUtil getNotNullStr:[dic objectForKey:@"OpenfirePass"]];
        self.tourpicCoverUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"TourpicCoverUrl"]];
        
        
        self.marginValue = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"MarginValue"] decimalValue]];
        self.partnerOrder = [[LCPartnerOrderModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"PartnerOrder"]];
        self.tailOrder = [[LCPartnerOrderModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"TailOrder"]];
        
        self.isSelected = NO;
    }
    return self;
}


- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.cID forKey:@"CID"];
    [coder encodeObject:self.avatarUrl forKey:@"AvatarUrl"];
    [coder encodeInteger:self.isIdentify forKey:@"IsIdentify"];
    [coder encodeObject:self.signature forKey:@"Signature"];
    [coder encodeInteger:self.distance forKey:@"Distance"];
    [coder encodeObject:self.livingPlace forKey:@"LivingPlace"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeInteger:self.sex forKey:@"Sex"];
    [coder encodeInteger:self.isCarVerify forKey:@"IsCarVerify"];
    [coder encodeInteger:self.livingPlaceId forKey:@"LivingPlaceId"];
    [coder encodeObject:self.birthday forKey:@"Birthday"];
    [coder encodeObject:self.uUID forKey:@"UUID"];
    [coder encodeObject:self.nick forKey:@"Nick"];
    [coder encodeInteger:self.isTourGuideVerify forKey:@"IsTourGuideVerify"];
    [coder encodeInteger:self.isTravelAgency forKey:@"IsTravelAgency"];
    [coder encodeInteger:self.isLocalMerchant forKey:@"IsLocalMerchant"];
    [coder encodeObject:self.realName forKey:@"RealName"];
    [coder encodeObject:self.professional forKey:@"Professional"];
    [coder encodeObject:self.school forKey:@"School"];
    [coder encodeInteger:self.partnerFinishNum forKey:@"PartnerFinishNum"];
    [coder encodeInteger:self.age forKey:@"Age"];
    [coder encodeInteger:self.favorNum forKey:@"FavorNum"];
    [coder encodeInteger:self.fansNum forKey:@"FansNum"];
    [coder encodeInteger:self.evaluationNum forKey:@"EvaluationNum"];
    [coder encodeInteger:self.relation forKey:@"Relation"];
    [coder encodeInteger:self.point forKey:@"Point"];
    [coder encodeInteger:self.haveGoNum forKey:@"HaveGoNum"];
    [coder encodeObject:self.userEvaluations forKey:@"UserEvaluations"];
    [coder encodeObject:self.avatarThumbUrl forKey:@"AvatarThumbUrl"];
    [coder encodeObject:self.telephone forKey:@"Telephone"];
    [coder encodeInteger:self.isFavored forKey:@"IsFavored"];
    [coder encodeObject:self.openfireAccount forKey:@"OpenfireAccount"];
    [coder encodeObject:self.openfirePass forKey:@"OpenfirePass"];
    [coder encodeObject:self.tourpicCoverUrl forKey:@"TourpicCoverUrl"];
    
    [coder encodeObject:self.marginValue forKey:@"MarginValue"];
    [coder encodeObject:self.partnerOrder forKey:@"PartnerOrder"];
    [coder encodeObject:self.tailOrder forKey:@"TailOrder"];
    
    
    
    [coder encodeObject:self.loginTime forKey:@"LoginTime"];
    [coder encodeObject:self.constellation forKey:@"Constellation"];
    [coder encodeObject:self.inviteThemeStr forKey:@"Title"];
//    [coder encodeObject:self.inviteThemeID forKey:@"TourThemeId"];
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.cID = [coder decodeObjectForKey:@"CID"];
        self.avatarUrl = [coder decodeObjectForKey:@"AvatarUrl"];
        self.isIdentify = [coder decodeIntegerForKey:@"IsIdentify"];
        self.signature = [coder decodeObjectForKey:@"Signature"];
        self.distance = [coder decodeIntegerForKey:@"Distance"];
        self.livingPlace = [coder decodeObjectForKey:@"LivingPlace"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.sex = [coder decodeIntegerForKey:@"Sex"];
        self.isCarVerify = [coder decodeIntegerForKey:@"IsCarVerify"];
        self.livingPlaceId = [coder decodeIntegerForKey:@"LivingPlaceId"];
        self.birthday = [coder decodeObjectForKey:@"Birthday"];
        self.uUID = [coder decodeObjectForKey:@"UUID"];
        self.nick = [coder decodeObjectForKey:@"Nick"];
        self.isTourGuideVerify = [coder decodeIntegerForKey:@"IsTourGuideVerify"];
        self.isTravelAgency = [coder decodeIntegerForKey:@"IsTravelAgency"];
        self.isLocalMerchant = [coder decodeIntegerForKey:@"IsLocalMerchant"];
        self.realName = [coder decodeObjectForKey:@"RealName"];
        self.professional = [coder decodeObjectForKey:@"Professional"];
        self.school = [coder decodeObjectForKey:@"School"];
        self.partnerFinishNum = [coder decodeIntegerForKey:@"PartnerFinishNum"];
        self.age = [coder decodeIntegerForKey:@"Age"];
        self.favorNum = [coder decodeIntegerForKey:@"FavorNum"];
        self.fansNum = [coder decodeIntegerForKey:@"FansNum"];
        self.relation = [coder decodeIntegerForKey:@"Relation"];
        self.point = [coder decodeIntegerForKey:@"Point"];
        self.haveGoNum = [coder decodeIntegerForKey:@"HaveGoNum"];
        self.evaluationNum = [coder decodeIntegerForKey:@"EvaluationNum"];
        self.userEvaluations = [coder decodeObjectForKey:@"UserEvaluations"];
        self.avatarThumbUrl = [coder decodeObjectForKey:@"AvatarThumbUrl"];
        self.telephone = [coder decodeObjectForKey:@"Telephone"];
        self.isFavored = [coder decodeIntegerForKey:@"IsFavored"];
        self.openfireAccount = [coder decodeObjectForKey:@"OpenfireAccount"];
        self.openfirePass = [coder decodeObjectForKey:@"OpenfirePass"];
        self.tourpicCoverUrl = [coder decodeObjectForKey:@"TourpicCoverUrl"];
        
        self.marginValue = [coder decodeObjectForKey:@"MarginValue"];
        self.partnerOrder = [coder decodeObjectForKey:@"PartnerOrder"];
        self.tailOrder = [coder decodeObjectForKey:@"TailOrder"];
        
        self.loginTime = [coder decodeObjectForKey:@"LoginTime"];
        self.constellation = [coder decodeObjectForKey:@"Constellation"];
        self.inviteThemeStr = [coder decodeObjectForKey:@"Title"];
//        self.inviteThemeID = [coder decodeObjectForKey:@"TourThemeId"];
      
    }
    return self;
}
@end
