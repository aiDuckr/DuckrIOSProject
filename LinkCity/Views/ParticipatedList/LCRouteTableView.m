//
//  LCRouteTableView.m
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCRouteTableView.h"
#import "LCRouteTableViewCell.h"

#define HEIGHT_PER_ROW 85

@interface LCRouteTableView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LCRouteTableView

- (void)setRouteInfos:(NSMutableArray *)routeInfos{
    _routeInfos = routeInfos;
    self.delegate = self;
    self.dataSource = self;
    
    self.scrollEnabled = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self invalidateIntrinsicContentSize];
    [self reloadData];
}


- (CGSize)intrinsicContentSize{
    if (self.routeInfos && self.routeInfos.count > 0) {
        return CGSizeMake(0,
                          HEIGHT_PER_ROW * self.routeInfos.count);
    }else{
        return CGSizeMake(0, 0);
    }
    
}


#pragma mark - UITableViewDelegae
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RLog(@"did select row %ld",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.routeTableDelegate && [self.routeTableDelegate respondsToSelector:@selector(routeTableView:didSelectRoute:)]) {
        [self.routeTableDelegate routeTableView:self didSelectRoute:indexPath.row];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_PER_ROW;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.routeInfos.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteTableViewCell"];
    
    cell.routeInfo = [self.routeInfos objectAtIndex:indexPath.row];
    return cell;
}


@end
