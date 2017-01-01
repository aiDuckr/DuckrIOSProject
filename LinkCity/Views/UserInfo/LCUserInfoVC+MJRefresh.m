//
//  LCUserInfo+MJRefresh.m
//  LinkCity
//
//  Created by roy on 11/28/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoVC.h"

@implementation LCUserInfoVC (MJRefresh)
- (void)addFooterRefersh{
    //添加上下拉刷新
    //设置上下拉刷新
    [self.wholeVerticalScrollView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)removeFooterRefersh{
    [self.wholeVerticalScrollView removeFooter];
}

- (void)hideFooterRefresh:(BOOL)hide{
    self.wholeVerticalScrollView.footerHidden = hide;
}

#pragma mark - MJRefresh Delegate
- (void)headerRereshing
{
    
}

- (void)footerRereshing
{
    if (self.showingPageType == UserInfoVC_InfoPage) {
        [self.wholeVerticalScrollView footerEndRefreshing];
    }else if(self.showingPageType == UserInfoVC_PlansPage){
        NSString *lastOrderTime = nil;
        if (self.plans && self.plans.count>0) {
            LCPlan *plan = [self.plans lastObject];
            lastOrderTime = plan.orderTime;
        }
        [self getPlansOfUser:self.userInfo.uuid fromOrderTime:lastOrderTime];
    }else if(self.showingPageType == UserInfoVC_AlbumPage){
        NSString *lastOrderTime = nil;
        if (self.photos && self.photos.count>0) {
            LCImageModel *imgModel = [self.photos lastObject];
            lastOrderTime = imgModel.timestamp;
        }
        [self getPhotosOfUser:self.userInfo.uuid fromOrderTime:lastOrderTime];
    }
}
@end
