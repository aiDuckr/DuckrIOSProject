//
//  LCTourpicSquareCell.m
//  LinkCity
//
//  Created by 张宗硕 on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicSquareCell.h"
#import "UIImageView+AFNetworking.h"

@implementation LCTourpicSquareCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *leftTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewAction:)];
    [self.leftView addGestureRecognizer:leftTapGesture];
    UITapGestureRecognizer *rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewAction:)];
    [self.rightView addGestureRecognizer:rightTapGesture];
    
    self.leftBottomBorderView.layer.borderColor = UIColorFromR_G_B_A(232, 228, 221, 1).CGColor;
    self.leftBottomBorderView.layer.borderWidth = 0.5;
    self.leftBottomBorderView.layer.cornerRadius = 4;
    self.leftBottomBorderView.layer.masksToBounds = YES;
    
    self.rightBottomBorderView.layer.borderColor = UIColorFromR_G_B_A(232, 228, 221, 1).CGColor;
    self.rightBottomBorderView.layer.borderWidth = 0.5;
    self.rightBottomBorderView.layer.cornerRadius = 4;
    self.rightBottomBorderView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)leftViewAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftCellDeatil:)]) {
        [self.delegate leftCellDeatil:self];
    }
}

- (IBAction)rightViewAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightCellDetail:)]) {
        [self.delegate rightCellDetail:self];
    }
}

- (IBAction)leftLikeAction:(id)sender {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    if (nil == self.leftTourpic) {
        return ;
    }
    if (LCTourpicLike_IsUnlike == self.leftTourpic.isLike) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(likeTourpicSquareAction:withPosition:)]) {
            self.leftTourpic.likeNum++;
            self.leftTourpic.isLike = LCTourpicLike_IsLike;
            [self.leftLikeButton setImage:[UIImage imageNamed:@"TourpicSquareLike"] forState:UIControlStateNormal];
            [self.delegate likeTourpicSquareAction:self withPosition:YES];
        }
    } else if (LCTourpicLike_IsLike == self.leftTourpic.isLike) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(unLikeTourpicSquareAction:withPosition:)]) {
            self.leftTourpic.likeNum--;
            self.leftTourpic.isLike = LCTourpicLike_IsUnlike;
            [self.leftLikeButton setImage:[UIImage imageNamed:@"TourpicSquareUnLike"] forState:UIControlStateNormal];
            [self.delegate unLikeTourpicSquareAction:self withPosition:YES];
        }
    }
}

- (IBAction)rightLikeAction:(id)sender {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    if (nil == self.rightTourpic) {
        return ;
    }
    if (LCTourpicLike_IsUnlike == self.rightTourpic.isLike) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(likeTourpicSquareAction:withPosition:)]) {
            self.rightTourpic.likeNum++;
            self.rightTourpic.isLike = LCTourpicLike_IsLike;
            [self.rightLikeButton setImage:[UIImage imageNamed:@"TourpicSquareLike"] forState:UIControlStateNormal];
            [self.delegate likeTourpicSquareAction:self withPosition:NO];
        }
    } else if (LCTourpicLike_IsLike == self.rightTourpic.isLike) {
        [self.rightLikeButton setImage:[UIImage imageNamed:@"TourpicSquareUnLike"] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(unLikeTourpicSquareAction:withPosition:)]) {
            self.rightTourpic.likeNum--;
            self.rightTourpic.isLike = LCTourpicLike_IsUnlike;
            [self.delegate unLikeTourpicSquareAction:self withPosition:NO];
        }
    }
}

+ (CGFloat)getCellHeight {
    CGFloat height = 50;
    height += (DEVICE_WIDTH-12-6)/2/12*11;
    
    return height;
}

- (void)updateShowWithLeftTourpic:(LCTourpic *)leftTourpic rightTourpic:(LCTourpic *)rightTourpic {
    self.leftTourpic = leftTourpic;
    self.rightTourpic = rightTourpic;
    
    if (nil != leftTourpic) {
        self.leftView.hidden = NO;
        [self.leftPicImageView setImageWithURL:[NSURL URLWithString:leftTourpic.picUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        if (LCTourpicLike_IsUnlike == leftTourpic.isLike) {
            [self.leftLikeButton setImage:[UIImage imageNamed:@"TourpicSquareUnLike"] forState:UIControlStateNormal];
        } else if (LCTourpicLike_IsLike == leftTourpic.isLike) {
            [self.leftLikeButton setImage:[UIImage imageNamed:@"TourpicSquareLike"] forState:UIControlStateNormal];
        }
        self.leftPlaceLabel.text = leftTourpic.placeName;
    } else {
        self.leftView.hidden = YES;
    }
    if (nil != rightTourpic) {
        self.rightView.hidden = NO;
        [self.rightPicImageView setImageWithURL:[NSURL URLWithString:rightTourpic.picUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        if (LCTourpicLike_IsUnlike == rightTourpic.isLike) {
            [self.rightLikeButton setImage:[UIImage imageNamed:@"TourpicSquareUnLike"] forState:UIControlStateNormal];
        } else if (LCTourpicLike_IsLike == rightTourpic.isLike) {
            [self.rightLikeButton setImage:[UIImage imageNamed:@"TourpicSquareLike"] forState:UIControlStateNormal];
        }
        self.rightPlaceLabel.text = rightTourpic.placeName;
    } else {
        self.rightView.hidden = YES;
    }
    
}
@end
