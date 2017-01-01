//
//  LCPickAndUploadImageView.h
//  LinkCity
//
//  Created by roy on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCImageUtil.h"

@class LCPickAndUploadImageView;
@protocol LCPickAndUploadImageViewDelegate <NSObject>
@optional
- (void)pickImageDidTaped:(LCPickAndUploadImageView *)imageView;
- (void)pickSheetClicked:(LCPickAndUploadImageView *)imageView atIndex:(NSInteger)buttonIndex;
- (void)dissmissPickViewController:(LCPickAndUploadImageView *)imageView;
- (void)pickAndUploadImageView:(LCPickAndUploadImageView *)imageView didPickImage:(UIImage *)image;
- (void)pickAndUploadImageView:(LCPickAndUploadImageView *)imageView didUploadImage:(NSString *)imageURL withError:(NSError *)error;
@end

#define SheetCancelButton 2

@interface LCPickAndUploadImageView : UIImageView
@property (nonatomic, weak) id<LCPickAndUploadImageViewDelegate> delegate;
@property (nonatomic, assign) ImageCategory imageCategory;//e.g. avatar, cover of plan
@end
