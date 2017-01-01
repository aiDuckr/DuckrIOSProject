//
//  LCSendPlanBaseVC.m
//  LinkCity
//
//  Created by roy on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSendPlanBaseVC.h"

@interface LCSendPlanBaseVC ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIAlertView *cancelSendAlertView;
@property (nonatomic, strong) UIAlertView *cancelModifyAlertView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation LCSendPlanBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isSendingPlan) {
        //创建
        self.title = @"发布邀约";
    } else {
        //编辑已发布计划
        self.title = @"修改邀约信息";
    }
}

#pragma mark Set&Get
- (LCPlanModel *)curPlan {
    
    if (self.isSendingPlan) {
        return [LCDataManager sharedInstance].sendingPlan;
    } else {
        return [LCDataManager sharedInstance].modifyingPlan;
    }
}

- (void)setCurPlan:(LCPlanModel *)curPlan {
    if (self.isSendingPlan) {
        [LCDataManager sharedInstance].sendingPlan = curPlan;
    }else{
        [LCDataManager sharedInstance].modifyingPlan = curPlan;
    }
}

- (void)cancelSendPlan{
    if (self.isSendingPlan) {
        //创建
//        if (!self.curPlan.isProvideTourGuide &&
//            (!self.curPlan.tourThemes || self.curPlan.tourThemes<=0) &&
//            (!self.curPlan.destinationNames || self.curPlan.destinationNames.count<=0) &&
//            [LCStringUtil isNullString:self.curPlan.startTime] &&
//            [LCStringUtil isNullString:self.curPlan.endTime] &&
//            [LCStringUtil isNullString:self.curPlan.descriptionStr] &&
//            self.curPlan.userRouteId < 0) {
//            //非付费邀约，并且还没有编辑过计划，直接退出
//            
//            if ([[[self.navigationController childViewControllers] lastObject] isEqual:self]) {
//                 [self.navigationController popToRootViewControllerAnimated:NO];
//            } else {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }
//            
//            return;
//        }
        
        //编辑过计划，进行提示保存草稿的流程
        self.cancelSendAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"对于已经编辑的内容:" delegate:self cancelButtonTitle:@"删除草稿" otherButtonTitles:@"保存草稿", nil];
        [self.cancelSendAlertView show];
    }else{
        //编辑已发布计划
        self.cancelSendAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否放弃目前的修改并退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [self.cancelSendAlertView show];
    }
    
    [self addTapGesture];
}

- (void)mergeUIDataIntoModel{
    NSAssert(NO, @"sub class of LCSendPlanBaseVC should override 'mergeUIDataIntoModel'");
}

- (void)addTapGesture{
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    self.tapGesture.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:self.tapGesture];
}
- (void)removeTapGesture{
    [self.tapGesture removeTarget:self action:@selector(didTap:)];
    [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:self.tapGesture];
}

#pragma mark Button Action
- (void)didTap:(id)sender{
    if (self.cancelModifyAlertView) {
        [self.cancelModifyAlertView dismissWithClickedButtonIndex:-1 animated:YES];
    }
    
    if (self.cancelSendAlertView) {
        [self.cancelSendAlertView dismissWithClickedButtonIndex:-1 animated:YES];
    }
    
    [self removeTapGesture];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self removeTapGesture];
    
    if (alertView == self.cancelSendAlertView) {
        if (buttonIndex == 1) {
            // 存草稿
            [self mergeUIDataIntoModel];
            if ([[[self.navigationController childViewControllers] lastObject] isEqual:self]) {
                 [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //[self dismissViewControllerAnimated:YES completion:nil];
        }else if(buttonIndex == 0){
            [LCDataManager sharedInstance].sendingPlan = nil;
            [LCDataManager sharedInstance].modifyingPlan = nil;

            if ([[[self.navigationController childViewControllers] lastObject] isEqual:self]) {
                 [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //[self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if(alertView == self.cancelModifyAlertView) {
        if (buttonIndex == 0) {
            
        }else if(buttonIndex == 1){
            if ([[[self.navigationController childViewControllers] lastObject] isEqual:self]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }//[self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


@end
