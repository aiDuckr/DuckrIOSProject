//
//  LCSequareCollectionCell.m
//  LinkCity
//
//  Created by 张宗硕 on 4/6/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCSequareCollectionCell.h"

@implementation LCSequareCollectionCell

- (void)updateCollectionCell:(LCTourpic*)tourpic {
    self.tourpic = tourpic;
    self.widthConstraint.constant = (DEVICE_WIDTH - 2.0) / 2.0f;
    [self.imageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPicUrl] placeholderImage:[UIImage imageNamed:LCDefaultTourpicImageName]];

    self.heightConstraint.constant = self.widthConstraint.constant * tourpic.coverHeight / tourpic.coverWidth;
    self.placeNameLabel.text = tourpic.placeName;
    self.likedNumLabel.text = [NSString stringWithFormat:@"%ld", (long)tourpic.likeNum];
    
    if (LCTourpicLike_IsLike == tourpic.isLike) {
        self.likeImageView.image = [UIImage imageNamed:@"TourpiclikedIcon"];
    } else {
        self.likeImageView.image = [UIImage imageNamed:@"TourpicunThumbIcon"];
    }
    self.photoNumLabel.text = [NSString stringWithFormat:@"%ld张", (long)tourpic.photoNum];
    if (LCTourpicType_Video == tourpic.type) {
        self.playImageView.hidden = NO;
        self.numberView.hidden = YES;
    } else {
        self.playImageView.hidden = YES;
        self.numberView.hidden = NO;
    }
}

- (IBAction)likedButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(squareCellLikeSelected:)]) {
        [self.delegate squareCellLikeSelected:self];
    }
}


@end
