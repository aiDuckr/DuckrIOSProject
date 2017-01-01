//
//  LCTourpic.m
//  LinkCity
//
//  Created by 张宗硕 on 3/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpic.h"
#import "LCTourpicComment.h"
#import "LCPhoneContactorModel.h"

@implementation LCTourpic

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.guid = [LCStringUtil getNotNullStr:[dic objectForKey:@"Guid"]];
        
        self.commentNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"CommentNum"]];
        self.likeNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"LikeNum"]];
        self.forwardNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"ForwardNum"]];
        self.isLike = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsLike"]];
        self.placeName = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceName"]];
        self.desc = [LCStringUtil getNotNullStr:[dic objectForKey:@"Description"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.shareTitle = [LCStringUtil getNotNullStr:[dic objectForKey:@"ShareTitle"]];
        self.shareUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"ShareUrl"]];
        if ([LCStringUtil isNotNullString:[dic objectForKey:@"CreaterUser"]]) {
            self.user = [[LCUserModel alloc] initWithDictionary:[dic objectForKey:@"CreaterUser"]];
        }
        self.picUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"PicUrl"]];
        self.thumbPicUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"ThumbPicUrl"]];
        
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        NSArray *likedArr = [dic objectForKey:@"LikedList"];
        if (nil != likedArr && likedArr.count > 0) {
            for (NSDictionary *likedDic in likedArr) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:likedDic];
                [mutArr addObject:user];
            }
        }
        self.likedArr = [[NSArray alloc] initWithArray:mutArr];
        
        mutArr = [[NSMutableArray alloc] init];
        NSArray *commentArr = [dic objectForKey:@"CommentList"];
        if (nil != commentArr && commentArr.count > 0) {
            for (NSDictionary *commentDic in commentArr) {
                LCTourpicComment *comment = [[LCTourpicComment alloc] initWithDictionary:commentDic];
                [mutArr addObject:comment];
            }
        }
        self.commentArr = [[NSArray alloc] initWithArray:mutArr];
        
        mutArr = [[NSMutableArray alloc] init];
        NSArray *companyArr = [dic objectForKey:@"CompanyList"];
        if (nil != companyArr && companyArr.count > 0) {
            for (NSDictionary *companyDic in companyArr) {
                LCPhoneContactorModel *company = [[LCPhoneContactorModel alloc] initWithDictionary:companyDic];
                [mutArr addObject:company];
            }
        }
        self.companyArr = [[NSArray alloc] initWithArray:mutArr];
        self.photoUrls = [dic objectForKey:@"PhotoUrls"];
        self.thumbPhotoUrls = [dic objectForKey:@"ThumbPhotoUrls"];
        self.photoNum = self.thumbPhotoUrls.count;
        self.type = [[LCStringUtil getNotNullStr:[dic objectForKey:@"Type"]] integerValue];
        self.distance = [[LCStringUtil getNotNullStr:[dic objectForKey:@"Distance"]] integerValue];
        self.coverWidth = [[LCStringUtil getNotNullStr:[dic objectForKey:@"CoverWidth"]] integerValue];
        if (0 == self.coverWidth) {
            self.coverWidth = 200;
        }
        if (0 == self.coverHeight) {
            self.coverHeight = 200;
        }
        self.coverHeight = [[LCStringUtil getNotNullStr:[dic objectForKey:@"CoverHeight"]] integerValue];
        self.newOrHotType = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsNewOrHot"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.guid forKey:@"Guid"];
    [coder encodeObject:self.picUrl forKey:@"PicUrl"];
    [coder encodeObject:self.thumbPicUrl forKey:@"ThumbPicUrl"];
    [coder encodeInteger:self.commentNum forKey:@"CommentNum"];
    [coder encodeInteger:self.likeNum forKey:@"LikeNum"];
    [coder encodeInteger:self.forwardNum forKey:@"ForwardNum"];
    [coder encodeInteger:self.isLike forKey:@"IsLike"];
    [coder encodeObject:self.placeName forKey:@"PlaceName"];
    [coder encodeObject:self.desc forKey:@"Description"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.shareTitle forKey:@"ShareTitle"];
    [coder encodeObject:self.shareUrl forKey:@"ShareUrl"];
    if (nil != self.user) {
        [coder encodeObject:self.user forKey:@"User"];
    }
    [coder encodeObject:self.likedArr forKey:@"LikeArr"];
    [coder encodeObject:self.commentArr forKey:@"CommentArr"];
    [coder encodeObject:self.companyArr forKey:@"CompanyArr"];
    [coder encodeObject:self.photoUrls forKey:@"PhotoUrls"];
    [coder encodeObject:self.thumbPhotoUrls forKey:@"ThumbPhotoUrls"];
    [coder encodeInteger:self.type forKey:@"Type"];
    [coder encodeInteger:self.distance forKey:@"Distance"];
    [coder encodeInteger:self.photoNum forKey:@"PhotoNum"];
    [coder encodeInteger:self.coverWidth forKey:@"CoverWidth"];
    [coder encodeInteger:self.coverHeight forKey:@"CoverHeight"];
    [coder encodeInteger:self.newOrHotType forKey:@"IsNewOrHot"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.guid = [coder decodeObjectForKey:@"Guid"];
        self.picUrl = [coder decodeObjectForKey:@"PicUrl"];
        self.thumbPicUrl = [coder decodeObjectForKey:@"ThumbPicUrl"];
        self.commentNum = [coder decodeIntegerForKey:@"CommentNum"];
        self.likeNum = [coder decodeIntegerForKey:@"LikeNum"];
        self.forwardNum = [coder decodeIntegerForKey:@"ForwardNum"];
        self.isLike = [coder decodeIntegerForKey:@"IsLike"];
        self.placeName = [coder decodeObjectForKey:@"PlaceName"];
        self.desc = [coder decodeObjectForKey:@"Description"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.shareTitle = [coder decodeObjectForKey:@"ShareTitle"];
        self.shareUrl = [coder decodeObjectForKey:@"ShareUrl"];
        self.user = [coder decodeObjectForKey:@"User"];
        self.commentArr = [coder decodeObjectForKey:@"CommentArr"];
        self.companyArr = [coder decodeObjectForKey:@"CompanyArr"];
        self.photoUrls = [coder decodeObjectForKey:@"PhotoUrls"];
        self.thumbPhotoUrls = [coder decodeObjectForKey:@"ThumbPhotoUrls"];
        self.type = [coder decodeIntegerForKey:@"Type"];
        self.distance = [coder decodeIntegerForKey:@"Distance"];
        self.photoNum = [coder decodeIntegerForKey:@"PhotoNum"];
        self.coverWidth = [coder decodeIntegerForKey:@"CoverWidth"];
        self.coverHeight = [coder decodeIntegerForKey:@"CoverHeight"];
        self.newOrHotType = [coder decodeIntegerForKey:@"IsNewOrHot"];
    }
    return self;
}

@end