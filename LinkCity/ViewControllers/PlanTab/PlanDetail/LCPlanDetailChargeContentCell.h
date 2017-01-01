//
//  LCPlanDetailChargeContentCell.h
//  LinkCity
//
//  Created by Roy on 6/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanDetailChargeContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageBgView;
@property (weak, nonatomic) IBOutlet UILabel *includeLabel;
@property (weak, nonatomic) IBOutlet UILabel *excludeLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundLabel;


@property (nonatomic, strong) NSString *includeStr;
@property (nonatomic, strong) NSString *excludeStr;
@property (nonatomic, strong) NSString *refundStr;

- (void)updateShowWith:(NSString *)includeStr exclude:(NSString *)excludeStr refundStr:(NSString *)refundStr;
+ (CGFloat)getCellHeightFor:(NSString *)includeStr exclude:(NSString *)excludeStr refundStr:(NSString *)refundStr;
@end
