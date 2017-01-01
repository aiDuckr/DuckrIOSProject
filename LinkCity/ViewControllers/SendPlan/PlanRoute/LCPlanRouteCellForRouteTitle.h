//
//  LCPlanRouteCellForRouteTitle.h
//  LinkCity
//
//  Created by roy on 3/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPlanRouteCellForRouteTitleDelegate;
@interface LCPlanRouteCellForRouteTitle : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, weak) id<LCPlanRouteCellForRouteTitleDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *titleTextFieldHolder;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

+ (CGFloat)getCellHeight;
@end


@protocol LCPlanRouteCellForRouteTitleDelegate <NSObject>

- (void)planRouteCellForRouteTitleDidEndEdit:(LCPlanRouteCellForRouteTitle *)planRouteCell;

@end