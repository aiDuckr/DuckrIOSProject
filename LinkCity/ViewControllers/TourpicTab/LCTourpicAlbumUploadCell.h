//
//  LCTourpicAlbumUploadCell.h
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTourpicAlbumUploadCell;

@protocol LCTourpicAlbumUploadCellDelegate <NSObject>
@optional
- (void)uploadNewTourpic:(LCTourpicAlbumUploadCell *)cell;

@end

@interface LCTourpicAlbumUploadCell : UITableViewCell
+ (CGFloat)getCellHeight;

@property (retain, nonatomic) id<LCTourpicAlbumUploadCellDelegate> delegate;
@end
