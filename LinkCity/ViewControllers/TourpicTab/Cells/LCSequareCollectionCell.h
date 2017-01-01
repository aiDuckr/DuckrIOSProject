//
//  LCSequareCollectionCell.h
//  LinkCity
//
//  Created by 张宗硕 on 4/6/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourpic.h"

@class LCSequareCollectionCell;

@protocol LCSequareCollectionCellDelegate <NSObject>
- (void)squareCellLikeSelected:(LCSequareCollectionCell *)cell;
@end

@interface LCSequareCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UIView *numberView;


@property (retain, nonatomic) LCTourpic *tourpic;
- (void)updateCollectionCell:(LCTourpic *)tourpic;

@property (retain, nonatomic) id<LCSequareCollectionCellDelegate> delegate;
@end
