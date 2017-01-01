    //
//  LCWebPlanModel.h
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCWebPlanModel : LCBaseModel
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *planUrl;
@property (nonatomic, strong) NSString *departName;
@property (nonatomic, strong) NSArray *placeNames;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *telephone;

- (NSString *)getDestinationsStringWithSeparator:(NSString *)sep;
- (NSString *)getDepartAndDestString;
@end