//
//  LCTabTableVC.h
//  LinkCity
//
//  Created by Roy on 8/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoUpdateMasterVC.h"
#import "LCTabView.h"

@interface LCTabTableVC : LCAutoUpdateMasterVC<UITableViewDataSource,UITableViewDelegate,LCTabViewDelegate>

//UI
//@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (weak, nonatomic) IBOutlet UIView *tabBarView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarViewHeight;
//@property (nonatomic, strong) LCTabView *tabView;

@property (strong, nonatomic) UITableView *tableView;


//Data
@property (nonatomic, strong) NSArray *tableTabs;   //array of NSString
@property (nonatomic, assign) NSInteger curTabIndex;

@end
