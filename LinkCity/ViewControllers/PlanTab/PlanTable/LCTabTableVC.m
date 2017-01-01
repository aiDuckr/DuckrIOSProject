//
//  LCTabTableVC.m
//  LinkCity
//
//  Created by Roy on 8/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCTabTableVC.h"


#define TabViewHeight_WithTab 40
#define TabViewHeight_WithoutTab 0
@interface LCTabTableVC ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) LCTabView *tabView;
@end

@implementation LCTabTableVC

- (void)commonInit{
    [super commonInit];
    
    self.curTabIndex = 0;
}

- (void)loadView{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add contentView
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
    
    id topGuide = self.topLayoutGuide;
    id bottomGuide = self.bottomLayoutGuide;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[contentView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView, topGuide)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    self.contentView = contentView;
    
    
    //add TabView
    LCTabView *tabView = nil;
    //如果超过1个Tab，显示TabView
    if (self.tableTabs.count > 1) {
        tabView = [LCTabView createInstance];
        tabView.translatesAutoresizingMaskIntoConstraints = NO;
        tabView.delegate = self;
        tabView.selectIndex = self.curTabIndex;
        /*Roy 
         set buttonTitles to add button as tabView's subviews
         need to know the tabView's frame at that time
         */
        tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 40);
        tabView.buttonTitles = self.tableTabs;
        
        [self.contentView addSubview:tabView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tabView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tabView)]];
    }else{
        
    }
    self.tabView = tabView;
    
    
    //add TableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    self.tableView = tableView;
    
    
    //add constraints
    if (tabView) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[tabView(%d)]-0-[tableView]-0-|", TabViewHeight_WithTab] options:0 metrics:nil views:NSDictionaryOfVariableBindings(tabView, tableView)]];
    }else{
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
    }
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
}




#pragma mark - TabView
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index{
    self.curTabIndex = index;
}
#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *c = [[UITableViewCell alloc] init];
    c.backgroundColor = [UIColor yellowColor];
    return c;
}


@end
