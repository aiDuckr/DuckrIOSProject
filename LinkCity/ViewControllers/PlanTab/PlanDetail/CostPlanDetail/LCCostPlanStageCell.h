//
//  LCCostPlanStageCell.h
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCostPlanStageCell : UICollectionViewCell
@property (nonatomic, strong) LCPartnerStageModel *stage;

@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *btnLabel;


- (void)updateShowWithStage:(LCPartnerStageModel *)stage isCreater:(BOOL)isMeCreater;
@end
