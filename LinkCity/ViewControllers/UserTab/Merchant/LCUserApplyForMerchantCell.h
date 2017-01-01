//
//  LCUserApplyForMerchantCell.h
//  LinkCity
//
//  Created by godhangyu on 16/6/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUserApplyForMerchantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separateLineHeight;

- (void)updateCell:(NSString *)str isHaveSeparateLine:(BOOL)separete;

@end
