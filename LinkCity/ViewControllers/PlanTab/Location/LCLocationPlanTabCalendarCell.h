//
//  LCLocationPlanTabCalendarCell.h
//  LinkCity
//
//  Created by godhangyu on 16/5/17.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCLocationPlanTabCalendarCell;

@protocol LCLocationPlanTabCalendarCellDelegate <NSObject>

- (void)planCommentsSelected:(LCLocationPlanTabCalendarCell *)cell;

@end

@interface LCLocationPlanTabCalendarCell : UITableViewCell

@property (nonatomic, strong) LCPlanModel *plan;

@property (weak, nonatomic) IBOutlet UIImageView *planImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
