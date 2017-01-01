//
//  LCSendTourPicVCViewController.m
//  LinkCity
//
//  Created by lhr on 16/4/3.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendTourPicVCViewController.h"
//#import "LCWithWhoVC.h"
#import "LCMarkPicPlaceVC.h"
#import "LCStoryBoardManager.h"
#import "LCSharedFuncUtil.h"
#import "LCTourVideoPlayerView.h"
#import "LCImageUnit.h"
#import "LCImageUtil.h"
#import "LCPickMultiImageHelper.h"
#import "LCTextView.h"
#import "LCTourpicChoosePlanVC.h"
@interface LCSendTourPicVCViewController ()<UIActionSheetDelegate, UITextViewDelegate,LCMarkPicPlaceVCDelegate, UIScrollViewDelegate,LCTourpicChoosePlanVCDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;

@property (weak, nonatomic) IBOutlet SZTextView *commentTextView;

//@IBOutlet weak var commentTextView: LCTextView!

@property (weak, nonatomic) IBOutlet UINavigationItem *middleButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButtonItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *withFriendView;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UIButton *withWhoButton;
@property (weak, nonatomic) IBOutlet UIButton *markWhereButton;
@property (weak, nonatomic) IBOutlet UILabel *shouldHaveValueLabel;

//@IBOutlet weak var LeftButtonItem: UIBarButtonItem!
//@IBOutlet weak var RightButtonItem: UIBarButtonItem!
//@IBOutlet weak var ScrollView: UIScrollView!
//@IBOutlet weak var photoView: UIView!
//@IBOutlet weak var locationLabel: UILabel!
//
//@IBOutlet weak var LocationView: UIView!
//@IBOutlet weak var WithFriendView: UIView!
//@IBOutlet weak var friendLabel: UILabel! //现在会出现半个人的名字的状况，以后可以进行优化
//@IBOutlet weak var markWhereButton: UIButton!
//@IBOutlet weak var withWhoButton: UIButton!


@property (nonatomic,assign) CGFloat photoViewInsetWidthMargin;
@property (nonatomic,assign) CGFloat photoViewOnePhotoWidth; ///let

@property (nonatomic,assign) BOOL isFirstInfo;
@property (nonatomic,assign) NSInteger uploadingImageNum;//= false;
//var isFirstInfo:Bool = true;
@property (nonatomic,strong) NSString *descriptionStr;

@property (nonatomic,strong) NSString *markWhereStr;
@property (nonatomic,strong) NSString *withWhoStr;
@property (nonatomic,strong) NSString *withWhoJsonStr;
@property (nonatomic,strong) UIView *spaLineView;


@property (nonatomic,strong) NSMutableArray *imageUnitArray;
@property (nonatomic,strong) NSMutableArray *photoViewArray;
@property (nonatomic,strong) UIButton *plusView;

@property (nonatomic,strong) AVAsset *videoPathUrl;
@property (nonatomic,strong) LCTourVideoPlayerView *videoPlayerView;
@property (nonatomic, retain) NSString *videoUrlStr;
@property (nonatomic, strong) LCPlanModel *selectedPlan;

@end

