//
//  LCTourpicDetailVC.m
//  LinkCity
//
//  Created by 张宗硕 on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicDetailVC.h"
#import "LCTourpicCell.h"
#import "LCTourpicLikedCell.h"
#import "LCTourpicCommentCell.h"
#import "LCTourPicDetailPlanInfoCell.h"
#import "LCTourpicComment.h"
#import "LCTextMessageToolBar.h"
#import "MJRefresh.h"

@interface LCTourpicDetailVC ()<UITableViewDataSource, UITableViewDelegate, LCTourpicCellDelegate, LCTextMessageToolBarDelegate, LCTourpicCellDelegate, LCShareViewDelegate, UIScrollViewDelegate, LCTourpicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContainerHeight;
@property (retain, nonatomic) LCTextMessageToolBar *inputToolBar;
@property (assign, nonatomic) NSInteger selectedRowIndex;
@property (retain, nonatomic) NSString *orderStr;
@property (retain, nonatomic) NSArray *commentArr;
@property (nonatomic, assign) BOOL haveReloadTableForLoadTourpic;
@property (nonatomic, strong) LCPlanModel *planModel;

@property (nonatomic, strong) LCTourpicCell *tourPicCell;
@property (nonatomic, strong) LCTourPicDetailPlanInfoCell *planInfoCell;
@property (retain, nonatomic) LCShareView *shareView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;


@end

#define TOURPIC_COMMENT_PLACEHOLDER @"想说点什么"

@implementation LCTourpicDetailVC

#pragma mark - Public Interface.

+ (instancetype)createInstance {
    return (LCTourpicDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicDetail];
}

#pragma mark - Lifecycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTableView];
    [self initNotifications];
    /// 初始化评论阴影遮罩
    [self initShadowView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.inputToolBar) {
        [self addInputToolbar];
    }
    if (self.type == LCTourpicDetailVCViewType_Comment) {
        [self.inputToolBar.inputTextView becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
    [self.inputToolBar removeFromSuperview];
    self.inputToolBar = nil;
}

#pragma mark - Init.

- (void)initVariable {
    self.orderStr = @"";
    self.commentArr = self.tourpic.commentArr;
    self.haveReloadTableForLoadTourpic = NO;
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicLikedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicLikedCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCommentCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpic class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpic class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourPicDetailPlanInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourPicDetailPlanInfoCell class])];
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)initNotifications {
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_LIKE];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_UNLIKE];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_ADD_COMMENT];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_DELETE_COMMENT];
}

- (void)initShadowView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapAction:)];
    [self.shadowView addGestureRecognizer:tapGesture];
}

#pragma mark - Update.
- (void)refreshData {
    self.orderStr = @"";
    self.commentArr = [[NSArray alloc] init];
    [self requestTourpicDetailFromServer];
    [self requestTourpicCommentFromServer];
}

- (void)footerRefreshAction {
    [self requestTourpicCommentFromServer];
}

- (void)updateShow {
    /*if (0 == self.commentArr.count) {
        [self.tableView removeFooter];
    } else {
        [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    }*/
    [self.tableView reloadData];
}

-(void)shadowViewTapAction:(id)sender {
    self.shadowView.hidden = YES;
    if (self.inputToolBar) {
        [self.inputToolBar.inputTextView resignFirstResponder];
    }
}

#pragma mark NetRequest.
- (void)requestTourpicDetailFromServer {
    [LCNetRequester getTourpicDetail:self.tourpic.guid callBack:^(LCTourpic *tourpic,LCPlanModel *planModel, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (nil != planModel) {
            self.planModel = planModel;
        }
        if (nil != tourpic) {
            self.tourpic = tourpic;
            [self updateShow];
        }
        
        self.haveReloadTableForLoadTourpic = NO;
    }];
}

- (void)requestTourpicCommentFromServer {
    [LCNetRequester getTourpicMoreComment:self.tourpic.guid withOrderStr:self.orderStr callBack:^(NSArray *commentArr, NSString *orderStr, NSError *error) {
        [self.tableView footerEndRefreshing];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != commentArr) {
                    self.commentArr = commentArr;
                }
            } else {
                if (nil != commentArr) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.commentArr];
                    [mutArr addObjectsFromArray:commentArr];
                    self.commentArr = mutArr;
                }
            }
            self.orderStr = orderStr;
            [self updateShow];
        }
    }];
}

