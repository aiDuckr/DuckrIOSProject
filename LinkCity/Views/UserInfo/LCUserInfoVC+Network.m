//
//  LCUserInfoVC+Network.m
//  LinkCity
//
//  Created by roy on 11/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoVC.h"
#import "LCCommonApi.h"

@implementation LCUserInfoVC (Network)
#pragma mark - Net Request
- (void)getUserInfo:(NSString *)userUUID{
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi getUserInfoWithUUID:userUUID];
}
- (void)getPlansOfUser:(NSString *)userUUID fromOrderTime:(NSString *)orderTime{
    self.lastGetPlanOrderTime = orderTime;
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi getParticipatedPlanListOfUser:userUUID orderTime:orderTime];
}
- (void)getPhotosOfUser:(NSString *)userUUID fromOrderTime:(NSString *)orderTime{
    self.lastGetPhotoOrderTime = orderTime;
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi getUserPhotosWithUUID:userUUID fromStartTime:orderTime];
}
- (void)addImageToUserAlbum{
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi addUserPhotoWithImageURL:self.imageURLOfQiNiu];
}
- (void)deleteImageFromUserAlbum:(NSString *)imageUrlMD5{
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi deletePhotoWithImageURLMD5:imageUrlMD5];
}

- (void)uploadImageToQiniu{
    LCCommonApi *api = [[LCCommonApi alloc] init];
    api.delegate = self;
    NSDictionary *dic = @{@"Type":[LCImageUtil getImageCategoryStringFromEnum:self.imageCategory]};
    [api getQiniuUploadToken:dic];
}


#pragma mark - LCCommonApi Delegate
- (void)commonApi:(LCCommonApi *)api didGetQiniuUploadToken:(NSString *)uploadToken picKey:(NSString *)key withError:(NSError *)error
{
    if (!error)
    {
        NSString *uploadTokenStr = uploadToken;
        NSString *picKey = key;
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:self.preprocessedData key:picKey
                     token:uploadTokenStr
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
         {
             RLog(@"the info is %@", info);
             RLog(@"the resp is %@", resp);
             self.imageURLOfQiNiu = [NSString stringWithFormat:@"%@%@", QINIU_DOMAIN, [resp objectForKey:@"key"]];
             RLog(@"upload url is %@", self.imageURLOfQiNiu);
             [self addImageToUserAlbum];
         }
                    option:nil];
    }
    else
    {
        [self hideHudInView];
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}

#pragma mark - UserApi Delegate
- (void)userApi:(LCUserApi *)userApi didGetUserInfo:(LCUserInfo *)userInfo withError:(NSError *)error{
    if (error) {
        RLog(@"did get userinfo %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"did get userinfo");
        if (!self.userInfo) {
            self.userInfo = userInfo;
        }else{
            [self.userInfo updateValueWithObject:userInfo];
        }
        [self updateShow];
        
        [self getPlansOfUser:self.userInfo.uuid fromOrderTime:nil];
        [self getPhotosOfUser:self.userInfo.uuid fromOrderTime:nil];
    }
}
- (void)userApi:(LCUserApi *)userApi didGetParticipatedPlanList:(NSArray *)planList withError:(NSError *)error{
    if (error) {
        RLog(@"did get participatedPlanList failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"get participated plan list succeed!");
        if ([LCStringUtil isNotNullString:self.lastGetPlanOrderTime]) {
            //加载更多，返回的
            if (self.plans && self.plans.count>0 && planList && planList.count>0) {
                self.plans = [self.plans arrayByAddingObjectsFromArray:planList];
            }
        }else{
            //新计划替换已加载的
            self.plans = planList;
        }
        [self.userPlanTableView reloadData];
        [self updatePageShowTo:self.showingPageType];
    }
    [self.wholeVerticalScrollView footerEndRefreshing];
}
- (void)userApi:(LCUserApi *)userApi didGetPhotos:(NSArray *)photos withError:(NSError *)error{
    if (error) {
        RLog(@"did get user photos failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"did get user photos succeed. ");
        if ([LCStringUtil isNotNullString:self.lastGetPhotoOrderTime]) {
            //加载更多，返回的
            if (self.photos && self.photos.count>0 && photos && photos.count>0) {
                self.photos = [self.photos arrayByAddingObjectsFromArray:photos];
            }
        }else{
            //新图片替换已加载图片
            self.photos = photos;
        }
        [self.userAlbumCollectionView reloadData];
        [self updatePageShowTo:self.showingPageType];
    }
    [self.wholeVerticalScrollView footerEndRefreshing];
}
- (void)userApi:(LCUserApi *)userApi didAddPhoto:(LCImageModel *)imgModel withError:(NSError *)error{
    [self hideHudInView];
    if (error) {
        RLog(@"add image to userAlbum failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        [MobClick event:MobEProfileAddPhoto];
        RLog(@"add image to userAlbum succeed!");
        NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
        [photos insertObject:imgModel atIndex:0];
        self.photos = photos;
        [self.userAlbumCollectionView reloadData];
        [self updatePageShowTo:self.showingPageType];
    }
}

- (void)userApi:(LCUserApi *)userApi didDeletePhotoWithError:(NSError *)error{
    if (error) {
        RLog(@"delete image from userAlbum failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"delete image from userAlbum succeed!");
        NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
        [photos removeObjectAtIndex:[self getPhotoIndexFromCollectionIndexPath:self.selectedIndexPath]];
        self.photos = photos;
        [self.userAlbumCollectionView reloadData];
        [self updatePageShowTo:self.showingPageType];
    }
}
@end
