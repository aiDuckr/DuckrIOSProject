//
//  LCPhotoScannerCell.m
//  LinkCity
//
//  Created by roy on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCPhotoScannerCell.h"
#import "LCDetailPhotoView.h"

@interface LCPhotoScannerCell()<LCDetailPhotoViewDelegate>

@property (weak, nonatomic) IBOutlet LCDetailPhotoView *photoView;

@end
@implementation LCPhotoScannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.photoView.delegate = self;
}

- (void)setImageModel:(LCImageModel *)imageModel{

    _imageModel = imageModel;
    RLog(@"iamge model url:%@ ---- %@",imageModel.imageUrl,imageModel.imageUrlThumb);
    
    if (!self.imageModel) {
        return;
    }
    [self.photoView updateImageView:imageModel];
}

- (void)setImageSource:(UIImage *)imageSource {
    self.photoView.imageSource = imageSource;
    [self.photoView updateImageView:nil];
}
- (void)restoreInitState {
    [self.photoView restoreInitState];
}

#pragma mark - LCDetailPhotoViewDelegate
- (void)dissmissPhotoView {
    [self.delegate dissmissPhotoView];
}

@end
