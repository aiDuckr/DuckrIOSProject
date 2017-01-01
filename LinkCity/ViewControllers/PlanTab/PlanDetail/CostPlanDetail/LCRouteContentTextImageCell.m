//
//  LCRouteContentTextImageCell.m
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCRouteContentTextImageCell.h"

@implementation LCRouteContentTextImageCell

- (void)awakeFromNib {
    [self.imgBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.imgBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    self.imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)imgBtnAction:(id)sender {
}


@end
