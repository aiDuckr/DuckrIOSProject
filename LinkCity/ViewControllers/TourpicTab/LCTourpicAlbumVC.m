//
//  LCTourpicAlbumVC.m
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicAlbumVC.h"
#import "LCTourpicAlbumCoverCell.h"
#import "LCTourpicAlbumUploadCell.h"
#import "LCTourpicAlbumTimelineCell.h"
#import "LCPickMultiImageHelper.h"
#import "WechatShortVideoController.h"
#import "LCSendTourPicVCViewController.h"
#import "LCPickOneImageHelper.h"
#import "LCTourpicDetailVC.h"
#import "MJRefresh.h"
#import "LCSystemPermissionUtil.h"
@interface LCTourpicAlbumVC ()<UITableViewDelegate, UITableViewDataSource, LCTourpicAlbumUploadCellDelegate, LCTourpicAlbumCoverCellDelegate, WechatShortVideoDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *tourpicArr;
@property (retain, nonatomic) NSString *orderStr;
@property (retain, nonatomic) NSString *filePath;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *notifyBarButton;

@end

@implementation LCTourpicAlbumVC


+ (instancetype)createInstance {
    return (LCTourpicAlbumVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicAlbumVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)initVariable {
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_PUBLISH];
    
    self.tourpicArr = [[NSArray alloc] init];
    self.orderStr = @"";
    self.tourpicArr = [LCDataManager sharedInstance].albumTourpicArr;
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicAlbumCoverCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicAlbumCoverCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicAlbumUploadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicAlbumUploadCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicAlbumTimelineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicAlbumTimelineCell class])];
}

- (void)updateShow {
    [self.tableView reloadData];
}

- (void)refreshData {
    [self.tableView headerBeginRefreshing];
}

- (void)updateMyselfTourpics {
    if ([LCStringUtil isNullString:self.orderStr]) {
        self.orderStr = @"";
    }
    [LCNetRequester getUserTourpics:self.user.uUID withOrderStr:self.orderStr callBack:^(NSArray *tourpicArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != tourpicArr) {
                    self.tourpicArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:tourpicArr];
                    [self.tableView reloadData];
                } else {
                    self.tourpicArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != tourpicArr) {
                    self.tourpicArr = [LCSharedFuncUtil addFiltedArrayToArray:self.tourpicArr withUnfiltedArray:tourpicArr];
                }
            }
            [self updateShow];
            [LCDataManager sharedInstance].albumTourpicArr = self.tourpicArr;
            self.orderStr = orderStr;
        }
    }];
}

- (void)headerRefreshAction {
    self.orderStr = @"";
    [self updateMyselfTourpics];
}

- (void)footerRefreshAction {
    [self updateMyselfTourpics];
}

- (UITableViewCell *)configueTourpicCoverCell:(NSIndexPath *)indexPath {
    LCTourpicAlbumCoverCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicAlbumCoverCell class]) forIndexPath:indexPath];
    cell.nameLabel.text = self.user.nick;
    cell.delegate = self;
    if ([self.user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
        cell.coverButton.hidden = NO;
    } else {
        cell.coverButton.hidden = YES;
    }
//    if ([LCStringUtil isNotNullString:self.user.tourpicCoverUrl]) {
//        [cell.coverImageView setImageWithURL:[NSURL URLWithString:self.user.tourpicCoverUrl]];
//    }
//    if (nil == cell.coverImageView.image) {
//        
//        cell.coverImageView.image = [UIImage imageNamed:@"TourpicMyselfDefaultCover"];
//    }
    [cell.avatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    return cell;
}

#pragma mark 设置上传图片的cell、展示图片流的cell
- (UITableViewCell *)configueTourpicUploadCell:(NSIndexPath *)indexPath {
    LCTourpicAlbumUploadCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicAlbumUploadCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (UITableViewCell *)configueTourpicTimelineCell:(NSIndexPath *)indexPath {
    LCTourpicAlbumTimelineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicAlbumTimelineCell class]) forIndexPath:indexPath];
    LCTourpic *tourpic = [self.tourpicArr objectAtIndex:indexPath.row];
    
    
    [cell updateCellWithTourpic:tourpic];
    cell.descLabel.text = tourpic.desc;
    cell.placeLabel.text = tourpic.placeName;
    cell.withWhoLabel.text = [LCTourpicAlbumTimelineCell getWithWhoStr:tourpic];
    cell.photoCountLabel.text =[NSString stringWithFormat:@"共%zd张",tourpic.photoUrls.count];
    cell.dayLabel.text = [LCDateUtil getDayFromStr:tourpic.createdTime];
    cell.monthYearLabel.text = [NSString stringWithFormat:@"%@.%@", [LCDateUtil getYearFromStr:tourpic.createdTime], [LCDateUtil getMonthFromStr:tourpic.createdTime]];
    if (indexPath.row - 1 >= 0)  {
        LCTourpic *lastTourpic = [self.tourpicArr objectAtIndex:indexPath.row - 1];
        if ([LCDateUtil isSameDayYMD_HHS:tourpic.createdTime withAnotherDay:lastTourpic.createdTime]) {
            cell.dayLabel.text = @"";
            cell.monthYearLabel.text = @"";
        }
    }
    
    cell.bigGapView.hidden = NO;
    if (indexPath.row < self.tourpicArr.count)  {
        LCTourpic *nextTourpic = [self.tourpicArr objectAtIndex:indexPath.row];
        if ([LCDateUtil isSameDayYMD_HHS:tourpic.createdTime withAnotherDay:nextTourpic.createdTime]) {
            cell.bigGapView.hidden = YES;
        }
    }
    if (indexPath.row == self.tourpicArr.count) {
        cell.bigGapView.hidden = YES;
    }
    [cell refreshLayout:tourpic];
    return cell;
}

