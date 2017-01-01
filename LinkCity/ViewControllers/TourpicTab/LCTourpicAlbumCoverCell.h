//
//  LCTourpicAlbumCoverCell.h
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCTourpicAlbumCoverCellDelegate <NSObject>
@optional
- (void)changeTourpicCover:(NSString *)tourpicCoverUrl;

@end

@interface LCTourpicAlbumCoverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;


+ (CGFloat)getCellHeight;

@property (retain, nonatomic) id<LCTourpicAlbumCoverCellDelegate> delegate;
@end
