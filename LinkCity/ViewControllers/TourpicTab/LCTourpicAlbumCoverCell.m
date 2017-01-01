//
//  LCTourpicAlbumCoverCell.m
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicAlbumCoverCell.h"
#import "LCPickOneImageHelper.h"

@implementation LCTourpicAlbumCoverCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight {
    return (DEVICE_WIDTH * 226.0f) / 375.0f + 28.0f;
}

//- (IBAction)changeCoverAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(changeTourpicCover:)]) {
//        [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:YES completion:^(UIImage *image) {
//            if (nil == image) {
//                return ;
//            }
//            
//            [self.coverImageView setImage:image];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
//                [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryTourpic completion:^(NSString *imgUrl) {
//                    if ([LCStringUtil isNullString:imgUrl]) {
//                        [YSAlertUtil alertOneMessage:@"上传图片出错！"];
//                        return ;
//                    }
//                    if ([LCStringUtil isNotNullString:imgUrl]) {
//                        [LCDataManager sharedInstance].userInfo.tourpicCoverUrl = imgUrl;
//                        [self.delegate changeTourpicCover:imgUrl];
//                    }
//                }];
//            });
//        }];
//    }
//    
//    
//}


@end
