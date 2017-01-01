//
//  LCTourpicPlanInfoCell.h
//  LinkCity
//
//  Created by lhr on 16/5/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@class LCTourpicPlanInfoCell;

@protocol  LCTourpicPlanInfoCellDelegate <NSObject>

-(void) didJumpInfoDetailCell:(LCTourpicPlanInfoCell *)cell;
-(void) didSelectedDetailCell:(LCTourpicPlanInfoCell *)cell;
//- (void)didUnSelectedDetailCell;
@end

@interface LCTourpicPlanInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet RadioButton *radioButton;

@property (weak, nonatomic) id <LCTourpicPlanInfoCellDelegate> delegate;

- (void)bindWithData:(LCPlanModel *)model isSelected:(BOOL)selected;
@end
