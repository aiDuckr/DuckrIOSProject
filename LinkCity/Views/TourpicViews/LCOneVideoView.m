//
//  LCOneVideoView.m
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCOneVideoView.h"

@implementation LCOneVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateTourpicView:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type {
    [super updateTourpicView:tourpic withType:type];
    
    if (LCTourpicCellViewType_Cell == type) {
        self.imageWidthConstraint.constant = (DEVICE_WIDTH - 3.0f) / 2.0f;
        self.playWidthConstraint.constant = 51.0f;
    } else if (LCTourpicCellViewType_Detail == type) {
        self.imageWidthConstraint.constant = DEVICE_WIDTH;
        self.playWidthConstraint.constant = 75.0f;
    }
    
    if (tourpic.thumbPhotoUrls.count >= 1) {
        NSString *thumbPhotoUrl = [tourpic.thumbPhotoUrls objectAtIndex:0];
        [self.imageView setImageWithURL:[NSURL URLWithString:thumbPhotoUrl] placeholderImage:[UIImage imageNamed:LCDefaultTourpicImageName]];
    }
}
@end
