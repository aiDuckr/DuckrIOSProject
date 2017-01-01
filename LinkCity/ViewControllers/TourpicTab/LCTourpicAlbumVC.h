//
//  LCTourpicAlbumVC.h
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

@interface LCTourpicAlbumVC : LCAutoRefreshVC
@property (retain, nonatomic) LCUserModel *user;
+ (instancetype)createInstance;
@end
