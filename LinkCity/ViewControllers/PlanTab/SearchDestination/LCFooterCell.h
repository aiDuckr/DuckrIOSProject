//
//  LCFooterCell.h
//  LinkCity
//
//  Created by David Chen on 2016/8/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchDestinationMoreVC.h"
@protocol LCFooterCellForPushVCDelegate <NSObject>
- (void)pushVC:(UIViewController *)vc;
@end


@interface LCFooterCell : UITableViewCell
@property (nonatomic, assign) id<LCFooterCellForPushVCDelegate> delegate;
- (void)setButtonTitleWithText:(NSString *)text searchText:(NSString *)str;
@end
