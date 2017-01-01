//
//  LCPlanDetailUserVC.h
//  LinkCity
//
//  Created by 张宗硕 on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCTextMessageToolBar.h"

@interface LCFreePlanDetailVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) NSString *recmdUuid;
@property (nonatomic, strong) LCShareView *shareView;
@property (nonatomic, strong) LCTextMessageToolBar *inputToolBar;
@property (nonatomic, strong) UIView *inputContainer;
@property (nonatomic,assign) NSInteger replyCommentId;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (nonatomic, assign) BOOL cancelAutoRefreshOnce;   //为true时，refreshData不作处理，并把cancelAutoRefresh标记为false
+ (instancetype)createInstance;
@end

@interface LCFreePlanDetailVC (Comment)<LCTextMessageToolBarDelegate>
- (void)showInputToolBarWithPlaceHolder:(NSString *)placeHolder withReplyCommentId:(NSInteger)replyCommentId;
- (void)hideInputToolBar;
@end

@interface LCFreePlanDetailVC (Share)<LCShareViewDelegate>
- (void)sharePlan:(LCPlanModel *)plan;
@end