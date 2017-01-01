//
//  DestinationCollectionCell.m
//  LinkCity
//
//  Created by 张宗硕 on 11/8/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCDestinationCollectionCell.h"

@implementation LCDestinationCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 0.5f;
    self.bgView.layer.borderColor = UIColorFromR_G_B_A(201, 197, 193, 1).CGColor;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 2.0;
}

@end
