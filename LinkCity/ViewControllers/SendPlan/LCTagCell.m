//
//  LCTagCell.m
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCTagCell.h"

@implementation LCTagCell

- (void)awakeFromNib {
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 3;


}

- (void)updateShowWithText:(NSString *)text selected:(BOOL)selected{
    self.tagLabel.text = [LCStringUtil getNotNullStr:text];
    if (selected) {
        self.tagLabel.backgroundColor = UIColorFromRGBA(0xfee100, 1);
        self.tagLabel.textColor = UIColorFromRGBA(0x6b450a, 1);
    }else{
        self.tagLabel.backgroundColor = UIColorFromRGBA(0xfaf9f8, 1);
        self.tagLabel.textColor = UIColorFromRGBA(0x7d7975, 1);
    }
}


@end
