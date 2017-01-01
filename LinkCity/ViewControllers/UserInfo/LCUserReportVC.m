//
//  LCUserReportVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/11.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserReportVC.h"
#import "LCReportUserCell.h"
#import "LCUserReportInfoVC.h"
#import "LCTextView.h"
#import "LCPickMultiImageHelper.h"

#define photoViewOnePhotoWidth [LCSharedFuncUtil adaptBy6sWidthForAllDevice:85.0]
#define photoViewInsetWidthMargin [LCSharedFuncUtil adaptBy6sWidthForAllDevice:3.5]
@interface ReportTextView : SZTextView
@end
@implementation ReportTextView : SZTextView

+ (UIEdgeInsets)textViewEdgeInsets {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

@end

@interface LCUserReportVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

// UI
@property (weak, nonatomic) IBOutlet UITableView *reasonTableView;
@property (weak, nonatomic) IBOutlet ReportTextView *reportTextView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;

@property (strong, nonatomic) UIButton *plusView;

// Data
@property (strong, nonatomic) NSArray *reasonArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSMutableArray *photoViewArray;
@property (strong, nonatomic) NSMutableArray *imageUnitArray;
@property (assign, nonatomic) NSInteger uploadingImageNum;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

static const NSInteger max_PickImage_Count = 3;
static const CGFloat photoViewInsetHeightMargin = 4.0;
static const CGFloat photoViewleftMargin = 12.0;
static const CGFloat photoViewTopMargin = 10.0;
static const CGFloat photoViewBottomMargin = 10.0;

@implementation LCUserReportVC

+ (instancetype)createInstance {
    return (LCUserReportVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserReportVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    [self initTextField];
    [self initPhotoView];
    self.scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initNavigationBar];
}

#pragma mark - Common Init

- (void)initNavigationBar {
    self.title = @"举报";
    
    
}

- (void)initTableView {
    self.reasonArray = @[@"广告骚扰", @"色情低俗", @"侮辱诋毁", @"政治敏感", @"欺诈骗钱"];
    self.selectedIndex = -1;
    
    self.reasonTableView.delegate = self;
    self.reasonTableView.dataSource = self;
    self.reasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.reasonTableView.estimatedRowHeight = 45.0f;
    self.reasonTableView.rowHeight = UITableViewAutomaticDimension;
    [self.reasonTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCReportUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCReportUserCell class])];
}

- (void)initTextField {
    NSString *placeholderStr = @"请描述举报的原因，以便我们及时处理";
    NSMutableAttributedString *attributedPlaceholderStr = [[NSMutableAttributedString alloc] initWithString:placeholderStr];
    NSRange range = NSMakeRange(0, [placeholderStr length]);
    
    [attributedPlaceholderStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xaba7a2, 1) range:range];
    [attributedPlaceholderStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14.0f] range:range];
    
    self.reportTextView.textContainerInset = [ReportTextView textViewEdgeInsets];
    
    [self.reportTextView setAttributedPlaceholder:attributedPlaceholderStr];
}

- (void)initPhotoView {
    self.photoArray = [[NSMutableArray alloc] init];
    self.photoViewArray = [[NSMutableArray alloc] init];
    self.imageUnitArray = [[NSMutableArray alloc] init];
    self.uploadingImageNum = 0;
    
    [self updatePhotoView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.photoView addGestureRecognizer:tapGesture];
}

- (void)updatePhotoView {
    UIImageView *plusIcon =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToupicAddPicIcon"]];
    plusIcon.frame = CGRectMake(0,0,photoViewOnePhotoWidth / 2, photoViewOnePhotoWidth / 2);
    plusIcon.center = CGPointMake(photoViewOnePhotoWidth / 2, photoViewOnePhotoWidth / 2);
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
        [button addTarget:self action:@selector(dismissCommentTextView:) forControlEvents:UIControlEventTouchUpInside];
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
        deleteButton.frame = CGRectMake(photoViewOnePhotoWidth - 23 , 5,23,23);
        [deleteButton setContentMode:UIViewContentModeCenter];
        [deleteButton addTarget:self action:@selector(showDeletePicActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.photoViewArray addObject:button];
        [self.imageUnitArray addObject:unit];
        [self.photoView addSubview:button];
    }
    
    [self layoutPhotoView];
}

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
            imageView.frame = CGRectMake(offSetX,offSetY,photoViewOnePhotoWidth,photoViewOnePhotoWidth);
            [self.photoView addSubview:imageView];
            offSetX += (photoViewOnePhotoWidth + photoViewInsetWidthMargin);
            if (offSetX >= (DEVICE_WIDTH - photoViewOnePhotoWidth)) {
                offSetX = photoViewleftMargin;
                offSetY += (photoViewOnePhotoWidth + photoViewInsetHeightMargin);
            }
        }
        if (self.photoArray.count < max_PickImage_Count) {
            //正常排列，有加号
            self.plusView.frame = CGRectMake(offSetX,offSetY,photoViewOnePhotoWidth,photoViewOnePhotoWidth);
            self.plusView.hidden = false;
        } else {
            self.plusView.hidden = true;
        }
    } else {
        self.plusView.hidden = false;
        self.plusView.frame = CGRectMake(offSetX,offSetY,photoViewOnePhotoWidth,photoViewOnePhotoWidth);
    }
    
    heightOfPhotoView = photoViewOnePhotoWidth + photoViewBottomMargin + photoViewTopMargin;
    if (self.photoArray.count >= 8) {
        heightOfPhotoView += ((photoViewOnePhotoWidth + photoViewInsetHeightMargin) * 2);
    } else if (self.photoArray.count >= 4) {
        heightOfPhotoView += (photoViewOnePhotoWidth + photoViewInsetHeightMargin);
    }
    self.photoViewHeight.constant = heightOfPhotoView;
}

