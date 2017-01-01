//
//  LCPhotoScannerCell.h
//  LinkCity
//
//  Created by roy on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCImageModel.h"

@protocol LCPhotoScannerCellDelegate <NSObject>
- (void)dissmissPhotoView;

@end

@interface LCPhotoScannerCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *imageSource;
@property (nonatomic,strong) LCImageModel *imageModel;
@property (nonatomic, retain) id<LCPhotoScannerCellDelegate> delegate;

- (void)restoreInitState;
@end
