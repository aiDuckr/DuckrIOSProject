//
//  LCUserInfoPageAlbumCell.h
//  LinkCity
//
//  Created by roy on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSAlbumImageView.h"
#import "LCImageModel.h"
#import "LCUserAlbumImageView.h"

@protocol LCUserInfoPageAlbumCellDelegate;
@interface LCUserInfoPageAlbumCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *theContentView;
@property (weak, nonatomic) IBOutlet LCUserAlbumImageView *imageView;
@property (nonatomic, strong) LCImageModel *imageModel;
@property (nonatomic, weak) id<LCUserInfoPageAlbumCellDelegate> delegate;
- (void)showAddPhoto;
- (void)showImage:(LCImageModel *)imageModel;
@end



@protocol LCUserInfoPageAlbumCellDelegate <NSObject>
@optional
- (void)userInfoPageAlbumCellDidLongPressed:(LCUserInfoPageAlbumCell *)cell;
@end
