//
//  LCDetailPhotoView.h
//  LinkCity
//
//  Created by 张宗硕 on 1/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@protocol LCDetailPhotoViewDelegate <NSObject>
- (void)dissmissPhotoView;

@end

@interface LCDetailPhotoView : UIView<UIScrollViewDelegate, EGOImageViewDelegate, UIActionSheetDelegate>

@property (nonatomic) EGOImageView *imageView;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) BOOL isTwiceTaping;
@property (nonatomic) BOOL isDoubleTapingForZoom;
@property (nonatomic) CGFloat currentScale;
@property (nonatomic) CGFloat offsetY;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) CGFloat touchX;
@property (nonatomic) CGFloat touchY;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, retain) UIActionSheet* savePhotoSheet;
@property (nonatomic, retain) id<LCDetailPhotoViewDelegate> delegate;

- (void)updateImageView:(LCImageModel *)imageModel;
- (void)restoreInitState;
@end
