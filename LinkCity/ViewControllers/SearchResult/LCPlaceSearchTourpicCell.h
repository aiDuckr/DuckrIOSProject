//
//  LCPlaceSearchTourpicCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPlaceSearchTourpicCellDelegate;

@interface LCPlaceSearchTourpicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *avatarImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tourpicImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (retain, nonatomic) LCTourpic *tourpic;
@property (retain, nonatomic) id<LCPlaceSearchTourpicCellDelegate> delegate;

- (void)updateShowPlaceSearchTourpic:(LCTourpic *)tourpic;
@end

@protocol LCPlaceSearchTourpicCellDelegate <NSObject>
- (void)likeTourpicButtonAction:(LCPlaceSearchTourpicCell *)cell;
- (void)unLikeTourpicButtonAction:(LCPlaceSearchTourpicCell *)cell;
- (void)avatarSelectedButtonAction:(LCPlaceSearchTourpicCell *)cell;
@end
