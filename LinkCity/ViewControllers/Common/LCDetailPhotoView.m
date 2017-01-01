//
//  LCDetailPhotoView.m
//  LinkCity
//
//  Created by 张宗硕 on 1/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCDetailPhotoView.h"

#define kMaxZoom 3.0

@implementation LCDetailPhotoView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _width = DEVICE_WIDTH;
        _height = DEVICE_HEIGHT;
        
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [self addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 5.0;
        _scrollView.showsVerticalScrollIndicator = FALSE;
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        CGFloat ratio = _width/_height*DEVICE_HEIGHT/DEVICE_WIDTH;
        CGFloat min = MIN(ratio, 1.0);
        _scrollView.minimumZoomScale = min;
        
        CGFloat height = _height /_width * DEVICE_WIDTH;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.contentOffset.x+100, _scrollView.contentOffset.y+230, 10, 10)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGFloat y = (DEVICE_HEIGHT - height)/2.0;
        _offsetY = 0.0-y;
        _scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, height);
        [_scrollView addSubview:_imageView];
        _scrollView.contentOffset = CGPointMake(0, 0.0-y);
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                  action:@selector(handleLongPress:)];
        longPressGR.allowableMovement = NO;
        longPressGR.minimumPressDuration = 0.2;
        [self.imageView addGestureRecognizer:longPressGR];
        self.imageView.multipleTouchEnabled = YES;//设置属性使得uiimageview可以响应屏幕事件
        self.imageView.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _imageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, height);
                             self.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                         }
         ];
        
        
        UITapGestureRecognizer *tapImgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandle)];
        tapImgView.numberOfTapsRequired = 1;
        tapImgView.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapImgView];
        
        UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
        tapImgViewTwice.numberOfTapsRequired = 2;
        tapImgViewTwice.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapImgViewTwice];
        [tapImgView requireGestureRecognizerToFail:tapImgViewTwice];
    }
    return self;
}

- (void)updateImageView:(LCImageModel *)imageModel {
    //为了在回调中hide hud，只得自己组装NSURLRequest
    //使用的UIImageView+AFNetworking中的组装方式
    //if (imageModel)
    if (self.imageSource == nil) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[imageModel getImageNSURL]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    
    NSMutableURLRequest *thumbRequest = [NSMutableURLRequest requestWithURL:[imageModel getImageThumbNSURL]];
    [thumbRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    UIImage *cachedThumbImage = [[[UIImageView class] sharedImageCache] cachedImageForRequest:thumbRequest];
    UIImage *placeHolderImage = cachedThumbImage ? cachedThumbImage : [UIImage imageNamed:@"Translucent"];
    
    
    [self showHud];
    __weak typeof(self) weakSelf = self;
    [self.imageView setImageWithURLRequest:request placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideHud];
        
        strongSelf.imageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideHud];
        [YSAlertUtil tipOneMessage:@"加载图片失败" yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }];
    } else {
        [self.imageView setImage:self.imageSource];
    }
}

- (void)showHud{
    if (self.hud) {
        [self.hud hide:NO];
    }
    self.hud = [[MBProgressHUD alloc]initWithView:self.imageView];
    [self.imageView addSubview:self.hud];
    [self.hud show:YES];
}
- (void)hideHud{
    [self.hud hide:YES];
    self.hud = nil;
}

#pragma mark - UIscrollViewDelegate zoom

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _currentScale = scale;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    //双击放大时，图片不能越界，否则会出现空白。因此需要对边界值进行限制。
    if(_isDoubleTapingForZoom){
        NSLog(@"taping center");
        xcenter = kMaxZoom*(DEVICE_WIDTH - _touchX);
        ycenter = kMaxZoom*(DEVICE_HEIGHT - _touchY);
        if(xcenter > (kMaxZoom - 0.5)*DEVICE_WIDTH){//放大后左边超界
            xcenter = (kMaxZoom - 0.5)*DEVICE_WIDTH;
        }else if(xcenter <0.5*DEVICE_WIDTH){//放大后右边超界
            xcenter = 0.5*DEVICE_WIDTH;
        }
        if(ycenter > (kMaxZoom - 0.5)*DEVICE_HEIGHT){//放大后左边超界
            ycenter = (kMaxZoom - 0.5)*DEVICE_HEIGHT +_offsetY*kMaxZoom;
        }else if(ycenter <0.5*DEVICE_HEIGHT){//放大后右边超界
            ycenter = 0.5*DEVICE_HEIGHT +_offsetY*kMaxZoom;
        }
    }
    [_imageView setCenter:CGPointMake(xcenter, ycenter)];
}

#pragma mark - tap
-(void)tapImgViewHandle{
    NSLog(@"%d",_isTwiceTaping);
    if(_isTwiceTaping){
        return;
    }
    
    [self.delegate dissmissPhotoView];
    
}

- (void)restoreInitState {
    [_scrollView setZoomScale:1.0 animated:YES];
}

-(IBAction)tapImgViewHandleTwice:(UIGestureRecognizer *)sender{
    _touchX = [sender locationInView:sender.view].x;
    _touchY = [sender locationInView:sender.view].y;
    if(_isTwiceTaping){
        return;
    }
    _isTwiceTaping = YES;
    
    if(_currentScale > 1.0){
        _currentScale = 1.0;
        [_scrollView setZoomScale:1.0 animated:YES];
    }else{
        _isDoubleTapingForZoom = YES;
        _currentScale = kMaxZoom;
        [_scrollView setZoomScale:kMaxZoom animated:YES];
    }
    _isDoubleTapingForZoom = NO;
    //延时做标记判断，使用户点击3次时的单击效果不生效。
    [self performSelector:@selector(twiceTaping) withObject:nil afterDelay:0.65];
}

- (void)twiceTaping{

    _isTwiceTaping = NO;
}

- (void)handleLongPress:(id)sender {
    if (nil == self.savePhotoSheet) {
        self.savePhotoSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
        self.savePhotoSheet.cancelButtonIndex = self.savePhotoSheet.numberOfButtons - 1;
    }
    [self.savePhotoSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
        }
    }
}

/// 功能：保存图片到手机.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存到手机"]) {
        if (nil != self.imageView.image) {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

/// 功能：显示图片保存结果.
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        [YSAlertUtil tipOneMessage:@"保存失败！"];
    } else {
        [YSAlertUtil tipOneMessage:@"保存成功！"];
    }
}
@end
