//
//  LCRouteThemeModel.h
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCRouteThemeModel : LCBaseModel
@property (nonatomic, retain) NSString *coverUrl;
@property (nonatomic, retain) NSString *coverThumbUrl;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *themeDesc;
@property (nonatomic, assign) NSInteger tourThemeId;
@property (nonatomic, retain) NSArray *childThemeArr;    ///> 子主题.
@property (nonatomic, strong) NSString *iconUrl;
@end
