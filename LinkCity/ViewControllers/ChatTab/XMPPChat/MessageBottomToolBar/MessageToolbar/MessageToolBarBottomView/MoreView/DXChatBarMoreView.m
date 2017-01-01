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

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 58
#define MARGIN_BUTTON_TO_EDGE 30
#define MARGIN_BUTTON_TO_TOP 19
#define MARGIN_LABEL_TO_BUTTON 7
#define LABEL_FONT_SIZE 14

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    /// 添加分割线.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:219.0/255.0 blue:204.0/255.0 alpha:1.0];
    [self addSubview:view];
    
    self.backgroundColor = [UIColor clearColor];
    /// 修改为背景白色透明.
    self.backgroundColor = UIColorFromR_G_B_A(247, 245, 243, 1);
    /// 修改成三个功能.
//    CGFloat insets = (self.frame.size.width - 3 * CHAT_BUTTON_SIZE - 2 * MARGIN_BUTTON_TO_EDGE) / 2;
    CGFloat btnInset = 39;
    CGFloat marginLeft = (self.frame.size.width - 3*CHAT_BUTTON_SIZE - 2*btnInset) / 2;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(marginLeft, MARGIN_BUTTON_TO_TOP, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"ChatAlbumButton"] forState:UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    _photoLabel = [[UILabel alloc] init];
    [_photoLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:LABEL_FONT_SIZE]];
    [_photoLabel setTextColor:UIColorFromRGBA(LCDarkTextColor, 1)];
    _photoLabel.text = @"照片";
    [_photoLabel sizeToFit];
    _photoLabel.center = CGPointMake(_photoButton.center.x, _photoButton.frame.origin.y+_photoButton.frame.size.height+MARGIN_LABEL_TO_BUTTON + _photoLabel.frame.size.height/2);
    [self addSubview:_photoLabel];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(marginLeft + CHAT_BUTTON_SIZE + btnInset, MARGIN_BUTTON_TO_TOP, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"ChatCameraButton"] forState:UIControlStateNormal];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    _takePicLabel = [[UILabel alloc] init];
    [_takePicLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:LABEL_FONT_SIZE]];
    [_takePicLabel setTextColor:UIColorFromRGBA(LCDarkTextColor, 1)];
    _takePicLabel.text = @"拍照";
    [_takePicLabel sizeToFit];
    _takePicLabel.center = CGPointMake(_takePicButton.center.x, _takePicButton.frame.origin.y+_takePicButton.frame.size.height+MARGIN_LABEL_TO_BUTTON + _takePicLabel.frame.size.height/2);
    [self addSubview:_takePicLabel];
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(btnInset * 2 + marginLeft + CHAT_BUTTON_SIZE * 2, MARGIN_BUTTON_TO_TOP, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"ChatLocationButton"] forState:UIControlStateNormal];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    
    _locationLabel = [[UILabel alloc] init];
    [_locationLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:LABEL_FONT_SIZE]];
    [_locationLabel setTextColor:UIColorFromRGBA(LCDarkTextColor, 1)];
    _locationLabel.text = @"位置";
    [_locationLabel sizeToFit];
    _locationLabel.center = CGPointMake(_locationButton.center.x, _locationButton.frame.origin.y+_locationButton.frame.size.height+MARGIN_LABEL_TO_BUTTON + _locationLabel.frame.size.height/2);
    [self addSubview:_locationLabel];
    
//    CGRect frame = self.frame;
//    frame.size.height = 90;
//    
//    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    NSLog(@"takePicAction");
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    NSLog(@"photoAction");
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    NSLog(@"locationAction");
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

@end
