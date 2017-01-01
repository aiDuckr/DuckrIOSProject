//
//  LCCostPlanDetailVC.h
//  LinkCity
//
//  Created by Roy on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCTextMessageToolBar.h"

#define COMMENT_BASE_PLACEHOLDER @"添加留言"
@interface LCCostPlanDetailVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *plan;

@property (nonatomic, strong) NSString *recmdUuid;
@property (nonatomic, assign) NSInteger defaultTabIndex;    //设置页面出现后的默认显示tab； 例如从用户评论点过来，应该默认显示评论Tab

//UI
@property (nonatomic, strong) LCShareView *shareView;
@property (nonatomic, strong) LCTextMessageToolBar *inputToolBar;
@property (nonatomic, assign) NSInteger replyCommentId;
@end

@interface LCCostPlanDetailVC (Comment)<LCTextMessageToolBarDelegate>
- (void)showInputToolBarWithPlaceHolder:(NSString *)placeHolder withReplyCommentId:(NSInteger)replyCommentId;
- (void)hideInputToolBar;
@end

@interface LCCostPlanDetailVC (Share)<LCShareViewDelegate>
- (void)sharePlan:(LCPlanModel *)plan;
@end