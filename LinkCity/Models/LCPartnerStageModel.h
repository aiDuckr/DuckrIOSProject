//
//  LCPartnerStageModel.h
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCPartnerStageModel : LCBaseModel
@property (nonatomic, strong) NSString *planGuid;   //"PlanGuid": "9b7521328b68016dd8fa9b9698641d62",   // 每一期邀约的Guid
@property (nonatomic, strong) NSString *startTime;  //"StartTime": "2015-10-16",    // 每一期邀约的出发时间
@property (nonatomic, strong) NSString *endTime;    //"EndTime": "2015-10-19",    //  每一期邀约的结束时间

@property (nonatomic, strong) NSDecimalNumber *price;   //"Price": 200,    // 邀约的价格
@property (nonatomic, strong) NSDecimalNumber *earnest; //"Earnest": 140,   // 邀约的订金
@property (nonatomic, strong) NSDecimalNumber *totalEarnest;   //100  当前分期的总收入

@property (nonatomic, assign) NSInteger joinNumber;     //"UserNumber": 1,    // 加入实际用户数，包括创建者本人，考虑了有订单的情况
@property (nonatomic, assign) NSInteger totalNumber;    //"TotalNumber": 40   // 邀约的总人数上限

@property (nonatomic, assign) NSInteger isMember;
@property (nonatomic, strong) NSArray *member;  //// 只有在查看用户加入的情况下才会用到


- (NSString *)getDepartTimeStr; // e.g. 06.09出发
@end
