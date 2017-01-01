//
//  LCTourpicAlbumUploadCell.m
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicAlbumUploadCell.h"

@implementation LCTourpicAlbumUploadCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)uploadButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadNewTourpic:)]) {
        [self.delegate uploadNewTourpic:self];
    }
}


+ (CGFloat)getCellHeight {
    return 19.0f + 86.0f + 12.0f;
}

@end
