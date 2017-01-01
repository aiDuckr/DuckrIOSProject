//
//  LCRoutePlaceDeleteCell.m
//  LinkCity
//
//  Created by roy on 2/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRoutePlaceDeleteCell.h"

@implementation LCRoutePlaceDeleteCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.borderView.layer.borderColor = UIColorFromR_G_B_A(232, 228, 221, 1).CGColor;
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.cornerRadius = 4;
    self.borderView.layer.masksToBounds = YES;
}

@end
