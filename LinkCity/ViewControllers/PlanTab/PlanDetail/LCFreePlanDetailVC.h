//
//  LCPlanDetailUserVC.h
//  LinkCity
//
//  Created by 张宗硕 on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

@interface LCFreePlanDetailVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) LCShareView *shareView;
@property (nonatomic, strong) LCTextMessageToolBar *inputToolBar;
@property (nonatomic, strong) UIView *inputContainer;
@property (nonatomic,assign) NSInteger replyCommentId;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
+ (instancetype)createInstance;
@end

@interface LCFreePlanDetailVC (Comment)<LCTextMessageToolBarDelegate>
- (void)showInputToolBarWithPlaceHolder:(NSString *)placeHolder withReplyCommentId:(NSInteger)replyCommentId;
- (void)hideInputToolBar;
@end

@interface LCFreePlanDetailVC (Share)<LCShareViewDelegate>
- (void)sharePlan:(LCPlanModel *)plan;
@end