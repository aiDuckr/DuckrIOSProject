//
//  LCTourpicSquareCell.h
//  LinkCity
//
//  Created by 张宗硕 on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTourpicSquareCell;
@protocol LCTourpicSquareCellDelegate <NSObject>
@optional
- (void)likeTourpicSquareAction:(LCTourpicSquareCell *)cell withPosition:(BOOL)isLeft;
- (void)unLikeTourpicSquareAction:(LCTourpicSquareCell *)cell withPosition:(BOOL)isLeft;
- (void)leftCellDeatil:(LCTourpicSquareCell *)cell;
- (void)rightCellDetail:(LCTourpicSquareCell *)cell;

@end

@interface LCTourpicSquareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *leftBottomBorderView;
@property (weak, nonatomic) IBOutlet UIImageView *leftPicImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftLikeButton;
@property (weak, nonatomic) IBOutlet UILabel *leftPlaceLabel;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *rightBottomBorderView;
@property (weak, nonatomic) IBOutlet UIImageView *rightPicImageView;
@property (weak, nonatomic) IBOutlet UIButton *rightLikeButton;
@property (weak, nonatomic) IBOutlet UILabel *rightPlaceLabel;

@property (retain, nonatomic) LCTourpic *leftTourpic;
@property (retain, nonatomic) LCTourpic *rightTourpic;

@property (retain, nonatomic) id<LCTourpicSquareCellDelegate> delegate;

+ (CGFloat)getCellHeight;
- (void)updateShowWithLeftTourpic:(LCTourpic *)leftTourpic rightTourpic:(LCTourpic *)rightTourpic;
@end
