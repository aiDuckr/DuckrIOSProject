//
//  LCSearchDestinationRecmdCell.m
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSearchDestinationRecmdCell.h"

@implementation LCSearchDestinationRecmdCell

- (void)awakeFromNib {
    self.borderBgView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBgView.layer.borderWidth = LCCellBorderWidth;
    self.borderBgView.layer.masksToBounds = YES;
    self.borderBgView.layer.cornerRadius = LCCellCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (CGFloat)getCellHeight{
    return 55;
}

- (void)updateShowWithLeftPlace:(LCHomeCategoryModel *)left
                     rightPlace:(LCHomeCategoryModel *)right
                    isFirstCell:(BOOL)isFirst
                     isLastCell:(BOOL)isLast{
    self.leftPlace = left;
    self.rightPlace = right;
    
    if (!left) {
        self.leftView.hidden = YES;
    }else{
        self.leftView.hidden = NO;
        [self.leftImageView setImageWithURL:[NSURL URLWithString:left.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultPlaceImageName]];
        self.leftTitle.text = left.title;
        self.leftSubTitle.text = left.descInfo;
    }
    
    if (!right) {
        self.rightView.hidden = YES;
    }else{
        self.rightView.hidden = NO;
        [self.rightImageView setImageWithURL:[NSURL URLWithString:right.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultPlaceImageName]];
        self.rightTitle.text = right.title;
        self.rightSubTitle.text = right.descInfo;
    }
    
    if (isFirst) {
        self.borderBgViewTop.constant = 0;
    }else{
        self.borderBgViewTop.constant = -6;
    }
    
    if (isLast) {
        self.borderBgViewBottom.constant = 0;
        self.bottomLine.hidden = YES;
    }else{
        self.borderBgViewBottom.constant = -6;
        self.bottomLine.hidden = NO;
    }
}

- (IBAction)leftButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchDestinationRecmdCell:didSelectPlace:)]) {
        [self.delegate searchDestinationRecmdCell:self didSelectPlace:self.leftPlace];
    }
}
- (IBAction)rightButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchDestinationRecmdCell:didSelectPlace:)]) {
        [self.delegate searchDestinationRecmdCell:self didSelectPlace:self.rightPlace];
    }
}

@end
