//
//  LCEditUserChooseProfessionVC.m
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChooseProfessionVC.h"
#import "LCChooseProfessionCell.h"

@interface LCChooseProfessionVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation LCChooseProfessionVC



+ (instancetype)createInstance{
    return (LCChooseProfessionVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDChooseProfessionVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"职业信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitButtonAction:)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)submitButtonAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(chooseProfessionVC:didChooseProfession:)] &&
        self.selectedIndexPath) {
        NSString *choosedPro = [[LCDataManager sharedInstance].professionNameArray objectAtIndex:self.selectedIndexPath.row];
        [self.delegate chooseProfessionVC:self didChooseProfession:choosedPro];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [[[LCDataManager sharedInstance] professionNameArray] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCChooseProfessionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCChooseProfessionCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *proName = [[[LCDataManager sharedInstance] professionNameArray] objectAtIndex:indexPath.row];
    NSString *proIconName = [[[LCDataManager sharedInstance] professionDic] objectForKey:proName];
    UIImage *proIcon = [UIImage imageNamed:proIconName];
    
    cell.professionIcon.image = proIcon;
    cell.professionLabel.text = proName;
    
    return cell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
}

@end
