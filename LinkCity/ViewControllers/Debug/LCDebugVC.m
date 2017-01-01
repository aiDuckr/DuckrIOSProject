//
//  LCDebugVC.m
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCDebugVC.h"
#import "LCLogManager.h"
#import "LCRegisterAndLoginHelper.h"
#import "LCRecommendUserVC.h"
#import "LCAutoRefreshVC.h"
#import "LCSendFreePlanFinishVC.h"
#import "LCSendCostPlanFinishVC.h"
#import "LinkCity-Swift.h"


@interface LCDebugVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *cells;
@end

@implementation LCDebugVC

+ (instancetype)createInstance{
    return (LCDebugVC *)[LCStoryboardManager viewControllerWithFileName:SBNameDebug identifier:VCIDDebugVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Test Config";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normal"];
    
    self.cells = @[@"cancel",
                   @"send log",
                   @"log out",
                   @"login",
                   @"RecommendUser",
                   @"Test UMeng",
                   @"Use Debug Server",
                   @"Use Release Server",
                   @"show send free plan finish vc",
                   @"show send cost plan finish vc",
                   @"Search User",
                   @"Send Msg to Users",
                   [NSString stringWithFormat:@"Version: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    cell.textLabel.text = [self.cells objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = 0;
    
    if(indexPath.row == index++) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (indexPath.row == index++) {
        [[LCLogManager sharedInstance] sendLog];
    }else if(indexPath.row == index++) {
        [LCDataManager sharedInstance].userInfo = nil;
    }else if(indexPath.row == index++) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegister];
    }else if(indexPath.row == index++) {
        LCRecommendUserVC *recommendVC = [LCRecommendUserVC createInstance];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:recommendVC] animated:YES completion:nil];
    }else if(indexPath.row == index++) {
        [MobClick event:@"V3_Test"];
    }else if(indexPath.row == index++) {
        //use debug server
        
        [LCDataManager sharedInstance].useReleaseServerForDebug = NO;
        [[LCDataManager sharedInstance] saveData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(indexPath.row == index++) {
        //use release server
        
        [LCDataManager sharedInstance].useReleaseServerForDebug = YES;
        [[LCDataManager sharedInstance] saveData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(indexPath.row == index++) {
        LCSendFreePlanFinishVC *finishVC = [LCSendFreePlanFinishVC createInstance];
        LCPlanModel *plan = [[LCDataManager sharedInstance].joinedPlanArr firstObject];
        finishVC.plan = plan;
        [self.navigationController pushViewController:finishVC animated:YES];
    }else if(indexPath.row == index++){
        LCSendCostPlanFinishVC *finishVC = [LCSendCostPlanFinishVC createInstance];
        LCPlanModel *plan = [[LCDataManager sharedInstance].joinedPlanArr firstObject];
        finishVC.curPlan = plan;
        [self.navigationController pushViewController:finishVC animated:YES];
    }else if(indexPath.row == index++){
        [LCNetRequester searchUserByKeyWord:@"R" callBack:^(NSArray *userArray, NSError *error) {
            LCLogInfo(@"%@",userArray);
        }];
    }else if(indexPath.row == index++){
        LCSendMultiMsgVC *sendVC = [LCSendMultiMsgVC createInstance];
        [self.navigationController pushViewController:sendVC animated:YES];
    }
}

@end