#pragma mark - Functions.
//- (void)scrollCommentCell {
//    if (nil != self.commentArray && self.commentArray.count > 0) {
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//}

#pragma mark - Actions.
- (IBAction)shareTourpicAction:(id)sender {
    [MobClick event:Mob_TourPicList_Share];
    
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
    }
    self.shareView.delegate = self;
    self.shareView.hidden = NO;
    [self.inputToolBar.inputTextView resignFirstResponder];

    [LCShareView showShareView:self.shareView onViewController:self forTourpic:self.tourpic];
}

#pragma mark - Configure Cell Appearance.

- (UITableViewCell *)configureTourpicViewCell:(NSIndexPath *)indexPath {
    UITableViewCell *tourpicCell = nil;
    if (0 == indexPath.row) {
        LCTourpicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
        self.tourPicCell = cell;
        cell.delegate = self;
        [cell updateTourpicCell:self.tourpic withType:LCTourpicCellViewType_Detail];
    
        tourpicCell = cell;
    } else if (1 == indexPath.row) {
        LCTourPicDetailPlanInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourPicDetailPlanInfoCell class]) forIndexPath:indexPath];
        self.planInfoCell = cell;
        [cell bindWithData:self.planModel];
        tourpicCell = cell;
    }
    return tourpicCell;
}

- (LCTourpicLikedCell *)configueTourpicLikedCell:(NSIndexPath *)indexPath {
    LCTourpicLikedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicLikedCell class]) forIndexPath:indexPath];
    
    [cell updateLikedCell:self.tourpic];
    
    return cell;
}

- (LCTourpicCommentCell *)configueTourpicCommentCell:(NSIndexPath *)indexPath {
    LCTourpicCommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCommentCell class]) forIndexPath:indexPath];
    
    if (indexPath.row < self.commentArr.count) {
        LCTourpicComment *comment = [self.commentArr objectAtIndex:indexPath.row];
        [cell updateCommentCell:comment];
    }
    return cell;
}

#pragma mark - UITableView Delegate.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (0 == indexPath.section) {
        cell = [self configureTourpicViewCell:indexPath];
    } else if (1 == indexPath.section) {
        cell = [self configueTourpicLikedCell:indexPath];
    } else if (2 == indexPath.section) {
        cell = [self configueTourpicCommentCell:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (0 == section) {
        if (self.planModel) {
            number = 2;
        } else {
            number = 1;
        }
    } else if (1 == section) {
        if (self.tourpic.likedArr.count > 0) {
            number = 1;
        } else {
            number = 0;
        }
    } else if (2 == section) {
        number = self.commentArr.count;
    }
    return number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:APP_ANIMATION];
    self.selectedRowIndex = indexPath.row;
    if (2 == indexPath.section) {
        if ([self isInputting]) {
            [self.inputToolBar.inputTextView resignFirstResponder];
            self.inputToolBar.inputTextView.placeHolder = TOURPIC_COMMENT_PLACEHOLDER;
        } else {
            [self.inputToolBar.inputTextView becomeFirstResponder];
            if (self.commentArr.count > indexPath.row) {
                LCTourpicComment *comment = [self.commentArr objectAtIndex:indexPath.row];
                self.inputToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复:%@:",comment.user.nick];
            }
            
        }
    } else if (0 == indexPath.section && 1 == indexPath.row) {
        [MobClick event:V5_TOURPIC_DETAIL_PLAN_CLICK];
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.planModel recmdUuid:nil on:self.navigationController];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if (2 == section) {
        height = 35.0f;
        if (0 == self.tourpic.likedArr.count) {
            height += 12.0f;
        }
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    if (2 == section && self.commentArr.count > 0) {
        CGFloat gapHeight = 0.0f;
        if (0 == self.tourpic.likedArr.count) {
            gapHeight = 12.0f;
        }
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 35.0f + gapHeight)];
        view.backgroundColor = [UIColor whiteColor];
        
        if (0.0f != gapHeight) {
            UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, gapHeight)];
            gapView.backgroundColor = UIColorFromRGBA(0xf7f7f5, 1.0f);
            [view addSubview:gapView];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, gapHeight + 14.0, 100.0f, 16.0)];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0);
        label.text = [NSString stringWithFormat:@"评论（%ld）", (long)self.tourpic.commentNum];
        [view addSubview:label];
    }
    return view;
}

