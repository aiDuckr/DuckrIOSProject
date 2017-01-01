//
//  LCUserInfo+ScrollView.m
//  LinkCity
//
//  Created by roy on 12/6/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoVC.h"

@implementation LCUserInfoVC (ScrollView)

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //switch page - userinfo - plans - album
    if (scrollView == self.pageHorizontalScrollView) {
        float viewWidth = scrollView.frame.size.width;
        float offsetX = scrollView.contentOffset.x;
        if (offsetX<viewWidth) {
            [MobClick event:MobEProfileInfo];
            [self updatePageShowTo:UserInfoVC_InfoPage];
        }else if(offsetX>=viewWidth && offsetX<viewWidth*2){
            [MobClick event:MobEProfilePlan];
            [self updatePageShowTo:UserInfoVC_PlansPage];
        }else if(offsetX>=viewWidth*2 && offsetX<viewWidth*3){
            [MobClick event:MobEProfilePhoto];
            [self updatePageShowTo:UserInfoVC_AlbumPage];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.wholeVerticalScrollView) {
        if (scrollView.contentOffset.y >= self.buttonsContainerViewTop) {
            //Tab置顶后，固定显示Tab
            self.navBarView.hidden = YES;
            self.topCoverView.hidden = YES;
            self.buttonsContainerViewTopConstraint.constant = scrollView.contentOffset.y-20-self.buttonsContainerViewTop;
        }else{
            //Tab置顶前，随着滑动
            self.buttonsContainerViewTopConstraint.constant = -20;
            self.navBarView.hidden = NO;
            self.topCoverView.hidden = NO;
            self.navBarView.alpha = 1-scrollView.contentOffset.y/self.buttonsContainerViewTop;
            self.topCoverView.alpha = 1-scrollView.contentOffset.y/self.buttonsContainerViewTop;
        }
        //NSLog(@"contentOffset:%f,%f,%f",scrollView.contentOffset.y,self.buttonsContainerViewTop ,self.buttonsContainerViewTopConstraint.constant);
    }
}

@end
