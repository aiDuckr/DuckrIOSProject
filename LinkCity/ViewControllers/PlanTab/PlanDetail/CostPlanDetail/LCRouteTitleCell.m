//
//  LCRouteTitleCell.m
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCRouteTitleCell.h"

@implementation LCRouteTitleCell

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCRouteTitleCell class]) bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCRouteTitleCell class]]) {
            return (LCRouteTitleCell *)v;
        }
    }
    
    return nil;
}

+ (CGFloat)getCellHeight{
    return 65;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
