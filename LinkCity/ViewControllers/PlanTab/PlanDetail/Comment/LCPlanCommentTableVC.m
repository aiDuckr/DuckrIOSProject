//
//  LCPlanCommentTableVC.m
//  LinkCity
//
//  Created by roy on 3/22/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanCommentTableVC.h"
#import "LCPlanCommentCell.h"
#import "LCCommentModel.h"
#import "MJRefresh.h"
#import "LCTextMessageToolBar.h"


#define COMMENT_BASE_PLACEHOLDER @"添加评论"
@interface LCPlanCommentTableVC ()<UITableViewDataSource,UITableViewDelegate,LCTextMessageToolBarDelegate>
@property (nonatomic, strong) NSMutableArray *commentArray;    //array of LCCommentModel
//是否下拉刷新---否是是上拉刷新
@property (nonatomic, assign) BOOL isPullHeaderAction;
//当前先中的comment table index
@property (nonatomic,assign) NSInteger selectedRowIndex;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContainerHeight;

@property (nonatomic, strong) LCTextMessageToolBar *inputToolBar;
@end

@implementation LCPlanCommentTableVC

+ (instancetype)createInstance{
    return (LCPlanCommentTableVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanDetail identifier:VCIDPlanCommentTableVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveToNotificationNameToRefreshData:URL_ADD_COMMENT_TO_PLAN];
    
    self.view.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanCommentCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.inputToolBar) {
        [self addInputToolbar];
    }
}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow{
    [self.tableView reloadData];
}

- (void)requestPlanCommentFromOrderString:(NSString *)orderString{
    [LCNetRequester getCommentOfPlan:self.plan.planGuid corderString:orderString callBack:^(NSArray *commentArray, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            if (self.isPullHeaderAction) {
                //下拉刷新
                self.commentArray = [NSMutableArray arrayWithArray:commentArray];
            }else{
                //上拉加载更多
                if (!commentArray || commentArray.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.commentArray) {
                        self.commentArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [self.commentArray addObjectsFromArray:commentArray];
                }
            }
        }
        
        
        [self updateShow];
    }];
}


#pragma mark -
#pragma mark MJRefresh
- (void)headerRereshing
{
    self.isPullHeaderAction = YES;
    [self requestPlanCommentFromOrderString:nil];
}

- (void)footerRereshing
{
    self.isPullHeaderAction = NO;
    if (!self.commentArray || self.commentArray.count<=0){
        [self requestPlanCommentFromOrderString:nil];
    }else{
        LCCommentModel *lastComment = [self.commentArray lastObject];
        [self requestPlanCommentFromOrderString:lastComment.orderStr];
    }
}


#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCPlanCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanCommentCell class]) forIndexPath:indexPath];
    cell.comment = [self.commentArray objectAtIndex:indexPath.row];
    
    [cell setNeedsLayout];
    return cell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
    height = [LCPlanCommentCell getCellHeightForComment:aComment];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRowIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isInputting]) {
        [self.inputToolBar.inputTextView resignFirstResponder];
        self.inputToolBar.inputTextView.placeHolder = COMMENT_BASE_PLACEHOLDER;
    }else{
        [self.inputToolBar.inputTextView becomeFirstResponder];
        LCCommentModel *com = [self.commentArray objectAtIndex:indexPath.row];
        self.inputToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复:%@:",com.user.nick];
    }
}
#pragma mark TableView Delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果评论是自己发的，可以删除
    LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
    if ([aComment.user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
        return YES;
    }
    
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除评论
        LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
        [LCNetRequester deleteCommentOfPlanWithCommentID:aComment.commentId callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                [self.commentArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [tableView reloadData];
        }];
    }
}


#pragma mark - LCInput Text View
- (void)addInputToolbar{
    if (!self.inputToolBar) {
        self.inputToolBar = [[LCTextMessageToolBar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, [LCTextMessageToolBar defaultHeight])];
        self.inputToolBar.translatesAutoresizingMaskIntoConstraints = YES;
        self.inputToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        self.inputToolBar.inputTextView.placeHolder = @"添加评论";
        
        self.inputToolBar.backgroundColor = [UIColor whiteColor];
        self.inputToolBar.inputTextView.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
        self.inputToolBar.inputTextView.layer.borderColor = UIColorFromRGBA(LCBottomLineColor, 1).CGColor;
        self.inputToolBar.inputTextView.layer.borderWidth = 0.5;
        self.inputToolBar.inputTextView.layer.cornerRadius = 4;
        self.inputToolBar.inputTextView.layer.masksToBounds = YES;
        self.inputToolBar.inputTextView.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
        self.inputToolBar.inputTextView.textColor = UIColorFromRGBA(LCDarkTextColor, 1);
        self.inputToolBar.delegate = self;
    }
    [self.inputContainer addSubview:self.inputToolBar];
}
- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    LCLogInfo(@"%f",toHeight);
    self.inputContainerHeight.constant = toHeight;
}
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView{
    LCLogInfo(@"did begin edit");
}
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    LCLogInfo(@"will begin edit");
}
- (void)didSendText:(NSString *)text{
    LCLogInfo(@"did send %@",text);
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }else{
        if ([self.inputToolBar.inputTextView.placeHolder isEqualToString:COMMENT_BASE_PLACEHOLDER]) {
            //直接评论，没回回复
            [LCNetRequester addCommentToPlan:self.plan.planGuid content:text replyToId:DefaultCommentReplyToId score:DefaultPlanCommentScore withType:PlanCommentTypePlan callBack:^(LCCommentModel *comment, NSError *error) {
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                }else{
                    [YSAlertUtil tipOneMessage:@"评论成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }
            }];
        }else{
            //回复某人
            LCCommentModel *com = [self.commentArray objectAtIndex:self.selectedRowIndex];
            [LCNetRequester addCommentToPlan:self.plan.planGuid content:text replyToId:[LCStringUtil idToNSInteger:com.commentId] score:DefaultPlanCommentScore withType:PlanCommentTypePlan callBack:^(LCCommentModel *comment, NSError *error) {
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                }else{
                    [YSAlertUtil tipOneMessage:@"评论成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }
            }];
        }
        self.inputToolBar.inputTextView.placeHolder = COMMENT_BASE_PLACEHOLDER;
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isShowingKeyboard && !self.isJustShowKeyboard) {
        [self.view endEditing:YES];
    }
}

#pragma mark - Inner Function
- (BOOL)isInputting{
    return [self.inputToolBar.inputTextView isFirstResponder];
}

@end