#pragma mark - LCTourpicCell Delegate.
//- (void)tourpicLikeSelected:(LCTourpicCell *)cell {
//    if (![self haveLogin]) {
//        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
//        return ;
//    }
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    LCTourpic *tourpic = cell.tourpic;
//    if (nil != indexPath) {
//        if (LCTourpicLike_IsLike == tourpic.isLike) {
//            tourpic.isLike = LCTourpicLike_IsUnlike;
//            if (tourpic.likeNum - 1 >= 0) {
//                tourpic.likeNum -= 1;
//            }
//            [LCNetRequester unlikeTourpic:tourpic.guid callBack:^(NSInteger likeNum, NSInteger isLike, NSError *error) {
//                if (!error) {
//                    tourpic.likeNum = likeNum;
//                    tourpic.isLike = isLike;
//                } else {
//                    [YSAlertUtil tipOneMessage:error.domain];
//                }
//            }];
//        } else {
//            tourpic.isLike = LCTourpicLike_IsLike;
//            tourpic.likeNum += 1;
//            // 1为点赞，2为转发
//            [LCNetRequester likeTourpic:tourpic.guid withType:@"1" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
//                if (!error) {
//                    tourpic.likeNum = likeNum;
//                    tourpic.forwardNum = forwardNum;
//                    tourpic.isLike = isLike;
//                } else {
//                    [YSAlertUtil tipOneMessage:error.domain];
//                }
//            }];
//        }
//        [self updateShow];
//    }
//}

- (void)tourpicFocusSelected:(LCTourpicCell *)cell {
//    if (![self haveLogin]) {
//        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
//        return ;
//    }
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    LCTourpic *tourpic = cell.tourpic;
//    LCUserModel *user = tourpic.user;
//    
//    if (nil != indexPath) {
//        if (1 == user.isFavored) {
//            user.isFavored = 0;
//            [LCNetRequester unfollowUser:user.uUID callBack:^(LCUserModel *user, NSError *error) {
//                if (error) {
//                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
//                } else {
//                    user.isFavored = 0;
//                }
//            }];
//        } else {
//            user.isFavored = 1;
//            [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
//                if (error) {
//                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
//                } else {
//                    user.isFavored = 1;
//                }
//            }];
//        }
//        [self updateShow];
//    }
}

- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicDetail_Comment];
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    [self.inputToolBar.inputTextView becomeFirstResponder];
    //self.inputToolBar.inputTextView.placeHolder = @"122";
}

- (void)clickPlaceBtn:(LCTourpicCell *)cell{
    [MobClick event:Mob_TourPicDetail_Place];
    if ([LCStringUtil isNotNullString:cell.tourpic.placeName]) {
        [LCViewSwitcher pushToShowTourPicTableVCForKeyWord:cell.tourpic.placeName on:self.navigationController];
    }
}

- (void)tourpicCell:(LCTourpicCell *)cell didLoadPicSucceed:(BOOL)succeed{
    if (succeed && !self.haveReloadTableForLoadTourpic) {
        self.haveReloadTableForLoadTourpic = YES;
        [self.tableView reloadData];
    }
}

- (void)viewTourpicPhoto:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicDetail_Image];
    LCImageModel *model = [[LCImageModel alloc] init];
    model.imageUrl = self.tourpic.picUrl;
    model.imageUrlThumb = self.tourpic.thumbPicUrl;
    
    LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
    [photoScanner showImageModels:@[model] fromIndex:0];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
}

#pragma mark - LCShareView Delegate.

- (void)cancelShareAction {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:nil];
}

- (void)shareTourpicWeixin:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixin");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareTourpicWeixinAction:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self.tableView reloadData];
            }
        }];
    }];
}

- (void)shareTourpicWeixinTimeLine:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixinTimeLine");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareTourpicWeixinTimeLine:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self.tableView reloadData];
            }
        }];
    }];
}

- (void)shareTourpicWeibo:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeibo");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareTourpicWeibo:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self.tableView reloadData];
            }
        }];
    }];
}

- (void)shareTourpicQQ:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicQQ");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
        [LCShareUtil shareTourpicQQ:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self.tableView reloadData];
            }
        }];
    }];
}

