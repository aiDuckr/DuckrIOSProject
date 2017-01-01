//
//  LCMerchantAccountCell.h
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBankcard.h"

@interface LCMerchantAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

- (void)updateShowCell:(LCBankcard *)bankcard;
@end
