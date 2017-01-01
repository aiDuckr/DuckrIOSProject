//
//  LCMerchantTicketCheckCell.m
//  LinkCity
//
//  Created by 张宗硕 on 6/15/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantTicketCheckCell.h"

@interface LCMerchantTicketCheckCell()

@end

@implementation LCMerchantTicketCheckCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateShowCell:(NSString *)number {
    self.numLabel.text = @"";
    if ([LCStringUtil isNotNullString:number]) {
        self.numLabel.text = number;
    }
}
@end
