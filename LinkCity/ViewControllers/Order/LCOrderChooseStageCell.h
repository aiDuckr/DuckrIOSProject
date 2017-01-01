//
//  LCOrderChooseStageCell.h
//  LinkCity
//
//  Created by Roy on 12/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCOrderChooseStageCell : UICollectionViewCell
@property (nonatomic, strong) LCPartnerStageModel *stage;

@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *btnLabel;


- (void)updateShowWithStage:(LCPartnerStageModel *)stage;
@end