#pragma mark - LCInput Text View
- (void)addInputToolbar {
    if (!self.inputToolBar) {
        self.inputToolBar = [[LCTextMessageToolBar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, [LCTextMessageToolBar defaultHeight])];
        self.inputToolBar.translatesAutoresizingMaskIntoConstraints = YES;
        self.inputToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        self.inputToolBar.inputTextView.placeHolder = TOURPIC_COMMENT_PLACEHOLDER;
        
        self.inputToolBar.backgroundColor = [UIColor whiteColor];
        self.inputToolBar.inputTextView.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
        self.inputToolBar.inputTextView.layer.borderColor = UIColorFromRGBA(LCBottomLineColor, 1).CGColor;
        self.inputToolBar.inputTextView.layer.borderWidth = 0.5f;
        self.inputToolBar.inputTextView.layer.cornerRadius = 4.0f;
        self.inputToolBar.inputTextView.layer.masksToBounds = YES;
        self.inputToolBar.inputTextView.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
        self.inputToolBar.inputTextView.textColor = UIColorFromRGBA(LCDarkTextColor, 1);
        self.inputToolBar.delegate = self;
        self.inputToolBar.userInteractionEnabled = YES;
    }

    [self.inputContainer addSubview:self.inputToolBar];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight {
    LCLogInfo(@"%f",toHeight);
    //self.inputContainerHeight.constant = toHeight;
    CGFloat containerHeight = toHeight;
    self.inputContainer.frame = CGRectMake(0, DEVICE_HEIGHT-containerHeight, DEVICE_WIDTH, containerHeight);
}

- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView {
    LCLogInfo(@"did begin edit");
    self.shadowView.hidden = NO;
}

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView {
    LCLogInfo(@"will begin edit");
}

- (void)didSendText:(NSString *)text {
    LCLogInfo(@"did send %@",text);
    self.shadowView.hidden = YES;
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    if ([LCStringUtil isNullString:text]) {
        return ;
    }
    if ([self.inputToolBar.inputTextView.placeHolder isEqualToString:TOURPIC_COMMENT_PLACEHOLDER]) {
        /// 直接评论，没回回复.
        [LCNetRequester addTourpicComment:self.tourpic.guid withContent:text replyToId:DefaultTourpicCommentReplyToId callBack:^(LCTourpic *tourpic, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            } else {
                [YSAlertUtil tipOneMessage:@"评论成功!"];
                if (nil != tourpic) {
                    self.tourpic = tourpic;
                }
            }
        }];
    } else {
        LCTourpicComment *comment = [self.commentArr objectAtIndex:self.selectedRowIndex];
        [LCNetRequester addTourpicComment:comment.guid withContent:text replyToId:comment.commentId callBack:^(LCTourpic *tourpic, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            } else {
                [YSAlertUtil tipOneMessage:@"评论成功!"];
                if (nil != tourpic) {
                    self.tourpic = tourpic;
                }
            }
        }];
    }
    self.inputToolBar.inputTextView.placeHolder = TOURPIC_COMMENT_PLACEHOLDER;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isJustShowKeyboard && self.isShowingKeyboard) {
        [self.inputToolBar.inputTextView resignFirstResponder];
    }
}

#pragma mark - UITableView Delete Row.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL ret = NO;
    
    if (2 == indexPath.section) {
//        LCTourpicComment *comment = [self.commentArr objectAtIndex:indexPath.row - 2];
//        if ([LCStringUtil isNotNullString:[LCDataManager sharedInstance].userInfo.uUID] &&
//            [[LCDataManager sharedInstance].userInfo.uUID isEqualToString:comment.user.uUID]) {
//            //该评论是当前用户发的
//            ret = YES;
//        }

        ret = YES;
    }
    
    return ret;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (2 == indexPath.section) {
        LCTourpicComment *comment = [self.commentArr objectAtIndex:indexPath.row];
        
        [LCNetRequester deleteTourpicCommentWithCommentID:comment.commentId callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                NSMutableArray *mutableCommentArr = [NSMutableArray arrayWithArray:self.commentArr];
                [mutableCommentArr removeObjectAtIndex:indexPath.row];
                self.tourpic.commentArr = mutableCommentArr;
                self.commentArr = self.tourpic.commentArr;
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

#pragma mark - Inner Function
- (BOOL)isInputting {
    return [self.inputToolBar.inputTextView isFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    self.tourPicCell.userInteractionEnabled = NO;
    self.planInfoCell.userInteractionEnabled = NO;
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    self.tourPicCell.userInteractionEnabled = YES;
    self.planInfoCell.userInteractionEnabled = YES;
}
@end
