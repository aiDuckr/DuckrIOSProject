//
//  LCMerchantBankcardVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantBankcardVC.h"
#import "LCBankcard.h"
#import "LCMerchantAccountCell.h"

@interface LCMerchantBankcardVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LCUserAccount *account;
@property (strong, nonatomic) NSArray *bankArr;

@end

@implementation LCMerchantBankcardVC
#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantBankcardVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantBankcardVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bankArr = [[NSArray alloc] init];
    
    [self initAddCardButton];
    [self initTableView];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)initAddCardButton {
    self.addCardButton.layer.borderWidth = 0.5f;
    self.addCardButton.layer.borderColor = UIColorFromRGBA(0xc9c5c1, 1.0f).CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShow];
}

- (void)updateShow {
    self.account = [LCDataManager sharedInstance].merchantAccount;
    if (nil != self.account) {
        if (nil != self.account.bankcardArr) {
            self.bankArr = self.account.bankcardArr;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCMerchantAccountCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCMerchantAccountCell class]) forIndexPath:indexPath];
    LCBankcard *bank = [self.bankArr objectAtIndex:indexPath.row];
    [cell updateShowCell:bank];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCBankcard *bankcard = [self.bankArr objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedBankcard:)]) {
        [self.delegate didSelectedBankcard:bankcard];
        [self.navigationController popViewControllerAnimated:APP_ANIMATION];
    }
}

@end
