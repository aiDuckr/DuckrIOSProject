//
//  LCBaseTableVC.h
//  LinkCity
//
//  Created by roy on 12/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBaseTableVC : UITableViewController
@property (nonatomic,assign) BOOL haveLayoutSubViews;
@property (nonatomic,assign) BOOL isFirstTimeViewWillAppear;

- (void)showHud;
- (void)hideHud;
@end
