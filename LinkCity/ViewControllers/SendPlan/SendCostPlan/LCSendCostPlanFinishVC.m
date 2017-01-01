//
//  LCSendCostPlanFinishVC.m
//  LinkCity
//
//  Created by Roy on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendCostPlanFinishVC.h"
#import "LinkCity-Swift.h"

@interface LCSendCostPlanFinishVC ()<LCShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (nonatomic, strong) LCShareView *shareView;

@property (nonatomic, assign) BOOL haveGetRoomOnline;
@property (nonatomic, assign) BOOL haveShownCarIdAlert;
@end

@implementation LCSendCostPlanFinishVC

+ (instancetype)createInstance{
    return (LCSendCostPlanFinishVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendCostPlanFinishVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布成功";
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PlanDetailGrayShareIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnAction:)];
    self.navigationItem.rightBarButtonItem = shareBarBtn;
    
    self.finishBtn.layer.masksToBounds = YES;
    self.finishBtn.layer.cornerRadius = 3;
    self.finishBtn.layer.borderWidth = 1;
    self.finishBtn.layer.borderColor = UIColorFromRGBA(0xd9d3c9, 1).CGColor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.haveGetRoomOnline) {
        /// 发一条群聊消息 ---期间会get room online.
        NSString *systemMsg = [LCUIConstants getJoinPlanMessageWithUserNick:[LCDataManager sharedInstance].userInfo.nick];
        [[LCXMPPMessageHelper sharedInstance] sendChatSystemInfo:systemMsg toBareJidString:self.curPlan.roomId isGroup:YES];
        
        self.haveGetRoomOnline = YES;
    }
    
    /*如果没弹过车辆认证
     且发的收费或免费拼车邀约
     且车辆没认证过或者认证失败
     */
    if (!self.haveShownCarIdAlert &&
        ([self.curPlan isCostCarryPlan] || [self.curPlan isFreeCarryPlan]) &&
        ([LCDataManager sharedInstance].userInfo.isCarVerify == LCIdentityStatus_None ||
         [LCDataManager sharedInstance].userInfo.isCarVerify == LCIdentityStatus_Failed)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [LCDialogHelper showOneBtnDialogHideCancelBtn:NO dismissOnBgTouch:NO iconImageName:@"CarIconGray" title:@"认证车辆信息" msg:@"会提高90%的拼车邀约成功率" miniBtnTitle:nil btnTitle:@"去认证" cancelBtnCallBack:^{
                    [LCDialogHelper dismissDialog];
                } miniBtnCallBack:^{
                    [LCDialogHelper dismissDialog];
                } submitBtnCallBack:^{
                    [LCDialogHelper dismissDialog];
                    
                    [[LCUserIdentityHelper sharedInstance] startCarIdentityWithUser:[LCDataManager sharedInstance].userInfo fromVC:self];
                }];
            });
            self.haveShownCarIdAlert = YES;
            
            
            
            
        }
}

#pragma mark ButtonAction
- (void)shareBtnAction:(id)sender{
    [self sharePlan:self.curPlan];
}

- (IBAction)finishBtnAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SharePlan
- (void)sharePlan:(LCPlanModel *)plan{
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        [self.shareView setShareToDuckrHiden:NO];
        self.shareView.delegate = self;
    }
    [LCShareView showShareView:self.shareView onViewController:self forPlan:plan];
}

#pragma mark - LCShareViewDelegate
- (void)cancelShareAction
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){}];
}
- (void)shareWeixinAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinAction:plan presentedController:self];
    }];
}

- (void)shareWeixinTimeLineAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinTimeLineAction:plan presentedController:self];
    }];
}

- (void)shareWeiboAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeiboAction:plan presentedController:self];
    }];
}

- (void)shareQQAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareQQAction:plan presentedController:self];
    }];
}

- (void)shareDuckrAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareDuckrAction:plan presentedController:self];
    }];
}



@end
