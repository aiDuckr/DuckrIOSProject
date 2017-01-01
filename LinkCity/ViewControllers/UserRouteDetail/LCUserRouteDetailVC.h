//
//  LCUserRouteDetailVC.h
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCUserRouteModel.h"
#import "LCUserModel.h"

@interface LCUserRouteDetailVC : LCBaseVC
@property (nonatomic, assign) BOOL editable;    //标记是否可编辑，如果是，右上角有按钮； 默认为否
@property (nonatomic, strong) LCUserModel *routeOwner;
@property (nonatomic, strong) LCUserRouteModel *userRoute;
@property (nonatomic, assign) NSInteger gonaShowDayIndex;
@property (nonatomic, strong) void(^chooseCallBack)(BOOL choose);

+ (instancetype)createInstance;

@end
