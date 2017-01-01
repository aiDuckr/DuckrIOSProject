//
//  LCRouteTableView.h
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCRouteInfo.h"

@protocol LCRouteTableViewDelegate;
@interface LCRouteTableView : UITableView
@property (nonatomic, weak) id<LCRouteTableViewDelegate> routeTableDelegate;
@property (nonatomic, strong) NSArray *routeInfos;
@end


@protocol LCRouteTableViewDelegate <NSObject>
@optional
- (void)routeTableView:(LCRouteTableView *)routeTableView didSelectRoute:(NSInteger)index;

@end