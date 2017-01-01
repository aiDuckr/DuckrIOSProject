//
//  LCTourpicLinkingPlanListVC.m
//  LinkCity
//
//  Created by lhr on 16/5/10.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCTourpicLinkingPlanListVC.h"
#import "LCTourpicCell.h"
@interface LCTourpicLinkingPlanListVC ()<UITableViewDelegate,UITableViewDataSource,LCTourpicCellDelegate,LCShareViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *popularTableView;

@property (retain, nonatomic) NSArray *popularArr;

@property (nonatomic, strong) NSString *popularOrderStr;

@property (retain, nonatomic) LCShareView *shareView;
@end

@implementation LCTourpicLinkingPlanListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动实况";
    [self initPopularTableView];
    [self getPopularTourpicList];
    // Do any additional setup after loading the view.
}

+ (instancetype)createInstance {
    //( *)[LCStoryboardManager viewControllerWithFileName:SB identifier:VCIDUserEvaluationVC];
    return  (LCTourpicLinkingPlanListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicLinkingPlanListVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initPopularTableView {
    self.popularTableView.delegate = self;
    self.popularTableView.dataSource = self;
    self.popularTableView.estimatedRowHeight = 180;
    self.popularTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.popularTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.popularTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.popularTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    //self.popularArr = [LCDataManager sharedInstance].popularTourpicArray;
    //    [self updatePopularScrollView];
}

#pragma mark -NetRequest.

- (void)getPopularTourpicList {
//    [LCNetRequester <#(NSString *)#> orderStr:<#(NSString *)#> callBack:<#^(NSArray *tourpicList, NSString *orderStr, NSError *error)callBack#>]
    [LCNetRequester getPlanLinkingTourpicWithPlanGuid:self.planGuid orderStr:self.popularOrderStr callBack:^(NSArray *tourpicList, NSString *orderStr, NSError *error) {
        [self.popularTableView headerEndRefreshing];
        [self.popularTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.popularOrderStr]) {
                if (nil != tourpicList) {
                    self.popularArr = tourpicList;
                } else {
                    self.popularArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != tourpicList) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.popularArr];
                    [mutArr addObjectsFromArray:tourpicList];
                    self.popularArr = mutArr;
                }
            }
            self.popularOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (LCTourpicCell *)configurePopularTourpicViewCell:(NSIndexPath *)indexPath {
    LCTourpicCell *cell = [self.popularTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    LCTourpic *tourpic = [self.popularArr objectAtIndex:indexPath.row];
    [cell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Cell];
    return cell;
}

- (void)updateShow {
    [self.popularTableView reloadData];
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self configurePopularTourpicViewCell:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //if (tableView == self.popularTableView) {
        return self.popularArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.popularArr.count) {
        LCTourpic *tourpic = [self.popularArr objectAtIndex:indexPath.row];
        [self showTourpicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal];
    }
}


- (void)updateTableViewDataSource {
    [self getPopularTourpicList];
}

- (void)headerRefreshAction {
    self.popularOrderStr = @"";

    [self updateTableViewDataSource];
}

- (void)footerRefreshAction {
    [self updateTableViewDataSource];
}

- (void)showTourpicDetail:(LCTourpic *)tourpic withType:(LCTourpicDetailVCViewType)type {
    LCTourpicDetailVC *vc = [LCTourpicDetailVC createInstance];
    vc.tourpic = tourpic;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

#pragma mark - LCTourpicCell Delegate
//- (void)tourpicLikeSelected:(LCTourpicCell *)cell {
//    [self cellLikedAction:cell.tourpic];
//}

- (void)tourpicFocusSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    LCTourpic *tourpic = cell.tourpic;
    LCUserModel *user = tourpic.user;
    
    if (1 == user.isFavored) {
        user.isFavored = 0;
        [LCNetRequester unfollowUser:user.uUID callBack:^(LCUserModel *user, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                user.isFavored = 0;
            }
        }];
    } else {
        user.isFavored = 1;
        [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                user.isFavored = 1;
            }
        }];
    }
    [self updateShow];
}

- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Comment];
    [self showTourpicDetail:cell.tourpic withType:LCTourpicDetailVCViewType_Comment];
}

- (void)forwardTourpic:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Share];
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
    }
    self.shareView.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    [LCShareView showShareView:self.shareView onViewController:self forTourpic:cell.tourpic];
    //[LCShareUtil shareTourpicWeixinAction:cell.tourpic presentedController:self];
}

- (void)viewTourpicPhoto:(LCTourpicCell *)cell{
    NSMutableArray *imageModels = [[NSMutableArray alloc] init];
    NSInteger imageIndex = 0;
  
        for(LCTourpic *tourpic in self.popularArr){
            LCImageModel *model = [[LCImageModel alloc] init];
            model.imageUrl = tourpic.picUrl;
            model.imageUrlThumb = tourpic.thumbPicUrl;
            [imageModels addObject:model];
        }
        
        NSIndexPath *indexPath = [self.popularTableView indexPathForCell:cell];
        imageIndex = indexPath.row;
    
    LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
    [photoScanner showImageModels:imageModels fromIndex:imageIndex];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
}

//- (void)viewTourpicPhoto:(LCTourpicCell *)cell{
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark LCShareView Delegate
- (void)cancelShareAction {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
    }];
}

- (void)shareTourpicWeixin:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixin");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicWeixinAction:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicWeixinTimeLine:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixinTimeLine");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicWeixinTimeLine:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicWeibo:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeibo");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicWeibo:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicQQ:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicQQ");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
        self.tabBarController.tabBar.hidden = NO;
        [LCShareUtil shareTourpicQQ:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

//#pragma mark cellAction
//- (void)cellLikedAction:(LCTourpic *)tourpic {
//    if (![self haveLogin]) {
//        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
//        return ;
//    }
//    if (LCTourpicLike_IsLike == tourpic.isLike) {
//        tourpic.isLike = LCTourpicLike_IsUnlike;
//        if (tourpic.likeNum - 1 >= 0) {
//            tourpic.likeNum -= 1;
//        }
//        [LCNetRequester unlikeTourpic:tourpic.guid callBack:^(NSInteger likeNum, NSInteger isLike, NSError *error) {
//            if (!error) {
//                tourpic.likeNum = likeNum;
//                tourpic.isLike = isLike;
//            } else {
//                [YSAlertUtil tipOneMessage:error.domain];
//            }
//        }];
//    } else {
//        tourpic.isLike = LCTourpicLike_IsLike;
//        tourpic.likeNum += 1;
//        // 1为点赞，2为转发
//        [LCNetRequester likeTourpic:tourpic.guid withType:@"1" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
//            if (!error) {
//                tourpic.likeNum = likeNum;
//                tourpic.forwardNum = forwardNum;
//                tourpic.isLike = isLike;
//            } else {
//                [YSAlertUtil tipOneMessage:error.domain];
//            }
//        }];
//    }
//    [self updateShow];
//}


@end
