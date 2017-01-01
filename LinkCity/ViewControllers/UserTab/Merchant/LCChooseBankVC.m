//
//  LCChooseBankVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCChooseBankVC.h"

@interface LCChooseBankVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *hotBankArr;
@property (strong, nonatomic) NSArray *letterBankArr;
@end

@implementation LCChooseBankVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCChooseBankVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDChooseBankVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self headerRefreshAction];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollsToTop = YES;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)updateShow {
    [self.tableView reloadData];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    [self requestWithdrawList];
}

- (void)requestWithdrawList {
    [LCNetRequester requestMerchantBankWithcallBack:^(NSArray *hotBankArr, NSArray *letterBankArr, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (!error) {
            if ((nil != hotBankArr && hotBankArr.count > 0) || (nil != letterBankArr && letterBankArr.count > 0)) {
                self.hotBankArr = hotBankArr;
                self.letterBankArr = letterBankArr;
            } else {
                [YSAlertUtil tipOneMessage:@"没有支持的银行"];
            }
        
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (0 == section) {
        num = self.hotBankArr.count;
    } else if (1 == section) {
        num = self.letterBankArr.count;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *bankName = @"";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BankCell" forIndexPath:indexPath];
    if (0 == indexPath.section) {
        bankName = [self.hotBankArr objectAtIndex:indexPath.row];
    } else if (1 == indexPath.section) {
        bankName = [self.letterBankArr objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = UIColorFromRGBA(0x2c2a28, 1.0);
    cell.textLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:15.0f];
    cell.textLabel.text = bankName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *bankName = @"";
    if (0 == indexPath.section) {
        bankName = [self.hotBankArr objectAtIndex:indexPath.row];
    } else if (1 == indexPath.section) {
        bankName = [self.letterBankArr objectAtIndex:indexPath.row];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedBankName:)]) {
        [self.delegate didSelectedBankName:bankName];
        [self.navigationController popViewControllerAnimated:APP_ANIMATION];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 30.0f)];
    [view setBackgroundColor:UIColorFromRGBA(0xf5f4f2, 1.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 7.0f, 100.0f, 16.0f)];
    if (0 == section) {
        label.text = @"热门银行";
    } else {
        label.text = @"其他银行";
    }
    label.textColor = UIColorFromRGBA(0x7d7975, 1.0);
    label.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
    [view addSubview:label];
    return view;
}
@end
