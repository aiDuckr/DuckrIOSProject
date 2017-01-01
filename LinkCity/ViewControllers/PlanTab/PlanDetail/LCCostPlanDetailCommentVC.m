//
//  LCCostPlanDetailCommentVC.m
//  LinkCity
//
//  Created by lhr on 16/6/8.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanDetailCommentVC.h"
#import "LCUserCommentCell.h"
@interface LCCostPlanDetailCommentVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSString *orderString;

@property (strong,nonatomic) NSArray *commentList;
@end

@implementation LCCostPlanDetailCommentVC


+ (instancetype)createInstance {
        return (LCCostPlanDetailCommentVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanDetail identifier:VCIDCostPlanDetailCommentVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}


- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserCommentCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderString = @"";
    //self.planOrderStr = @"";
    [self requestFromServer:self.orderString];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestFromServer:self.orderString];
}

- (void)requestFromServer:(NSString *)orderString {
     __weak typeof(self) weakSelf = self;
    [LCNetRequester getCommentOfPlan:self.planGuid corderString:orderString callBack:^(NSArray *commentArray, NSString *orderStr,NSError *error){
        //
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.orderString]) {
                if (nil != commentArray && commentArray.count > 0) {
                    weakSelf.commentList = commentArray;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有评价！"];
                }
            } else {
                if (nil != commentArray && commentArray.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:weakSelf.commentList];
                    [mutArr addObjectsFromArray:commentArray];
                    weakSelf.commentList = mutArr;
                    
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多评价"];
                }
            }
            weakSelf.orderString = orderStr;
            [weakSelf.tableView reloadData];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }

    }];
}



#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserCommentCell class])];
    [cell updateShowComment:self.commentList[indexPath.row] withType:LCUserCommentCellTypeScore];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
