//
//  LCPlanDetailChargeContentCell.m
//  LinkCity
//
//  Created by Roy on 6/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailChargeContentCell.h"



@implementation LCPlanDetailChargeContentCell

- (void)awakeFromNib {
    UIImage *bottomImage = [UIImage imageNamed:LCCellBottomBg];
    bottomImage = [bottomImage resizableImageWithCapInsets:LCCellBottomBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.imageBgView.image = bottomImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateShowWith:(NSString *)includeStr exclude:(NSString *)excludeStr refundStr:(NSString *)refundStr{
    [self.includeLabel setText:[LCStringUtil getNotNullStr:includeStr] withLineSpace:LCTextFieldLineSpace];
    [self.excludeLabel setText:[LCStringUtil getNotNullStr:excludeStr] withLineSpace:LCTextFieldLineSpace];
    [self.refundLabel setText:[LCStringUtil getNotNullStr:refundStr] withLineSpace:LCTextFieldLineSpace];
}


+ (CGFloat)getCellHeightFor:(NSString *)includeStr exclude:(NSString *)excludeStr refundStr:(NSString *)refundStr{
    CGFloat height = 166;
    
    height += [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStr:includeStr]
                                     withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                    lineSpace:LCTextFieldLineSpace
                                   labelWidth:DEVICE_WIDTH-10-12-15-10];
    
    height += [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStr:excludeStr]
                                     withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                    lineSpace:LCTextFieldLineSpace
                                   labelWidth:DEVICE_WIDTH-10-12-15-10];
    
    height += [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStr:refundStr]
                                     withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                    lineSpace:LCTextFieldLineSpace
                                   labelWidth:DEVICE_WIDTH-10-12-15-10];
    return height;
}
@end
