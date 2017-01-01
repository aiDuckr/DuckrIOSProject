//
//  LCPlanModel.h
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"
#import "LCRoutePlaceModel.h"
#import "LCUserModel.h"
#import "LCRouteThemeModel.h"
#import "QNUploadManager.h"
#import "CTAssetsPickerController.h"
#import "LCCommentModel.h"
#import "LCUserRouteModel.h"
#import "LCImageUnit.h"
#import "LCPartnerStageModel.h"
#import "LCCarIdentityModel.h"

typedef NS_ENUM(NSUInteger, LCPlanRelation) {
    LCPlanRelationScanner = 0,
    LCPlanRelationCreater = 1,
    LCPlanRelationMember = 2,
    LCPlanRelationApplying = 3,
    LCPlanRelationRejected = 4,
    LCPlanRelationKicked = 5,
};
typedef NS_ENUM(NSInteger, LCGenderLimit) { //SexLimit
    LCGenderLimitNone = 0,
    LCGenderLimitGenderMale = 1,
    LCGenderLimitGenderFemale = 2,
};

typedef NS_ENUM(NSInteger, LCRouteType) { //Type
    LCRouteTypeFreePlanCommon = 1,
    LCRouteTypeFreePlanSameCity = 2,
    LCRouteTypeFreePlanCostCommon = 3,
    LCRouteTyoeFreePlanCostSameCityCommon = 4,
};

typedef enum : NSUInteger {
    LCPlanType_Default = 0,
    LCPlanType_FreePlan = 1,
    LCPlanType_FreeLocal = 2,
    LCPlanType_CostPlan = 3,
    LCPlanType_CostLocal = 4,
} LCPlanType;

//typedef enum : NSUInteger {
//    LCPlanRelationScanner = 0,
//    LCPlanRelationCreater = 1,
//    LCPlanRelationMember = 2,
//    LCPlanRelationApplying = 3,
//    LCPlanRelationRejected = 4,
//    LCPlanRelationKicked = 5,
//} LCPlanRelation;


@interface LCPlanModel : LCBaseModel<NSCoding>
@property (nonatomic, retain) NSString *roomId;
@property (nonatomic, retain) NSString *roomTitle;
@property (nonatomic, retain) NSString *planShareTitle;
@property (nonatomic, assign) NSInteger userRouteId;

@property (nonatomic, retain) NSString *createdTime;
@property (nonatomic, retain) NSString *updatedTime;
@property (nonatomic, retain) NSString *startTime;      //@"yyyy-MM-dd"
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, assign) NSInteger daysLong;

@property (nonatomic, assign) NSInteger relation;
@property (nonatomic, assign) NSInteger isMember;
@property (nonatomic, assign) NSInteger isNeedIdentity;
@property (nonatomic, assign) NSInteger isAllowPhoneContact;
@property (nonatomic, assign) NSInteger isFavored;
@property (nonatomic, assign) NSInteger isNeedReview;
@property (nonatomic, assign) NSInteger isCheckedIn;
@property (nonatomic, assign) NSInteger isEvalued;
@property (nonatomic, assign) NSInteger isAlert;
@property (nonatomic, assign) NSInteger isArrived;

@property (nonatomic, retain) NSString *departName;
@property (nonatomic, retain) NSArray *memberList;
@property (nonatomic, retain) NSArray *applyingList;
@property (nonatomic, retain) NSArray *tourThemes;  // array of LCRouteThemeModel
@property (nonatomic, retain) NSArray *destinationNames;
@property (nonatomic, retain) NSArray *commentList;
@property (nonatomic, retain) NSMutableArray *stageArray;  // array of LCPartnerStageModel

//Route
@property (nonatomic, retain) LCUserRouteModel *userRoute;
//@property (nonatomic, retain) NSArray *routePlaces;

//Service
@property (nonatomic, assign) NSInteger isProvideCar;
@property (nonatomic, assign) NSInteger isProvideTourGuide;

@property (nonatomic, strong) LCCarIdentityModel *carIdentity;

@property (nonatomic, assign) NSInteger browseNumber;
@property (nonatomic, assign) NSInteger commentNumber;
@property (nonatomic, assign) NSInteger unreadCommentNum;
@property (nonatomic, assign) NSInteger scaleMax;

@property (nonatomic, retain) NSString *roomAvatar;
@property (nonatomic, retain) NSString *firstPhotoUrl;
@property (nonatomic, retain) NSString *firstPhotoThumbUrl;
@property (nonatomic, retain) NSString *secondPhotoUrl;
@property (nonatomic, retain) NSString *secondPhotoThumbUrl;
@property (nonatomic, retain) NSString *thirdPhotoUrl;
@property (nonatomic, retain) NSString *thirdPhotoThumbUrl;

/**
 * 5.0新增字段
 */
///<照片数组
@property (nonatomic, retain) NSArray *photoUrls;//("PhotoUrls")
///<标签
@property (nonatomic, retain) NSArray *tagsArray;//TagIds
///<主题
@property (nonatomic, retain) NSArray *selectedThemeArr;
@property (nonatomic, assign) NSInteger tourThemeId;//主题ID

@property (nonatomic, assign) LCRouteType routeType;
@property (nonatomic, assign) LCGenderLimit genderLimit;
@property (nonatomic, strong) LCUserLocation *location;
@property (nonatomic, strong) NSString *planTips;
@property (nonatomic, strong) NSArray *showThemeArr;

///<邀约详情，想去列表
@property (nonatomic, retain) NSMutableArray *favorUserArr;

@property (nonatomic, assign) NSInteger favorNumber;
//favorNumberCount


@property (nonatomic, retain) NSString *publishPlace;

