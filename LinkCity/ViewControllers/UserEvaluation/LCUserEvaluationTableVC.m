//
//  LCUserEvaluationTableVC.m
//  LinkCity
//
//  Created by roy on 3/21/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserEvaluationTableVC.h"
#import "LCUserEvaluationModel.h"
#import "LCUserEvaluationCell.h"

@interface LCUserEvaluationTableVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *evaluationArray;    //array of LCUserEvaluationModel
@property (nonatomic, strong) NSString *orderStr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LCUserEvaluationTableVC

+ (instancetype)createInstance{
    return (LCUserEvaluationTableVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserEvaluationTableVC];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserEvaluationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserEvaluationCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}


- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow{
    [self.tableView reloadData];
}

- (void)requestUserEvaluationFromOrderString:(NSString *)orderString{
    [LCNetRequester getEvaluationForUser:self.user.uUID orderStr:orderString callBack:^(NSArray *evaluationArray, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            if ([LCStringUtil isNullString:self.orderStr]) {
                //下拉刷新
                self.evaluationArray = [NSMutableArray arrayWithArray:evaluationArray];
            }else{
                //上拉加载更多
                if (!evaluationArray || evaluationArray.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.evaluationArray) {
                        self.evaluationArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [self.evaluationArray addObjectsFromArray:evaluationArray];
                }
            }
            self.orderStr = orderStr;
            [self updateShow];
        }
        
    }];
}


#pragma mark -
#pragma mark MJRefresh
- (void)headerRereshing{
    self.orderStr = nil;
    [self requestUserEvaluationFromOrderString:nil];
}

- (void)footerRereshing{
    [self requestUserEvaluationFromOrderString:self.orderStr];
}


#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.evaluationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserEvaluationCell *evaluationCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserEvaluationCell class]) forIndexPath:indexPath];
    LCUserEvaluationModel *anEvaluation = [self.evaluationArray objectAtIndex:indexPath.row];
    evaluationCell.userEvaluation = anEvaluation;
    return evaluationCell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    LCUserEvaluationModel *anEvaluation = [self.evaluationArray objectAtIndex:indexPath.row];
    height = [LCUserEvaluationCell getCellHeightForEvaluation:anEvaluation];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCUserEvaluationModel *anEvaluation = [self.evaluationArray objectAtIndex:indexPath.row];
    if ([LCStringUtil isNotNullString:anEvaluation.evaluationUuid]) {
        LCUserModel *user = [[LCUserModel alloc] init];
        user.uUID = anEvaluation.evaluationUuid;
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
    }
}




@end