- (void)showTourpicDetail:(LCTourpic *)tourpic {
    LCTourpicDetailVC *vc = [LCTourpicDetailVC createInstance];
    vc.tourpic = tourpic;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

#pragma mark LCTourpicAlbumCoverCell Delegate
#warning 并不能长按更改背景啊！！！
- (void)changeTourpicCover:(NSString *)tourpicCoverUrl {
    [LCNetRequester setMyselfTourpicCover:tourpicCoverUrl];
}

#pragma mark LCTourpicAlbumUpload Delegate
- (void)uploadNewTourpic:(LCTourpicAlbumUploadCell *)cell {
    [MobClick event:Mob_PublishTourPic];
    
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    } else {
        [YSAlertUtil showActionSheetWithCallBack:^(NSInteger selectIndex) {
            if (selectIndex == 0) {
                // cancel
            } else if(selectIndex == 1) {
                // video
                 [self checkPermissionOfSystem];
            } else if(selectIndex == 2) {
                // camera
                [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:NO camera:YES allowEdit:NO completion:^(UIImage *image) {
                    if (image) {
                        [self sendTourPicWithImageArray:@[image]];
                    }
                }];
            }else if(selectIndex == 3) {
                // album
                [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:9 completion:^(NSArray *pickedImageArray) {
                    [self sendTourPicWithImageArray:pickedImageArray];
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍摄视频", @"拍照", @"从相册中选取"]];
    }
}

- (void)sendTourPicWithImageArray:(NSArray *)imageArray {
    if (imageArray && imageArray.count > 0) {
        LCSendTourPicVCViewController *sendTourPicVC = [LCSendTourPicVCViewController createInstance];
        sendTourPicVC.type = LCTourpicType_Photo;
        sendTourPicVC.photoArray = [[NSMutableArray alloc] initWithArray:imageArray];//[imageArray mutableCopy];
        [self.navigationController pushViewController:sendTourPicVC animated:APP_ANIMATION];
    }
}

#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (0 == indexPath.section) {
        cell = [self configueTourpicCoverCell:indexPath];
    } else if (1 == indexPath.section) {
        cell = [self configueTourpicUploadCell:indexPath];
    } else if (2 == indexPath.section) {
        cell = [self configueTourpicTimelineCell:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return [LCTourpicAlbumCoverCell getCellHeight];
    } else if (1 == indexPath.section) {
        return [LCTourpicAlbumUploadCell getCellHeight];
    } else if (2 == indexPath.section) {
        LCTourpic *tourpic = [self.tourpicArr objectAtIndex:indexPath.row];
        return [LCTourpicAlbumTimelineCell getCellHeight:tourpic isShowBigGap:YES];
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:APP_ANIMATION];
    if (2 == indexPath.section) {
        LCTourpic *tourpic = [self.tourpicArr objectAtIndex:indexPath.row];
        [self showTourpicDetail:tourpic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 1;
    if (0 == section) {
        return number;
    } else if (1 == section) {
        return number;
    } else if (2 == section) {
        number = self.tourpicArr.count;
    }
    return number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark UITableView Delete Row
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.section) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (2 == indexPath.section) {
            NSInteger tourpicIndex = indexPath.row;
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.tourpicArr.count > tourpicIndex) {
                LCTourpic *tourpic = [self.tourpicArr objectAtIndex:tourpicIndex];
                [LCNetRequester deleteTourpicWithGuid:tourpic.guid callBack:^(NSError *error) {
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                    }
                }];
            }
            NSMutableArray *tourpicMutArr = [[NSMutableArray alloc] initWithArray:self.tourpicArr];
            [tourpicMutArr removeObjectAtIndex:indexPath.row];
            self.tourpicArr = tourpicMutArr;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)checkPermissionOfSystem {
    if (![LCSystemPermissionUtil isHaveCameraPermission]) {
        return ;//没有给权限
    }
    if (![LCSystemPermissionUtil isHaveAlbumPermission]) {
        return;//没有给权限
    }
    __weak typeof(self) weakSelf = self;
    [LCSystemPermissionUtil isHaveVoicePermission:^(BOOL isHavePermission) {
        if (isHavePermission) {
            //可以拍摄视频
            WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
            wechatShortVideoController.delegate = weakSelf;
            [weakSelf presentViewController:wechatShortVideoController animated:YES completion:^{}];
        }
    }];
}

#pragma mark WechatShortVideoDelegate
- (void)finishWechatShortVideoCapture:(NSString *)filePath {
    self.filePath = filePath;
}

- (void)finishWechatShortVideoCaptureWithAsset:(AVAsset *)asset {
    LCSendTourPicVCViewController *sendTourPicVC = [LCSendTourPicVCViewController createInstance];
    sendTourPicVC.type = LCTourpicType_Video;
    sendTourPicVC.filePath = self.filePath;
    [sendTourPicVC setVideoPath:asset];
    [self.navigationController pushViewController:sendTourPicVC animated:APP_ANIMATION];
}

@end
