//
//  LCPlanTableVC.h
//  LinkCity
//
//  Created by roy on 2/7/15.
//  Copyright (c) 2015 ;. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCPlanModel.h"
#import "LCRouteThemeModel.h"


typedef enum : NSUInteger {
    LCPlanTableForSearchDestination,    // show tabview
    LCPlanTableForSearchTheme,
    LCPlanTableForUserCreated,
    LCPlanTableForUserJoined,
    LCPlanTableForUserFavored,
    LCPlanTableForRouteRelevant,
    LCPlanTableForHomePageFavorPlan,
} LCPlanTableVCType;

typedef enum : NSUInteger {
    LCPlanTableVCTab_PlanTable,
    LCPlanTableVCTab_User,
} LCPlanTableVCTab;

@interface LCPlanTableVC : LCAutoRefreshVC
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) LCRouteThemeModel *theme;
@property (nonatomic, strong) LCUserModel *user;
@property (nonatomic, strong) LCUserRouteModel *userRouteModel;

@property (nonatomic, assign) LCPlanTableVCType showingType;
@property (nonatomic, assign) LCPlanTableVCTab showingTab;
@property (nonatomic, strong) NSMutableArray *planModelArray;   //array of LCPlanModel
@property (nonatomic, strong) NSMutableArray *userModelArray;   //array of LCUserModel
@property (nonatomic, strong) NSMutableArray *tourpicModelArray;    //array of LCTourpic
@property (nonatomic, strong) NSArray *chatRoomArray;    //array of LCChatGroupModel

+ (instancetype)createInstance;
@end
