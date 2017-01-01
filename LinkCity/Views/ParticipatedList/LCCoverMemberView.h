//
//  LCCoverMemberView.h
//  LinkCity
//
//  Created by roy on 11/15/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserInfo.h"

@class LCCoverMemberView;
@protocol LCCoverMemberViewDelegate <NSObject>
@required
- (void)talkButtonClicked;
- (void)coverMemberView:(LCCoverMemberView *)memberView didClickUserIndex:(NSInteger)userIndex;
@end

@interface LCCoverMemberView : UIView
@property (nonatomic, strong) NSArray *members; //按加入时间从早到晚的顺序
+ (instancetype)createInstance;
@property (nonatomic, strong) id<LCCoverMemberViewDelegate> delegate;
@end
