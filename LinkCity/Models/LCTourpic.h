//
//  LCTourpic.h
//  LinkCity
//
//  Created by 张宗硕 on 3/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    LCTourpicLike_IsUnlike = 1,
    LCTourpicLike_IsLike = 2,
} LCTourpicLike;

typedef enum : NSInteger {
    LCTourpicType_Photo = 0,
    LCTourpicType_Video = 1,
} LCTourpicType;

typedef enum : NSInteger {
    LCTourpicCellViewType_Cell = 0,
    LCTourpicCellViewType_Detail = 1,
    LCTourpicCellViewType_Homepage = 2,
    LCTourpicCellViewType_FocusCell = 3,
} LCTourpicCellViewType;

typedef enum : NSInteger {
    LCTourpicNewOrHotType_Default = 0,
    LCTourpicNewOrHotType_New = 1,
    LCTourpicNewOrHotType_Hot = 10,
} LCTourpicNewOrHotType;

@interface LCTourpic : LCBaseModel

@property (retain, nonatomic) NSString *guid;
@property (retain, nonatomic) NSString *picUrl;
@property (retain, nonatomic) NSString *thumbPicUrl;
@property (assign, nonatomic) NSInteger commentNum;
@property (assign, nonatomic) NSInteger likeNum;
@property (assign, nonatomic) NSInteger forwardNum;
@property (assign, nonatomic) NSInteger isLike;
@property (retain, nonatomic) NSString *placeName;
@property (retain, nonatomic) NSString *desc;
@property (retain, nonatomic) NSString *createdTime;
@property (retain, nonatomic) NSString *shareTitle;
@property (retain, nonatomic) NSString *shareUrl;
@property (retain, nonatomic) LCUserModel *user;
@property (retain, nonatomic) NSArray *likedArr;
@property (retain, nonatomic) NSArray *commentArr;
@property (retain, nonatomic) NSArray *companyArr;
@property (retain, nonatomic) NSArray *photoUrls;
@property (retain, nonatomic) NSArray *thumbPhotoUrls;
@property (assign, nonatomic) LCTourpicType type;
@property (assign, nonatomic) NSInteger distance;
@property (assign, nonatomic) NSInteger photoNum;
@property (assign, nonatomic) NSInteger coverWidth;
@property (assign, nonatomic) NSInteger coverHeight;
@property (assign, nonatomic) LCTourpicNewOrHotType newOrHotType;
@end
