//
//  LCRedDotModel.h
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCRedDotModel : LCBaseModel
@property (assign, nonatomic) NSInteger msgNum;     //!> 消息Tab的通知数
@property (assign, nonatomic) NSInteger myselfNum;     //!> 我的Tab的通知数
@property (assign, nonatomic) NSInteger tourpicNum;     //!> 旅图新消息数
@property (assign, nonatomic) NSInteger evalNum;     //!> 我的Tab里面待评价通知数
@property (assign, nonatomic) NSInteger payNum;     //!> 我的Tab里面待付款通知数
@property (assign, nonatomic) NSInteger focusNum;     //!> 消息Tab里面我的关注的通知数
@property (assign, nonatomic) NSInteger notifyNum;     //!> 消息Tab里面通知数
@property (strong, nonatomic) NSString *focusTime;     //!> 我的关注右上角的时间
@property (strong, nonatomic) NSString *focusContent;     //!> 我的关注最后一条消息的内容
@property (strong, nonatomic) NSString *notifyTime;     //!> 通知右上角的时间
@property (strong, nonatomic) NSString *notifyContent;     //!> 通知的最后一条消息的内容
@property (assign, nonatomic) NSInteger unRefundNum;     //!> 通知的最后一条消息的内容
@property (assign, nonatomic) NSInteger localLeisureNum;     //!> 同城有空数目
@end
