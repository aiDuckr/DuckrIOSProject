//
//  LCSecondaryCostPlanDetailVC.m
//  LinkCity
//
//  Created by lhr on 16/4/23.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSecondaryCostPlanDetailVC.h"

@interface LCSecondaryCostPlanDetailVC ()<UITableViewDelegate,UITableViewDataSource>
//navBar


//tabBar
@property (weak, nonatomic) IBOutlet UIImageView *thumbIcon;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;
@property (weak, nonatomic) IBOutlet UIButton *askAssitantButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

//tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LCSecondaryCostPlanDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUI {
    [self initTableView];
    [self.thumbButton addTarget:self action:@selector(thumbAction) forControlEvents:UIControlEventTouchUpInside];
    [self.askAssitantButton addTarget:self action:@selector(askAssitantAction) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView

    //
    //self.tableView.separatorEffect
    //self.tableView.e
    
    
}
#pragma mark - TableView Delegate & TableView DataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 5;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}

#pragma mark - NavBar

#pragma mark - ButtonAction
- (void)thumbAction {
    
}

- (void)askAssitantAction {
    
}

- (void)buyAction {
    
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
