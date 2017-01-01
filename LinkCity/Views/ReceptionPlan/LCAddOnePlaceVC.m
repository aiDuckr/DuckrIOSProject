//
//  LCAddOnePlaceVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCAddOnePlaceVC.h"
#import "UIScrollView+UITouchEvent.h"

@interface LCAddOnePlaceVC ()<LCSearchDestinationDelegate, UIScrollViewDelegate, UITextViewDelegate, YSAlbumImageViewDelegate> {
    BOOL keyboardIsShown;
    BOOL isChooseCover;
    BOOL isClickCompleteBtn;
    NSString *placeImageURL;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtnItem;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LCTextView *placeDescTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet YSAlbumImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeDescImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addPlaceImageView;

@end

@implementation LCAddOnePlaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 初始化变量.
    [self initVariable];
    /// 初始化导航栏的返回按钮.
//    [self initBackBtnItem];
    /// 初始化完成按钮.
    [self initCompleteBtn];
    /// 初始化滚动视图.
    [self initScrollView];
    /// 初始化输入景点描述.
    [self initPlaceDescTextView];
    /// 初始化输入景点照片.
    [self initPlaceImageView];
    
    if (nil != self.modiRouteInfo) {
        if ([LCStringUtil isNotNullString:self.modiRouteInfo.image]) {
            placeImageURL = self.modiRouteInfo.image;
            isChooseCover = YES;
            self.placeImageView.imageURL = [NSURL URLWithString:placeImageURL];
        }
        self.placeDescTextView.text = self.modiRouteInfo.descriptionStr;
        self.placeNameLabel.text = self.modiRouteInfo.placeName;
    }
}

/// 初始化变量.
- (void)initVariable {
    isChooseCover = NO;
    placeImageURL = @"";
    isClickCompleteBtn = NO;
}

/// 初始化导航栏的返回按钮.
- (void)initBackBtnItem {
    /// 使用资源原图片.
    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backBtnItem setImage:backImage];
}

/// 初始化完成按钮.
- (void)initCompleteBtn {
    self.completeBtn.layer.borderWidth = 0.5f;
    self.completeBtn.layer.borderColor = [UIColorFromRGBA(APP_COLOR, 1.0f) CGColor];
}

/// 初始化滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
}

/// 初始化输入景点描述.
- (void)initPlaceDescTextView {
    self.placeDescTextView.delegate = self;
    self.placeDescTextView.placeholder = @"请输入景点描述";
}

/// 初始化景点照片.
- (void)initPlaceImageView {
    self.placeImageView.albumDelegate = self;
    self.placeImageView.imageCategory = ImageCategoryPlace;
}

- (void)updateRouteInfo {
    if (nil != self.modiRouteInfo) {
        self.routeInfo = self.modiRouteInfo;
    } else {
        self.routeInfo = [[LCRouteInfo alloc] init];
        self.routeInfo.placeId = self.placeInfo.placeID;
        self.routeInfo.placeName = self.placeInfo.placeName;
    }
    
    if ([LCStringUtil isNotNullString:self.placeInfo.placeImage]) {
        self.routeInfo.imageThumb = self.placeInfo.placeImageThumb;
        self.routeInfo.image = self.placeInfo.placeImage;
    }
    
    self.routeInfo.descriptionStr = self.placeDescTextView.text;
    
    if ([LCStringUtil isNotNullString:placeImageURL]) {
        self.routeInfo.image = placeImageURL;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addOnePlaceFinished:)]) {
        [self.delegate addOnePlaceFinished:self];
    }
}

- (void)hiddenKeyboard {
    [self.placeDescTextView resignFirstResponder];
}

#pragma mark - Actions
- (IBAction)backAction:(id)sender {
    [self hiddenKeyboard];
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

- (IBAction)addPlaceAction:(id)sender {
    LCSearchDestinationVC *controller = (LCSearchDestinationVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePartnerPlan identifier:VCIDSearchDestination];
    controller.delegate = self;
    controller.searchType = SEARCH_DESTINATION_ADD_PLACE;
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

- (IBAction)completeAction:(id)sender {
    [self.placeDescTextView resignFirstResponder];
    if (nil == self.modiRouteInfo) {
        if ([LCStringUtil isNullString:self.placeNameLabel.text]
            || [LCStringUtil isNullString:self.placeInfo.placeID]
            || [LCStringUtil isNullString:self.placeInfo.placeName]) {
            [YSAlertUtil alertOneMessage:@"请添加景点名称！"];
            return ;
        }
    }
    if ([LCStringUtil isNullString:self.placeDescTextView.text]) {
        [YSAlertUtil alertOneMessage:@"请添加景点描述！"];
        return ;
    }
    if (NO == isChooseCover) {
        [self updateRouteInfo];
        [self backAction:nil];
    }
    
    if ([LCStringUtil isNotNullString:placeImageURL]) {
        [self updateRouteInfo];
        [self backAction:nil];
    }
    isClickCompleteBtn = YES;
}

#pragma mark - YSAlbumImageView Delegate
- (void)imageViewReadyImage:(UIImage *)image {
    isChooseCover = YES;
    placeImageURL = @"";
    self.placeImageView.image = nil;
    self.placeImageView.imageURL = [NSURL URLWithString:@""];
    self.placeImageView.image = image;
}

- (void)imageViewReadyUploadURL:(YSAlbumImageView *)imageView {
    placeImageURL = imageView.uploadImageURL;
    if (nil != self.modiRouteInfo) {
        self.modiRouteInfo.image = placeImageURL;
    }
    if (isClickCompleteBtn) {
        [self updateRouteInfo];
        [self backAction:nil];
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint scrollPoint = CGPointMake(0, textView.superview.frame.origin.y);
    [self.scrollView setContentOffset:scrollPoint animated:NO];
    if (textView == self.placeDescTextView) {
        self.placeDescImageView.image = [UIImage imageNamed:@"ReceptionPlaceDescIconHL"];
    }
}

#pragma mark - LCSearchDestinationVC Delegate
- (void)searchDestinationFinished:(LCSearchDestinationVC *)destinationVC {
    self.addPlaceImageView.image = [UIImage imageNamed:@"ReceptiionAddPlaceIconHL"];
    self.placeNameLabel.text = destinationVC.placeInfo.placeName;
    self.placeInfo = destinationVC.placeInfo;
    ZLog(@"self place info image is %@", self.placeInfo.placeImageThumb);
    if (nil != self.modiRouteInfo) {
        self.modiRouteInfo.placeName = self.placeInfo.placeName;
        self.modiRouteInfo.placeId = self.placeInfo.placeID;
        self.modiRouteInfo.placeName = self.placeInfo.placeImageThumb;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView == scrollView) {
        [self hiddenKeyboard];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hiddenKeyboard];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
