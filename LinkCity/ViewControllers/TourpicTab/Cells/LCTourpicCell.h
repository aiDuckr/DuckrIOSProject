//
//  LCTourpicCell.h
//  LinkCity
//
//  Created by 张宗硕 on 4/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourpic.h"
#import "LCTourVideoPlayerView.h"

@class LCTourpicCell;

@protocol LCTourpicCellDelegate <NSObject>
//- (void)tourpicLikeSelected:(LCTourpicCell *)cell
- (void)tourpicCommentSelected:(LCTourpicCell *)cell;
//- (void)tourpicFocusSelected:(LCTourpicCell *)cell;
@end

@interface LCTourpicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatarButtonView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *likedLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isHotImageView;

@property (nonatomic,strong) LCTourVideoPlayerView *videoPlayerView;
@property (nonatomic,strong) AVAsset *videoPathUrl;

@property (retain, nonatomic) id<LCTourpicCellDelegate> delegate;
@property (retain, nonatomic) LCTourpic *tourpic;

- (void)updateTourpicCell:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type;
@end
