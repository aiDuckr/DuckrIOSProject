//
//  LCPlanRouteListVC.h
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCPlanRouteCellForAddDay.h"
#import "LCPlanRouteCellForAddRoute.h"
#import "LCPlanRouteCellForRoute.h"
#import "LCPlanRouteCellForDay.h"
#import "LCPlanRouteDataSource.h"
#import "LCPlanRouteEditPlaceVC.h"
#import "LCPlanRouteCellForRouteTitle.h"
#import "LCPlanRouteCellForChargeInfo.h"

typedef enum : NSUInteger {
    LCRouteEditType_ForSendPlan = 1,
    LCRouteEditType_ForGuideIdentity = 2,
    LCRouteEditType_ForAddRoute = 3,
} LCRouteEditType;

@protocol LCPlanRouteEditVCDelegate;
@interface LCPlanRouteEditVC : LCBaseVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) id<LCPlanRouteEditVCDelegate> delegate;
@property (nonatomic, assign) LCRouteEditType routeEditType;

@property (nonatomic, strong) LCUserRouteModel *editingUserRoute;
@property (weak, nonatomic) IBOutlet UITableView *routeTableView;
@property (nonatomic, strong) LCPlanRouteDataSource *planRouteDataSource;


+ (instancetype)createInstance;


@end



@protocol LCPlanRouteEditVCDelegate <NSObject>

- (void)planRouteEditVC:(LCPlanRouteEditVC *)routeEditVC didSaveUserRoute:(LCUserRouteModel *)userRoute;
- (void)planRouteEditVCDidCancel:(LCPlanRouteEditVC *)routeEditVC;

@end
