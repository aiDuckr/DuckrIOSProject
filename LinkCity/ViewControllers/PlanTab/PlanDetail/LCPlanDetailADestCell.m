//
//  LCPlanDetailADestCell.m
//  LinkCity
//
//  Created by Roy on 9/2/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailADestCell.h"

@implementation LCPlanDetailADestCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.destLabel.layer.cornerRadius = 15;
    self.destLabel.layer.masksToBounds = YES;
    self.destLabel.backgroundColor = UIColorFromRGBA(0xf6f5f3, 1);
    self.destLabel.layer.borderColor = UIColorFromRGBA(0xe5e4e3, 1).CGColor;
    self.destLabel.layer.borderWidth = 1;
}

- (void)updateShowWithDes:(NSString *)dest isArrow:(BOOL)isArrow isDash:(BOOL)isDash{
    
    self.destLabel.text = [LCStringUtil getNotNullStr:dest];
    
    if (isArrow) {
        self.destArrowIcon.hidden = NO;
        self.destLabel.hidden = YES;
        self.dashView.hidden = YES;
    }else if(isDash){
        self.destArrowIcon.hidden = YES;
        self.destLabel.hidden = YES;
        self.dashView.hidden = NO;
    }else{
        self.destArrowIcon.hidden = YES;
        self.destLabel.hidden = NO;
        self.dashView.hidden = YES;
    }
}

////重用Cell后，会更新constraints，此时强制Cell重新布局
//- (void)updateConstraintsIfNeeded{
//    [super updateConstraintsIfNeeded];
//    
//    [self setNeedsLayout];
//}

+ (CGSize)sizeOfADestCell:(NSString *)dest isArrow:(BOOL)isArrow isDash:(BOOL)isDash{
    CGSize size = CGSizeMake(0, 0);
    
    if (isArrow) {
        size = CGSizeMake(20, 36);
    }else if(isDash) {
        size = CGSizeMake(10, 36);
    }else{
        CGSize textSize = [dest sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:16]}];
        size = CGSizeMake(textSize.width+26+6, 36);
    }
    
    return size;
}

+ (CGFloat)heightOfADestCell{
    return 36;
}

@end