- (void)hideKeyboard:(id)sender {
    [self.reportTextView resignFirstResponder];
}

- (void)addPhoto {
    [self.reportTextView resignFirstResponder];
    [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:(max_PickImage_Count - self.photoArray.count) completion:^(NSArray *pickerImageArray){
        for (int i = 0; i < pickerImageArray.count; i++) {
            UIImage * image = [pickerImageArray objectAtIndex:i];
            [self appendPhotoView:image];
            
        }
        [self layoutPhotoView];
    }];
}

- (void)appendPhotoView:(UIImage*)image {
    UIButton *photo = [UIButton buttonWithType:UIButtonTypeCustom];
    photo.tag = self.photoViewArray.count;
    [photo addTarget:self action:@selector(dismissCommentTextView:) forControlEvents:UIControlEventTouchUpInside];
    //photo.imageView.contentMode
    [photo setImage:image forState:UIControlStateNormal];
    photo.userInteractionEnabled = true;
    [photo.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"TourpicSendImageDeleteIcon"] forState:UIControlStateNormal];
    //[deleteButton sizeToFit];
    [photo addSubview:deleteButton];
    //deleteButton
    deleteButton.frame = CGRectMake(photoViewOnePhotoWidth - 23 , 5,23,23);
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

- (void)startUploadImage:(LCImageUnit *)unit {
    self.uploadingImageNum += 1;
    __weak typeof(self) weakSelf = self;
    [LCImageUtil compressImagesWithData:@[unit.image] complete:^(NSArray *compressArray){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [compressArray objectAtIndex:0];
            [LCImageUtil uploadImageDataToQinu:imageData imageType:ImageCategoryPlan completion:^(NSString *imgUrl) {
                weakSelf.uploadingImageNum -= 1;
                if ([LCStringUtil isNullString:imgUrl]) {
                    [YSAlertUtil tipOneMessage:@"上传图片失败"];
                } else {
                    if ([weakSelf.photoArray indexOfObject:unit.image] != NSNotFound){
                        unit.url = imgUrl;
                    }
                    if (weakSelf.uploadingImageNum == 0) {
                        if ([YSAlertUtil isShowingHud]) {
                            [YSAlertUtil hideHud];
                            [weakSelf reportUser];
                        }
                    }
                }
                
            }];
            
        });
        
    }];
}

- (void)dismissCommentTextView:(UIButton *)sender {
    [self.reportTextView resignFirstResponder];
    LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
    [photoScanner showImage:self.imageUnitArray fromIndex:sender.tag];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
}

- (IBAction)showDeletePicActionSheet:(UIButton *)sender {
    UIButton *button = (UIButton *)sender.superview;
    [self.reportTextView resignFirstResponder];
    [self deletePhotoAtIndex:button.tag];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.reportTextView resignFirstResponder];
}

#pragma mark - UITableView DataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCReportUserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCReportUserCell class]) forIndexPath:indexPath];
    if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        [cell updateCellWithReason:[self.reasonArray objectAtIndex:indexPath.row] isHaveSeparateLine:YES];
    } else {
        [cell updateCellWithReason:[self.reasonArray objectAtIndex:indexPath.row] isHaveSeparateLine:NO];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex != -1) {
        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:indexPath.section]] setSelected:NO];
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
    self.selectedIndex = indexPath.row;
}

#pragma mark - Actions

- (IBAction)reportInfoButtonAction:(id)sender {
    LCUserReportInfoVC *infoVC = [LCUserReportInfoVC createInstance];
    [self.navigationController pushViewController:infoVC animated:APP_ANIMATION];
}

- (IBAction)reportAction:(id)sender {
    [self reportUser];
}

#pragma mark - Net Request

- (void)reportUser {
    
    [self.reportTextView resignFirstResponder];
    if (self.uploadingImageNum > 0) {
        [YSAlertUtil showHudWithHint:@"正在上传图片"];
        return;
    }
    
    NSMutableArray *photoUrls = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.imageUnitArray.count; i++) {
        LCImageUnit *unit = [self.imageUnitArray objectAtIndex:i];
        [photoUrls addObject:unit.url];
    }
    
    if (self.selectedIndex < 0) {
        [YSAlertUtil tipOneMessage:@"请选择举报原因！"];
        return ;
    }
    
    NSString *reportType = [self.reasonArray objectAtIndex:self.selectedIndex];
    
    [LCNetRequester reportUser_V_FIVE:self.user.uUID reportType:reportType reason:self.reportTextView.text photoUrls:photoUrls callBack:^(NSString *msg, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:APP_ANIMATION];
            [YSAlertUtil tipOneMessage:@"举报成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            [YSAlertUtil alertOneMessage:error.domain];
        }
    }];
}

@end
