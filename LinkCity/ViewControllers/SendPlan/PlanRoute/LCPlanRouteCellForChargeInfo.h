//
//  LCPlanRouteCellForChargeInfo.h
//  LinkCity
//
//  Created by roy on 3/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@protocol LCPlanRouteCellForChargeInfoDelegate;
@interface LCPlanRouteCellForChargeInfo : UITableViewCell<UITextViewDelegate>
@property (nonatomic, weak) id<LCPlanRouteCellForChargeInfoDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIView *chargeInfoTextHolder;
@property (weak, nonatomic) IBOutlet SZTextView *chargeInfoTextView;

+ (CGFloat)getCellHeight;
@end


@protocol LCPlanRouteCellForChargeInfoDelegate <NSObject>

- (void)planRouteCellForChargeInfoDidBeginEdit:(LCPlanRouteCellForChargeInfo *)cell;
- (void)planRouteCellForChargeInfoDidEndEdit:(LCPlanRouteCellForChargeInfo *)cell;

@end