static const NSInteger max_PickImage_Count = 9;
static const CGFloat photoViewInsetHeightMargin = 4.0;
static const CGFloat photoViewleftMargin = 12.0;
static const CGFloat photoViewTopMargin = 10.0;
static const CGFloat photoViewBottomMargin = 10.0;
//to do:评论页和详情页默认的行间距，后面进行全局修正
//static const CGFloat lineSpace = 7.0;
@implementation LCSendTourPicVCViewController
+ (instancetype)createInstance {
    return  (LCSendTourPicVCViewController *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicSendVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.photoViewOnePhotoWidth = [LCSharedFuncUtil adaptBy6sWidthForAllDevice:85.0];
    self.photoViewInsetWidthMargin = [LCSharedFuncUtil adaptBy6sWidthForAllDevice:3.5];
    self.isFirstInfo = YES;
    self.scrollView.delegate = self;
    
    self.descriptionStr = @"";
    self.uploadingImageNum = 0;
    
    
    self.markWhereStr = @"";
    self.withWhoStr = @"";
    self.withWhoJsonStr= @"";
    //_photoArray = [[NSMutableArray alloc] init];
    _imageUnitArray = [[NSMutableArray alloc] init];
    _photoViewArray = [[NSMutableArray alloc] init];
    [self setUpUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.numberOfTapsRequired = 1;
    
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    
    [self.scrollView addGestureRecognizer:tapGesture];
    [self.scrollView addGestureRecognizer:panGesture];
    [self.photoView addGestureRecognizer:tapGesture];
    [self.videoPlayerView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
}

- (void)hideKeyboard:(id)sender {
    [self.commentTextView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.commentTextView resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (LCTourpicType_Video != self.type) {
        if (self.isFirstInfo == true) {
            for(int i = 0 ; i < [self.imageUnitArray count] ;i++) {
                LCImageUnit *unit = [self.imageUnitArray objectAtIndex:i];
                [self startUploadImage:unit];
            }
            self.isFirstInfo = false;
            self.middleButtonItem.title = @"晒旅图";
        }
    } else {
       // [self initVideoView];
        self.middleButtonItem.title = @"发视频";
        [self.videoPlayerView play];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVideoPath:(AVAsset *)url {
    self.videoPathUrl = url;
    self.type = LCTourpicType_Video;
}



- (void)setUpUI {
    self.commentTextView.placeholder = @"分享此刻...";
    self.commentTextView.delegate = self;
    self.spaLineView = [[UIView alloc] initWithFrame:CGRectMake(55.0,0,DEVICE_WIDTH - 55.0,0.5)];
    self.leftButtonItem.action = @selector(back);
    self.leftButtonItem.target = self;
    self.rightButtonItem.action = @selector(send);
    self.rightButtonItem.target = self;
    self.spaLineView.backgroundColor = DefaultSpalineColor;
    [self.withFriendView addSubview:self.spaLineView];
    if (LCTourpicType_Video == self.type) {
        [self initVideoView];
    } else {
        [self initPhotoView];
    }
    [self.withWhoButton addTarget:self action:@selector(markWithWhoAction) forControlEvents:UIControlEventTouchUpInside];
    
   
    [self.markWhereButton addTarget:self action:@selector(markPlaceAction) forControlEvents:UIControlEventTouchUpInside];
   
    //
}

#pragma mark - Image Asset
- (void)initPhotoView {
    UIImageView *plusIcon =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToupicAddPicIcon"]];
    plusIcon.frame = CGRectMake(0,0,self.photoViewOnePhotoWidth / 2, self.photoViewOnePhotoWidth / 2);
    plusIcon.center = CGPointMake(self.photoViewOnePhotoWidth / 2, self.photoViewOnePhotoWidth / 2);
    self.plusView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.plusView addSubview:plusIcon];
    [self.plusView addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.plusView.backgroundColor =UIColorFromRGBA(0xf2f0ed, 1.0);
    [self.photoView addSubview:self.plusView];
    if (self.photoViewArray && self.photoViewArray.count > 0) {
        [self.photoViewArray removeAllObjects];
    }
    NSInteger imageIndex = 0;
    for (UIImage *image in self.photoArray) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(dissmissCommentTextView:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        button.imageView.clipsToBounds = true;
        
        LCImageUnit *unit = [[LCImageUnit alloc] init];
        unit.image = image;
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"TourpicSendImageDeleteIcon"] forState:UIControlStateNormal];
        //[deleteButton sizeToFit];
        [button addSubview:deleteButton];
        //deleteButton
        deleteButton.tag = imageIndex;
        imageIndex += 1;
        deleteButton.frame = CGRectMake(self.photoViewOnePhotoWidth - 23 , 5,23,23);
        [deleteButton setContentMode:UIViewContentModeCenter];
        [deleteButton addTarget:self action:@selector(showDeletePicActionSheet:) forControlEvents:UIControlEventTouchUpInside];

        [self.photoViewArray addObject:button];
        [self.imageUnitArray addObject:unit];
        [self.photoView addSubview:button];
    }
    [self layoutPhotoView];
    
}

/*
 *change the layout of PhotoView if the count of Array Changes
 */
- (void)layoutPhotoView {
    CGFloat offSetX,offSetY,heightOfPhotoView;
    offSetX = photoViewleftMargin;
    offSetY = photoViewTopMargin;
    NSInteger imageIndex = 0;
    if (self.photoViewArray.count != 0) {
        
        //for (UIButton *imageView)
        for (UIButton *imageView in self.photoViewArray) {
            imageView.tag = imageIndex;
            imageIndex += 1;
            imageView.frame = CGRectMake(offSetX,offSetY,self.photoViewOnePhotoWidth,self.photoViewOnePhotoWidth);
            [self.photoView addSubview:imageView];
            offSetX += (self.photoViewOnePhotoWidth + self.photoViewInsetWidthMargin);
            if (offSetX >= (DEVICE_WIDTH - self.photoViewOnePhotoWidth)) {
                offSetX = photoViewleftMargin;
                offSetY += (self.photoViewOnePhotoWidth + photoViewInsetHeightMargin);
            }
        }
        if (self.photoArray.count < max_PickImage_Count) {
            //正常排列，有加号
            self.plusView.frame = CGRectMake(offSetX,offSetY,self.photoViewOnePhotoWidth,self.photoViewOnePhotoWidth);
            self.plusView.hidden = false;
        } else {
            self.plusView.hidden = true;
        }
    } else {
        self.plusView.hidden = false;
        self.plusView.frame = CGRectMake(offSetX,offSetY,self.photoViewOnePhotoWidth,self.photoViewOnePhotoWidth);
    }
    
    heightOfPhotoView = self.photoViewOnePhotoWidth + photoViewBottomMargin + photoViewTopMargin;
    if (self.photoArray.count >= 8) {
        heightOfPhotoView += ((self.photoViewOnePhotoWidth + photoViewInsetHeightMargin) * 2);
    } else if (self.photoArray.count >= 4) {
        heightOfPhotoView += (self.photoViewOnePhotoWidth + photoViewInsetHeightMargin);
    }
    self.photoViewHeight.constant = heightOfPhotoView;
}

- (void)appendPhotoView:(UIImage*)image {
    UIButton *photo = [UIButton buttonWithType:UIButtonTypeCustom];
    photo.tag = self.photoViewArray.count;
    [photo addTarget:self action:@selector(dissmissCommentTextView:) forControlEvents:UIControlEventTouchUpInside];
    //photo.imageView.contentMode
    [photo setImage:image forState:UIControlStateNormal];
    photo.userInteractionEnabled = true;
    [photo.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"TourpicSendImageDeleteIcon"] forState:UIControlStateNormal];
    //[deleteButton sizeToFit];
    [photo addSubview:deleteButton];
    //deleteButton
    deleteButton.frame = CGRectMake(self.photoViewOnePhotoWidth - 23 , 5,23,23);
    [deleteButton setContentMode:UIViewContentModeCenter];
    [deleteButton addTarget:self action:@selector(showDeletePicActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoArray addObject:image];
    [self.photoView addSubview:photo];
    LCImageUnit* unit = [[LCImageUnit alloc] init];
    unit.image = image;
    [self startUploadImage:unit];
    [self.imageUnitArray addObject:unit];
    [self.photoViewArray addObject:photo];
}
- (void)deletePhotoAtIndex:(NSInteger)index {
    //mark
    UIButton *button = [self.photoViewArray objectAtIndex:index];
    [button removeFromSuperview];
    [self.photoViewArray removeObjectAtIndex:index];
    [self.imageUnitArray removeObjectAtIndex:index];
    [self.photoArray removeObjectAtIndex:index];
    [self layoutPhotoView];
    

}
- (void)startUploadImage:(LCImageUnit *)unit {
    //NSData * imageData = [LCImageUtil getDataOfCompressImage:unit.image toSize:200 * 1024];
//    NSData * imageData = [LCImageUtil getImageDataFromUIImage:unit.image];
    self.uploadingImageNum += 1;
    __weak typeof(self) weakSelf = self;
    [LCImageUtil compressImagesWithData:@[unit.image] complete:^(NSArray *compressArray){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //        NSData *imageData = [LCImageUtil getDataOfCompressImage:unit.image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
            NSData *imageData = [compressArray objectAtIndex:0];
            [LCImageUtil uploadImageDataToQinu:imageData imageType:ImageCategoryPlan completion:^(NSString *imgUrl) {
                weakSelf.uploadingImageNum -= 1;
                if ([LCStringUtil isNullString:imgUrl]) {
                    [YSAlertUtil tipOneMessage:@"上传图片失败"];//
                } else {
                    //indexOfObject
                    if ([weakSelf.photoArray indexOfObject:unit.image] != NSNotFound){
                        
                        unit.url = imgUrl;
                        
                    }
                    if (weakSelf.uploadingImageNum == 0) {
                        if ([YSAlertUtil isShowingHud]) {
                            [YSAlertUtil hideHud];
                            // 如果正在显示hud，说明用户已经点了下一步按钮；上传图片完成后，自动下一步
                            [weakSelf send];
                        }
                    }
                }
                
            }];
            
        });

    }];
    }
#pragma mark - Video Asset
- (void)initVideoView {
        self.photoViewHeight.constant = 200.0;
    self.videoPlayerView = [[LCTourVideoPlayerView alloc] initWithFrame: CGRectMake(0,0,self.photoView.frame.size.width,200) url:self.videoPathUrl];
    [self.photoView addSubview:self.videoPlayerView];
    [LCImageUtil uploadVideoToQiniu:self.filePath completion:^(NSString *videoStr) {
        self.videoUrlStr = videoStr;
        if ([YSAlertUtil isShowingHud]) {
            [YSAlertUtil hideHud];
            // 如果正在显示hud，说明用户已经点了下一步按钮；上传图片完成后，自动下一步
            [self send];
        }
    }];
}


#pragma mark - Sender

- (void) markWithWhoAction {
    LCTourpicChoosePlanVC *vc = [LCTourpicChoosePlanVC createInstance];
    vc.delegate = self;
    vc.selectedPlan = self.selectedPlan;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
//   LCWithWhoVC *vc = [LCWithWhoVC createInstance];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (void)markPlaceAction {
    LCMarkPicPlaceVC *vc = [LCMarkPicPlaceVC createInstance];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (void)send {
    [self.commentTextView resignFirstResponder];
    [MobClick event:Mob_PublishTourPic_Publish];
    self.descriptionStr = self.commentTextView.text;
    
    if ([LCStringUtil isNullString:self.markWhereStr] ) {
        [YSAlertUtil tipOneMessage:@"标记这是在哪里必填" ];
        return ;
    }
    if (LCTourpicType_Video != self.type && self.photoArray.count == 0) {
        [YSAlertUtil tipOneMessage:@"请至少选择一张图片" ];
        return ;
    }
//    if ([LCStringUtil isNullString:self.descriptionStr]) {
//       [YSAlertUtil tipOneMessage:@"描述不得为空" ];
//        return ;
//    }
    if (self.uploadingImageNum > 0) {
        [YSAlertUtil showHudWithHint:@"正在上传图片"];
        return;
    }
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < self.imageUnitArray.count ; i++ ) {
        LCImageUnit * unit =[self.imageUnitArray objectAtIndex:i];
        [urlArray addObject:unit.url];
    }
    
    if (LCTourpicType_Video == self.type) {
        if ([LCStringUtil isNullString:self.videoUrlStr]) {
            [YSAlertUtil showHudWithHint:@"正在上传视频..."];
            return ;
        }
        urlArray = [[NSMutableArray alloc] init];
        [urlArray addObject:self.videoUrlStr];
    }
    NSString *planGuid = nil;
    if (self.selectedPlan) {
        planGuid = self.selectedPlan.planGuid;
    }
    [LCNetRequester sendTourPic:urlArray withType:self.type userLocation:[[LCDataManager sharedInstance] userLocation] placeName:self.markWhereStr description:self.descriptionStr planGuid:planGuid callBack:^(NSError *error){
        if(error != nil) {
            [YSAlertUtil alertOneMessage:error.domain];
        } else {
            [self.navigationController popViewControllerAnimated:true];
            [YSAlertUtil tipOneMessage:@"旅图发布成功"];
        }
    }];
}

- (void)back {
    
    if (self.type == LCTourpicType_Video) {
        [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"确认" withTitle:@"确认取消发布视频？" msg:nil callBack:^(NSInteger chooseIndex) {
            //
            if (chooseIndex == 0) {
                return ;
            } else {
                 [self.navigationController popViewControllerAnimated:APP_ANIMATION];
            }
        }];
    } else {
        [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"确认" withTitle:@"确认取消发布旅图？" msg:nil callBack:^(NSInteger chooseIndex) {
            //
            if (chooseIndex == 0) {
                return ;
            } else {
                [self.navigationController popViewControllerAnimated:APP_ANIMATION];
            }
        }];
    }
    //[self.navigationController popViewControllerAnimated:APP_ANIMATION];

}

- (void)addPhoto {
    [self.commentTextView resignFirstResponder];
    [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:(max_PickImage_Count - self.photoArray.count) completion:^(NSArray *pickerImageArray){
        for (int i = 0; i < pickerImageArray.count; i++) {
            UIImage * image = [pickerImageArray objectAtIndex:i];
            [self appendPhotoView:image];
            
        }
        [self layoutPhotoView];
    }];

    
}

#pragma mark - ActionSheet

- (IBAction)showDeletePicActionSheet:(UIButton *)sender {
    UIButton *button = (UIButton *)sender.superview;
    [self.commentTextView resignFirstResponder];
    [self deletePhotoAtIndex:button.tag];

}

- (void)dissmissCommentTextView:(UIButton *)sender {
    [self.commentTextView resignFirstResponder];
    LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
    [photoScanner showImage:self.imageUnitArray fromIndex:sender.tag];
      [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
}
//#pragma mark - ActionSheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        [self deletePhotoAtIndex:actionSheet.tag];
//    } else {
//        
//    }
//}

#pragma mark - Choose Place Delegate
- (void)choosePlaceName:(NSString *)name
{
    self.locationLabel.text = name;
    self.markWhereStr = name;
    if(name && name.length > 0) {
        self.shouldHaveValueLabel.hidden = YES;
    } else {
        self.shouldHaveValueLabel.hidden = NO;
    }
}

#pragma mark - Choose Who Delegate
//- (void)chooseFinished:(NSArray *)choosedArr
//{
//    NSString *showWithWhoStr = @"";
//    NSMutableArray *jsonArr = [[NSMutableArray alloc] init];
//    for (id obj in choosedArr) {
//        if ([obj isKindOfClass:[LCUserModel class]]) {
//            LCUserModel *userModel = (LCUserModel *)obj;
//            if ([showWithWhoStr isEqualToString:@""]) {
//                showWithWhoStr = [NSString stringWithFormat:@"%@", userModel.nick];
//            } else {
//                showWithWhoStr = [NSString stringWithFormat:@"%@, %@", showWithWhoStr, userModel.nick];
//            }
//            [jsonArr addObject:@{@"Phone":userModel.telephone, @"Name":userModel.nick, @"UUID":userModel.uUID}];
//        } else if ([obj isKindOfClass:[LCPhoneContactorModel class]]) {
//            LCPhoneContactorModel *contactModel = (LCPhoneContactorModel *)obj;
//            if ([showWithWhoStr isEqualToString:@""]) {
//                showWithWhoStr = [NSString stringWithFormat:@"%@", contactModel.name];
//            } else {
//                showWithWhoStr = [NSString stringWithFormat:@"%@, %@", showWithWhoStr, contactModel.name];
//            }
//            [jsonArr addObject:@{@"Phone":contactModel.phone, @"Name":contactModel.name, @"UUID":@""}];
//        }
//    }
//    self.withWhoJsonStr = [LCStringUtil getJsonStrFromArray:jsonArr];
//    self.friendLabel.text = showWithWhoStr;
//}
/*

*/
#pragma mark - Touch Event& Scroll Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentTextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{   [super touchesBegan:touches withEvent:event];
    [self.commentTextView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:lineSpace];
//
//    NSDictionary * attibute = @{NSFontAttributeName:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:15.0f],
//                                NSParagraphStyleAttributeName:paragraphStyle,
//                                NSForegroundColorAttributeName:
//                                    UIColorFromRGBA(0x2C2A28,1.0)
//                                };
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attibute];
}

#pragma mark - LCTourpicChoosePlanVCDelegate

- (void)didChoosePlanWithPlan:(LCPlanModel *)model {
    self.selectedPlan = model;
    if (model) {
        self.friendLabel.text = [model getDepartAndDestString];
    } else {
        self.friendLabel.text = @"关联哪次活动";
    }
}


@end
