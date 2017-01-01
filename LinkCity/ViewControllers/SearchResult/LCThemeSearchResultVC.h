//
//  LCThemeSearchResultVC.h
//  LinkCity
//
//  Created by roy on 6/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCRouteThemeModel.h"

@interface LCThemeSearchResultVC : LCAutoRefreshVC
@property (nonatomic, assign) NSInteger themeId;
@property (nonatomic, strong) NSString *themeName;

@end
