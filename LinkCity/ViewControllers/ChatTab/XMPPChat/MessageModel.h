//
//  MessageModel.h
//  YSChatInterface
//
//  Created by 张宗硕 on 11/18/14.
//  Copyright (c) 2014 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPlanModel.h"
#import "EMChatServiceDefs.h"

@class MessageModel;

@protocol MessageModelDelegate <NSObject>
@optional
- (void)uploadImageFinished:(MessageModel *)model;

@end



@interface MessageModel : NSObject

- (void)uploadModelImage;

@property (nonatomic, assign) MessageBodyType type;
@property (nonatomic, assign) MessageDeliveryState status;

/// 信息的唯一id.
@property (nonatomic, retain) NSString *msgUuid;    //创建新计划时，创建唯一码
@property (nonatomic) BOOL isSender;    //是否是发送者
@property (nonatomic) BOOL isRead;      //是否已读
@property (nonatomic) BOOL isChatGroup;  //是否是群聊

@property (nonatomic, strong) NSDate *sendDate; //该消息发送时的时间

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSURL *headImageURL;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *username;       //显示在群聊的聊天详情中，每句话的上边
@property (nonatomic, strong) NSString *senderTelephone;  //current user's telephone

//text
@property (nonatomic, strong) NSString *content;

//image
@property (nonatomic) CGSize size;
@property (nonatomic) CGSize thumbnailSize;
@property (nonatomic, strong) NSURL *imageRemoteURL;    //the url of the Image on QiNiu
@property (nonatomic, strong) NSURL *thumbnailRemoteURL;//the url of the Thumbnail Image on QiNiu
@property (nonatomic, strong) UIImage *image;           //the image user picked
@property (nonatomic, strong) UIImage *thumbnailImage;  //the thumbnail image

//location | checkin
@property (nonatomic, strong) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

/// LCPlan
@property (nonatomic, retain) LCPlanModel *plan;

/// voice
@property (nonatomic, retain) NSString *voice;

/// an array of delegates
/// unit type is  id<MessageModelDelegate>
@property (nonatomic, retain) NSMutableArray *delegates;


//User to send message
@property (nonatomic, strong) NSString *toJidStr;   //发送目标的Jid
@property (nonatomic, strong) NSString *infoStr;    //发送消息时的info字段

- (void)addMessageModelDelegate:(id<MessageModelDelegate>)aDelegate;
- (void)removeMessageModelDelegate:(id<MessageModelDelegate>)aDelegate;

@end
