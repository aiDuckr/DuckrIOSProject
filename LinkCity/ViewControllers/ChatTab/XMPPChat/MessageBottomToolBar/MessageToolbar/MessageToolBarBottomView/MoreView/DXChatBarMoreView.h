/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>


@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UILabel *takePicLabel;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UILabel *locationLabel;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setupSubviewsForType;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView;

@end
