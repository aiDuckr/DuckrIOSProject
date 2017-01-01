//
//  LCChargeForAStageVC.m
//  LinkCity
//
//  Created by Roy on 9/1/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCChargeForAStageVC.h"
#import "LCChargeDetailTitleCell.h"
#import "LCChargeDetailStageCell.h"
#import "LCChargeDetailTipCell.h"
#import "LCChargeDetailUserCell.h"

@interface LCChargeForAStageVC ()<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic, strong) LCPlanModel *plan;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LCChargeForAStageVC
+ (instancetype)createInstance{
    return (LCChargeForAStageVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanDetail identifier:NSStringFromClass([LCChargeForAStageVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)refreshData{
    
}

- (void)updateShow{
    if (self.stage) {
        self.title = [self.stage getDepartTimeStr];
    }else{
        self.title = @"报名详情";
    }
    
    [self.tableView reloadData];
}



#pragma mark Button Action
- (IBAction)copyButtonAction:(id)sender {
    [YSAlertUtil showHudWithHint:nil inView:[UIApplication sharedApplication].delegate.window enableUserInteraction:YES];
    [LCNetRequester getPlanDetailFromPlanGuid:self.stage.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            /* copy string template:
             北京-天津-大连，2015.2.22出发，已支付7人付款：
             1、牛思月 等3人 支付订金￥60.00 【付款码EIG5431】电话15201312374 【其他联系人】张月：13830154325，张思：13453426543
             2、张若宇 支付全款￥20.00 【付款码EIG5431】电话15201312374
             3、牛思月 等2人 支付全款￥40.00 【付款码EIG5431】电话15201312374
             */
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *str = @"";
            if ([LCStringUtil isNotNullString:plan.departName]) {
                str = [str stringByAppendingString:plan.departName];
                str = [str stringByAppendingString:@"-"];
            }
            str = [str stringByAppendingString:[plan getDestinationsStringWithSeparator:@"-"]];
            str = [str stringByAppendingFormat:@"，%@出发，",[LCDateUtil getDotDateFromHorizontalLineStr:plan.startTime]];
            str = [str stringByAppendingFormat:@"已支付%ld人：",(long)plan.totalOrderNumber];
            
            NSInteger orderIndex = 1;
            NSString *orderStr = @"";
            for (int i=1; i<plan.memberList.count; i++){
                LCUserModel *user = plan.memberList[i];
                if (user.partnerOrder) {
                    LCPartnerOrderModel *orderToUse = user.partnerOrder;
                    
                    NSString *firstUserName = user.nick;
                    NSString *firstUserPhone = user.telephone;
                    if (orderToUse.orderContactNameArray.count > 0 &&
                        orderToUse.orderContactPhoneArray.count > 0) {
                        firstUserName = [orderToUse.orderContactNameArray firstObject];
                        firstUserPhone = [orderToUse.orderContactPhoneArray firstObject];
                    }
                    
                    orderStr = [NSString stringWithFormat:@"\r\n%ld、%@",(long)orderIndex++,firstUserName];
                    if (user.partnerOrder.orderNumber > 1) {
                        orderStr = [orderStr stringByAppendingFormat:@" 等%ld人",(long)orderToUse.orderNumber];
                    }
                    
                    if ([user paidTail]) {
                        orderStr = [orderStr stringByAppendingFormat:@" 支付全款￥%@ 【付款码%@】电话%@",[orderToUse getTotalPrice],orderToUse.orderCode,firstUserPhone];
                    }else if([user paidEarnest]) {
                        orderStr = [orderStr stringByAppendingFormat:@" 支付订金￥%@ 【付款码%@】电话%@",[orderToUse getTotalEarnest],orderToUse.orderCode,firstUserPhone];
                    }
                    
                    if (orderToUse.orderContactNameArray.count > 1 &&
                        orderToUse.orderContactNameArray.count == orderToUse.orderContactPhoneArray.count) {
                        orderStr = [orderStr stringByAppendingString:@"【其他联系人】"];
                        for (int i=1; i<orderToUse.orderContactNameArray.count; i++){
                            orderStr = [orderStr stringByAppendingFormat:@"%@:%@",[orderToUse.orderContactNameArray objectAtIndex:i], [orderToUse.orderContactPhoneArray objectAtIndex:i]];
                            if (i < orderToUse.orderContactNameArray.count - 1) {
                                orderStr = [orderStr stringByAppendingString:@","];
                            }
                        }
                    }
                    
                    str = [str stringByAppendingString:orderStr];
                }
            }
            
            [pasteboard setString:str];
            
            [YSAlertUtil tipOneMessage:@"已复制支付名单" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }];
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (self.stage.member.count <= 1) {
        rowNum = 1;
    }else{
        rowNum = self.stage.member.count + 1;    // 一个titleCell 不显示planCreater & lastTipCell
    }
    
    return rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        LCChargeDetailTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCChargeDetailTitleCell class]) forIndexPath:indexPath];
        [titleCell updateShowWithStage:self.stage];
        cell = titleCell;
    }else if(indexPath.row > 0 && indexPath.row < self.stage.member.count){
        
        NSInteger userIndex = indexPath.row - 1 + 1; // 减去titleCell 加1是为了不显示plan creater
        BOOL isLastUser = (userIndex == (self.stage.member.count-1) ? YES : NO);
        LCChargeDetailUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCChargeDetailUserCell class]) forIndexPath:indexPath];
        [userCell updateShowWithUser:self.stage.member[userIndex] isLastCell:isLastUser];
        
        cell = userCell;
    }else if(indexPath.row == self.stage.member.count){
        //tip cell
        LCChargeDetailTipCell *tipCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCChargeDetailTipCell class])];
        cell = tipCell;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        height = [LCChargeDetailTitleCell getCellHeightWhetherShowMemberTitle:YES];
    }else if(indexPath.row > 0 && indexPath.row < self.stage.member.count){
        
        NSInteger userIndex = indexPath.row - 1 + 1; // 减去titleCell 加1是为了不显示plan creater
        height = [LCChargeDetailUserCell getCellHeightForUser:self.stage.member[userIndex]];
    }else if(indexPath.row == self.stage.member.count){
        height = [LCChargeDetailTipCell getCellHeight];
    }
    
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger userIndex = indexPath.row - 1 + 1;
    if (userIndex > 0 && userIndex < self.stage.member.count) {
        LCUserModel *user = [self.stage.member objectAtIndex:userIndex];
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
    }
}




@end
