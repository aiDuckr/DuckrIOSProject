//
//  MessageModel.m
//  YSChatInterface
//
//  Created by 张宗硕 on 11/18/14.
//  Copyright (c) 2014 yunshuo. All rights reserved.
//

#import "MessageModel.h"
#import "LCImageUtil.h"
#import "QNUploadManager.h"

@interface MessageModel()

@end

@implementation MessageModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.senderTelephone = [LCDataManager sharedInstance].userInfo.telephone;
        self.delegates = [[NSMutableArray alloc]initWithCapacity:0];
        self.msgUuid = [[NSUUID UUID] UUIDString];
    }
    
    return self;
}

- (void)dealloc{
    if (self.delegates) {
        [self.delegates removeAllObjects];
        self.delegates = nil;
    }
}

- (void)addMessageModelDelegate:(id<MessageModelDelegate>)aDelegate{
    if (aDelegate && self.delegates) {
        [self.delegates addObject:aDelegate];
    }
}
- (void)removeMessageModelDelegate:(id<MessageModelDelegate>)aDelegate{
    if (aDelegate && self.delegates) {
        [self.delegates removeObject:aDelegate];
    }
}

- (void)uploadModelImage
{
    NSData *imageData = [LCImageUtil getImageDataFromUIImage:self.image];
    [LCImageUtil uploadImageDataToQinu:imageData imageType:ImageCategoryChat completion:^(NSString *imgUrl) {
        if ([LCStringUtil isNullString:imgUrl]) {
            LCLogWarn(@"upload image failed");
        }else{
            LCLogInfo(@"upload image succeed %@",imgUrl);
            NSString *thumbImageURLStr = [NSString stringWithFormat:@"%@?imageView2/2/w/200", imgUrl];
            self.imageRemoteURL = [NSURL URLWithString:imgUrl];
            self.thumbnailRemoteURL = [NSURL URLWithString:thumbImageURLStr];
            
            for (id<MessageModelDelegate> aDelegate in self.delegates){
                if ([aDelegate respondsToSelector:@selector(uploadImageFinished:)]) {
                    [aDelegate uploadImageFinished:self];
                }
            }
        }
    }];
}
@end