@property (nonatomic, assign) NSInteger userNum;
@property (nonatomic, retain) NSString *planShareUrl;
@property (nonatomic, retain) NSString *planGuid;
@property (nonatomic, retain) NSString *descriptionStr;
@property (nonatomic, retain) NSString *participateNote;
@property (nonatomic, retain) NSString *orderStr;

@property (nonatomic, assign) NSInteger scoreUpper; //本次活动中用户可以使用的最高积分 4.1
@property (nonatomic, retain) NSNumber *avgPoint;   // 所用用户评分后最后的平均分 -1代表无评分

@property (nonatomic, assign) NSInteger distance; //2000     当前用户距离发布邀约的距离
@property (nonatomic, retain) NSString *costInclude; //"包含哪些费用"     费用包含    3.1 支付
@property (nonatomic, retain) NSString *costExclude; //"不包含哪些费用"    费用不包含    3.1 支付
@property (nonatomic, retain) NSString *refundIntro; //5.0 退款说明
@property (nonatomic, strong) NSDecimalNumber *costPrice;    //200    // 价格    3.1 支付
@property (nonatomic, strong) NSDecimalNumber *costEarnest;  //40.00    // 订金    3.1 支付
@property (nonatomic, assign) NSInteger totalOrderNumber;   //3    //  付款的用户总数，不包括商家本人
@property (nonatomic, strong) NSDecimalNumber *totalEarnest;     //120.00    // 总收益  付款用户数 ＊ 订金
@property (nonatomic, assign) NSInteger totalOrderStatus;   //1  //四种状态， -1正常邀约或未有人付款的邀约，0，未入账，1已入账，2已结算
@property (nonatomic, assign) NSInteger totalStageOrderNumber;  //25 所有分期的订单总数，加1显示在最外面已加入人数
@property (nonatomic, assign) NSInteger currentPlanOrderNumber;    ///> 当前邀约计划的总人数.
@property (nonatomic, retain) NSDecimalNumber *currentMerchantEarning;    ///> 当前商家的收入.

@property (nonatomic, strong) NSString *stageMaster;    // 58267953553f3d38938ca1426ad03762   // 主邀约的Guid，用于过滤
@property (nonatomic, retain) NSString *declaration;    ///> 商家邀约的标题.
@property (nonatomic, retain) NSString *gatherTime;    ///> 商家邀约集合时间.
@property (nonatomic, retain) NSString *gatherPlace;    ///> 商家邀约集合地点.

/// 生成对象.
@property (nonatomic, retain) NSArray *canSelectedStage;
@property (nonatomic, strong) NSDecimalNumber *lowestPrice;

// only for Publish Plan
@property (nonatomic, strong) NSDecimalNumber *costRadio;   //0.5    // 订金比例  如果为空，则使用后台默认的老比例，否则使用传入的比例

// only for edit image
@property (nonatomic, strong) NSMutableArray *imageUnits;
@property (assign, nonatomic) LCNewOrHotType newOrHotType;
@property (strong, nonatomic) NSArray *showingList;
@property (strong, nonatomic) NSString *showingText;
@property (strong, nonatomic) NSString *reason;

+ (instancetype)createEmptyPlanForEdit;
#pragma mark RouteTheme
- (void)addRouteTheme:(LCRouteThemeModel *)theme;
- (void)removeRouteTheme:(NSInteger)themeID;
- (BOOL)haveTheme:(NSInteger)themeID;

#pragma mark Stage
- (void)addStage:(LCPartnerStageModel *)stage;
- (void)removeStageAtIndex:(NSInteger)stageIndex;

#pragma mark Stage Operation
- (void)setFirstStageStartTime:(NSString *)startTime;
- (void)setFirstStageEndTime:(NSString *)endTime;
- (void)setFirstStagePrice:(NSDecimalNumber *)price;
- (NSString *)getFirstStageStartTime;
- (NSString *)getFirstStageEndTime;
- (NSDecimalNumber *)getFirstStagePrice;

#pragma mark NetRequest
- (NSMutableDictionary *)getDicForNetRequest;


#pragma mark - 
- (NSString *)getDestinationsStringWithSeparator:(NSString *)sep;
- (NSString *)getDepartAndDestString;
+ (NSArray *)getDestinationsStringArrayWithSeparator:(NSString *)sep fromString:(NSString *)destinationsString;

- (NSInteger)getRouteDayNum;
- (NSString *)getRoutePlaceStringForDay:(NSInteger)routeDay withSeparator:(NSString *)sep;

- (NSString *)getPlanTimeString;
- (NSString *)getSingleStartDateText;
- (NSString *)getPlanStartDateText;
- (NSString *)getPlanLastDateText;
- (NSString *)getPlanCostPerPerson;
- (NSString *)getPlanCostPerPersonForUserOrder;
- (NSString *)getPlanCostAndMemberNumberText;

- (LCPlanRelation)getPlanRelation;

- (BOOL)isCreater:(LCUserModel *)user;

- (BOOL)isEmptyPlan;
- (BOOL)isMerchantCostPlan;
- (BOOL)isFreePlan;
- (BOOL)isStagePlan;
- (NSInteger)getCurStageIndex;

//同城邀约
- (BOOL)isUrbanPlan;
- (BOOL)isCostCarryPlan;
- (BOOL)isFreeCarryPlan;

//返回当前期所有订单数+创建者
- (NSInteger)getCurPlanTotalOrderNumber;

+ (NSMutableArray *)addAndFiltDuplicateStagePlanArr:(NSArray *)planArr toOriginalPlanArr:(NSArray *)originalPlanArr;
+ (NSArray *)getDestinationArrayByString:(NSString *)destinationStr;
- (NSString *)getStartEndTimeText;

@end
