//
//  LCMerchantTicketCheckCell.h
//  LinkCity
//
//  Created by 张宗硕 on 6/15/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMerchantTicketCheckCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
- (void)updateShowCell:(NSString *)number;
@end