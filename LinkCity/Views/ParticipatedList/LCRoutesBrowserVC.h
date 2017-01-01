//
//  LCRoutesBrowserVC.h
//  LinkCity
//
//  Created by roy on 11/15/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCRouteInfo.h"

@interface LCRoutesBrowserVC : LCBaseVC
@property (nonatomic,strong) NSArray *routes;
@property (nonatomic,assign) NSInteger routeIndexShouldShow;
@property (nonatomic,strong) UIImage *bgImage;


- (void)showRoutes:(NSArray *)routes atIndex:(NSInteger)routeIndex;
@end
