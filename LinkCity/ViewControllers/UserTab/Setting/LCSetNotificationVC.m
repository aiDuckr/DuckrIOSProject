//
//  LCSetNotificationVC.m
//  LinkCity
//
//  Created by roy on 3/24/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSetNotificationVC.h"

@interface LCSetNotificationVC ()
@property (weak, nonatomic) IBOutlet UISwitch *planCommentSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *planApplySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tourPicPriseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tourPicCommentSwitch;

//@property (weak, nonatomic) IBOutlet UISwitch *isEvaluatedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *identifySwitch;



@end

@implementation LCSetNotificationVC

+ (instancetype)createInstance{
    return (LCSetNotificationVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSetting identifier:VCIDSetNotificationVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)updateShow {
    self.planCommentSwitch.on = [LCDataManager sharedInstance].appInitData.userNotify.notifPlanComment;
//    self.planApplySwitch.on = [LCDataManager sharedInstance].appInitData.userNotify.notifPlanApply;
    self.tourPicPriseSwitch.on = [LCDataManager sharedInstance].appInitData.userNotify.notifTourpicLike;
    self.tourPicCommentSwitch.on = [LCDataManager sharedInstance].appInitData.userNotify.notifTourPicComment;
    
//    self.isEvaluatedSwitch.on = [LCDataManager sharedInstance].appInitData.userNotify.notifUserEvaluation;
    self.identifySwitch.on = [LCDataManager sharedInstance].appInitData.userNotify.notifUserIdentity;
}

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender == self.planCommentSwitch) {
        [LCDataManager sharedInstance].appInitData.userNotify.notifPlanComment = sender.on?1:0;
    } else if(sender == self.tourPicPriseSwitch) {
        [LCDataManager sharedInstance].appInitData.userNotify.notifTourpicLike = sender.on?1:0;
    } else if(sender == self.tourPicCommentSwitch) {
        [LCDataManager sharedInstance].appInitData.userNotify.notifTourPicComment = sender.on?1:0;
    } else if(sender == self.identifySwitch) {
        [LCDataManager sharedInstance].appInitData.userNotify.notifUserIdentity = sender.on?1:0;
    }
    
    sender.enabled = NO;
    [LCNetRequester setNotify:[LCDataManager sharedInstance].appInitData.userNotify callBack:^(LCUserNotifyModel *notifyModel, NSError *error) {
        sender.enabled = YES;
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            
            //把值变成操作前的状态
            sender.on = !sender.on;
            if (sender == self.planCommentSwitch) {
                [LCDataManager sharedInstance].appInitData.userNotify.notifPlanComment = sender.on?1:0;
            } else if(sender == self.tourPicPriseSwitch) {
                [LCDataManager sharedInstance].appInitData.userNotify.notifTourpicLike = sender.on?1:0;
            } else if(sender == self.tourPicCommentSwitch) {
                [LCDataManager sharedInstance].appInitData.userNotify.notifTourPicComment = sender.on?1:0;
            } else if(sender == self.identifySwitch) {
                [LCDataManager sharedInstance].appInitData.userNotify.notifUserIdentity = sender.on?1:0;
            }
        }else{
            
        }
    }];
}




@end
