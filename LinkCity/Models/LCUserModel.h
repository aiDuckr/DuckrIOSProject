//
//  LCUserModel.h
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"
#import "LCUserEvaluationModel.h"
#import "LCConstants.h"
#import "LCPartnerOrderModel.h"

typedef enum :NSInteger {
    LCUserModelStatusType_OfflineLocal = -2,
    LCUserModelStatusType_OnlineLocal = -1,
    LCUserModelStatusType_TelephoneFriend = 0,
} LCUserModelStatusType;

@interface LCUserModel : LCBaseModel

/// TODO: confim the key and name of use's cid
@property (nonatomic, retain) NSString *cID;
@property (nonatomic, retain) NSString *uUID;

@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, retain) NSString *nick;
@property (nonatomic, retain) NSString *realName;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *avatarUrl;
@property (nonatomic, retain) NSString *avatarThumbUrl;
@property (nonatomic, retain) NSString *signature;
@property (nonatomic, assign) NSInteger livingPlaceId;
@property (nonatomic, retain) NSString *livingPlace;
@property (nonatomic, strong) NSString *professional;
@property (nonatomic, strong) NSString *school;

@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger partnerFinishNum;
@property (nonatomic, assign) NSInteger favorNum;
@property (nonatomic, assign) NSInteger fansNum;
@property (nonatomic, assign) NSInteger point;
@property (nonatomic, assign) NSInteger haveGoNum;

@property (nonatomic, strong) NSArray *wantGoList;
@property (nonatomic, strong) NSArray *haveGoList;

@property (nonatomic, assign) NSInteger evaluationNum;
@property (nonatomic, strong) NSArray *userEvaluations;

@property (nonatomic, retain) NSString *createdTime;
@property (nonatomic, retain) NSString *openfireAccount;
@property (nonatomic, retain) NSString *openfirePass;

@property (nonatomic, assign) NSInteger isFavored;
@property (nonatomic, assign) NSInteger isIdentify;
@property (nonatomic, assign) NSInteger isCarVerify;
@property (nonatomic, assign) NSInteger isTourGuideVerify;
@property (nonatomic, assign) NSInteger isTravelAgency;
@property (nonatomic, assign) NSInteger isLocalMerchant;
@property (nonatomic, assign) NSInteger relation;
@property (nonatomic, assign) NSInteger localStatus;
@property (nonatomic, retain) NSString *tourpicCoverUrl;

@property (nonatomic, retain) NSString *constellation;
@property (nonatomic, retain) NSString *inviteThemeStr;
//@property (nonatomic, retain) NSString *inviteThemeID;
@property (nonatomic, retain) NSString *loginTime;

@property (nonatomic, strong) NSDecimalNumber *marginValue; //0代表没有交保证金
@property (nonatomic, strong) LCPartnerOrderModel *partnerOrder;
@property (nonatomic, strong) LCPartnerOrderModel *tailOrder;

@property (nonatomic, assign) BOOL isSelected;      //在一些页面中，用于标记是否被选中

- (BOOL)isMerchant;
- (BOOL)isCarServer;
- (NSInteger)getMaxPlanMember;
- (UserSex)getUserSex;
- (NSString *)getSexStringForChinese;
- (NSString *)getUserAgeString;
- (LCIdentityStatus)getUserIdentityStatus;
- (NSString *)getUserRelationString;
- (NSString *)getUserStatusStr;
+ (NSMutableArray *)addAndFiltDuplicateStageUserArr:(NSArray *)userArr toOriginalUserArr:(NSArray *)originalUserArr;

- (BOOL)paidEarnest;
- (BOOL)isEarnestOnly;
- (BOOL)paidTail;
@end
