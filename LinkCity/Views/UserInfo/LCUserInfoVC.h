//
//  LCUserInfoVC.h
//  LinkCity
//
//  Created by roy on 11/22/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCDataManager.h"
#import "LCReceptionPlan.h"
#import "LCPartnerPlan.h"
#import "LCUserApi.h"
#import "LCPlanApi.h"
#import "EGOImageView.h"
#import "LCStoryboardManager.h"
#import "LCUserInfoPagePlansTableCell.h"
#import "YSAlbumImageView.h"
#import "LCUserInfoPageAlbumCell.h"
#import "LCUserApi.h"
#import "LCStringUtil.h"
#import "LCReceptionDetailVC.h"
#import "LCPartnerDetailVC.h"
#import "LCPhotoScanner.h"
#import "LCImageUtil.h"
#import "MJRefresh.h"
#import "LCUserInfoEditVC.h"
#import "LCPartnerApi.h"
#import "LCSlideVC.h"
#import "LCCommonApi.h"
#import "EGOImageButton.h"
#import "LCViewSwitcher.h"
#import "LCTableView.h"
#import "LCCollectionView.h"

#define PlansTableCellHeight 155

typedef enum : NSUInteger {
    UserInfoVC_InfoPage,
    UserInfoVC_PlansPage,
    UserInfoVC_AlbumPage,
} UserInfoVC_PageType;

@interface LCUserInfoVC : LCBaseVC<LCUserApiDelegate, LCCommonApiDelegate>
#pragma mark - Data
@property (nonatomic,assign) BOOL isShowingSelf;
@property (nonatomic,strong) LCUserInfo *userInfo;
@property (nonatomic,strong) NSArray *plans;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic, retain) NSString *lastUserUuid;

#pragma mark - Views

@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIButton *navBarBackButton;
@property (weak, nonatomic) IBOutlet UILabel *navBarTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *navBarSettingButton;


@property (weak, nonatomic) IBOutlet UIView *wholeView;
@property (weak, nonatomic) IBOutlet UIScrollView *wholeVerticalScrollView;

//Cover
@property (weak, nonatomic) IBOutlet UIView *topCoverView;

@property (weak, nonatomic) IBOutlet UILabel *partnerNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *receptionNumLabel;
@property (weak, nonatomic) IBOutlet EGOImageButton *createrAvatarView;

@property (weak, nonatomic) IBOutlet UIView *coverButtonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverButtonContainerVerticalLineWidth;

@property (weak, nonatomic) IBOutlet UIButton *faveButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;

@property (weak, nonatomic) IBOutlet UIButton *editButton;



//button tab view
@property (nonatomic, assign) CGFloat buttonsContainerViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsContainerViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *buttonsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *userInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *planStateButton;
@property (weak, nonatomic) IBOutlet UIButton *userAlbumButton;
@property (weak, nonatomic) IBOutlet UIView *buttonBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomLineLeft;


@property (weak, nonatomic) IBOutlet UIScrollView *pageHorizontalScrollView;

//用户基本信息
@property (weak, nonatomic) IBOutlet UIView *userInfoContentView;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userSlogonRowHeight;
@property (weak, nonatomic) IBOutlet UIImageView *userSlogonBorderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userSlogonLabel;

@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;


//用户旅行动态
@property (weak, nonatomic) IBOutlet UIView *userPlanContentView;
@property (weak, nonatomic) IBOutlet LCTableView *userPlanTableView;


//用户相册
@property (weak, nonatomic) IBOutlet UIView *userAlbumView;
@property (weak, nonatomic) IBOutlet LCCollectionView *userAlbumCollectionView;
//用于处理图片上传的变量
@property (strong, nonatomic) UIImage *preprocessedImage;
@property (strong, nonatomic) UIImage *processedImage;
@property (strong, nonatomic) NSData *preprocessedData;
@property (strong, nonatomic) NSString *imageURLOfQiNiu;
@property (strong, nonatomic) NSString *imageType;
@property (assign, nonatomic) ImageCategory imageCategory;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;

//显示选项
@property (strong, nonatomic) UIActionSheet *addPhotoActionSheet;
@property (strong, nonatomic) UIActionSheet *deletePhotoActionSheet;
//处理网络请求的变量
@property (nonatomic, strong) NSString *lastGetPhotoOrderTime;
@property (nonatomic, strong) NSString *lastGetPlanOrderTime;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageHorizontalScrollViewHeight;
@property (assign, nonatomic) UserInfoVC_PageType showingPageType;


//public interface
+ (UINavigationController *)createNavigationVCInstance;
+ (LCUserInfoVC *)createRootVCInstance;
- (void)showUserinfo:(LCUserInfo *)userInfo showSelfInfo:(BOOL)isShowingSelf;

//inner interface
- (void)updateShow;
- (void)updatePageShowTo:(UserInfoVC_PageType)pageType;
@end



@interface LCUserInfoVC (Network)
- (void)getUserInfo:(NSString *)userUUID;
- (void)getPlansOfUser:(NSString *)userUUID fromOrderTime:(NSString *)orderTime;
- (void)getPhotosOfUser:(NSString *)userUUID fromOrderTime:(NSString *)orderTime;
- (void)addImageToUserAlbum;
- (void)deleteImageFromUserAlbum:(NSString *)imageUrlMD5;
- (void)uploadImageToQiniu;
@end

@interface LCUserInfoVC (PlansTableView)<UITableViewDataSource,UITableViewDelegate>

@end

@interface LCUserInfoVC (AlbumCollectionView)<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LCPartnerApiDelegate,LCUserApiDelegate,LCUserInfoPageAlbumCellDelegate>

- (float)getAlbumCollectionViewContentHeight;
- (NSInteger)getPhotoIndexFromCollectionIndexPath:(NSIndexPath *)indexPath;
@end

@interface LCUserInfoVC (MJRefresh)
- (void)addFooterRefersh;
- (void)removeFooterRefersh;
- (void)hideFooterRefresh:(BOOL)hide;
@end

@interface LCUserInfoVC (ScrollView)<UIScrollViewDelegate>

@end