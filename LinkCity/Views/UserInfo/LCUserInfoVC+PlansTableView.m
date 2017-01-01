//
//  LCUserInfoVC+PlansTableView.m
//  LinkCity
//
//  Created by roy on 11/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoVC.h"
#import "LCViewSwitcher.h"

@implementation LCUserInfoVC (PlansTableView)
#pragma mark - UITableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.plans.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PlansTableCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserInfoPagePlansTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoPlansTableCell"];
    BOOL isFirst = indexPath.row==0;
    BOOL isLast = indexPath.row==self.plans.count-1;
    [cell showPlan:[self.plans objectAtIndex:indexPath.row] asFirstCell:isFirst asLastCell:isLast];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.plans.count > indexPath.row) {
        [LCViewSwitcher pushToShowDetailOfPlan:[self.plans objectAtIndex:indexPath.row] onNavigationVC:self.navigationController];
        //[self pushToDetailVC:[self.plans objectAtIndex:indexPath.row]];
    }
}
@end
