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
    self.bgView.layer.borderWidth = 0.5f;
    self.bgView.layer.borderColor = [UIColorFromRGBA(LINE_BG_COLOR, 1.0f) CGColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 12.0f;
    /// 调试cell边距.
    /*self.layer.borderColor = [[UIColor redColor] CGColor];
    self.layer.borderWidth = 1.0f;*/
}

@end
