//
//  LCPlanCommentVC.m
//  LinkCity
//
//  Created by roy on 11/17/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCPlanCommentVC.h"
#import "LCPlanApi.h"
#import "YSAlertUtil.h"
#import "LCPlanCommentTableViewCell.h"
#import "LCPlanApi.h"
#import "MJRefresh.h"
#import "DXMessageToolBar.h"
#import "LCTextMessageToolBar.h"
#import "LCPlanCommentTableViewCell.h"

#define COMMENT_BASE_PLACEHOLDER @"添加评论"
@interface LCPlanCommentVC ()<LCPlanApiDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,LCTextMessageToolBarDelegate,UIScrollViewDelegate, LCPlanCommentTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *commentContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentContainerBottomLineHeight;


//viewDidLoad后，是否viewDidLayout过
@property (nonatomic,assign) BOOL haveLayout;
@property (nonatomic,strong) NSArray *comments;
@property (nonatomic,strong) LCPlan *plan;

//当前先中的comment table index
@property (nonatomic,assign) NSInteger selectedRowIndex;

//是否下拉刷新---否是是上拉刷新
@property (nonatomic, assign) BOOL isPullHeaderAction;

@property (nonatomic, strong) LCTextMessageToolBar *inputToolBar;
@end

@implementation LCPlanCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.haveLayout = NO;
    
    self.title = @"评论";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //设置上下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (!self.haveLayout) {
        [self addInputToolbar];
        self.haveLayout = YES;
        self.commentContainerBottomLineHeight.constant = 0.5;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //主动刷新
    [self.tableView headerBeginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)showCommentForPlan:(LCPlan *)plan{
    _plan = plan;
}

#pragma mark - MJRefresh
- (void)headerRereshing
{
    self.isPullHeaderAction = YES;
    [self requestPlanCommentFromTimestamp:nil];
}

- (void)footerRereshing
{
    self.isPullHeaderAction = NO;
    if (!self.comments || self.comments.count<=0){
        [self requestPlanCommentFromTimestamp:nil];
    }else{
        LCCommentModel *comment = [self.comments objectAtIndex:self.comments.count-1];
        [self requestPlanCommentFromTimestamp:comment.timestamp];
    }
}

#pragma mark - LCInput Text View
- (void)addInputToolbar{
    if (!self.inputToolBar) {
        self.inputToolBar = [[LCTextMessageToolBar alloc]initWithFrame:CGRectMake(0, 58/2-[LCTextMessageToolBar defaultHeight]/2, DEVICE_WIDTH, [LCTextMessageToolBar defaultHeight])];
        self.inputToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        self.inputToolBar.inputTextView.placeHolder = @"添加评论";
        self.inputToolBar.inputTextView.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
        self.inputToolBar.inputTextView.textColor = UIColorFromR_G_B_A(196, 191, 187, 1);
        self.inputToolBar.delegate = self;
    }
    [self.commentContainerView addSubview:self.inputToolBar];
}
- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    RLog(@"%f",toHeight);
    self.commentContainerViewHeight.constant = toHeight+58-[LCTextMessageToolBar defaultHeight];
    //self.commentContainerViewHeight.constant = toHeight;
}
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView{
    RLog(@"did begin edit");
}
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    RLog(@"will begin edit");
}
- (void)didSendText:(NSString *)text{
    RLog(@"did send %@",text);
    if ([self.inputToolBar.inputTextView.placeHolder isEqualToString:COMMENT_BASE_PLACEHOLDER]) {
        //直接评论，没回回复
        [self addComment:text replyTo:nil];
    }else{
        //回复某人
        LCCommentModel *com = [self.comments objectAtIndex:self.selectedRowIndex];
        [self addComment:text replyTo:com.commentID];
    }
    self.inputToolBar.inputTextView.placeHolder = COMMENT_BASE_PLACEHOLDER;
}

#pragma mark - LCPlanApiDelegate
- (void)planApi:(LCPlanApi *)api didGetComments:(NSArray *)comments withError:(NSError *)error{
    if (error) {
        RLog(@"get comment failed. %@",error.domain);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"did get comment list succeed!");
        if (self.isPullHeaderAction) {
            //下拉刷新
            self.comments = comments;
            [self.tableView scrollsToTop];
        }else{
            //上拉刷新
            if(!comments || comments.count<=0){
                [YSAlertUtil tipOneMessage:@"没有更多了" delay:TIME_FOR_RIGHT_TIP];
            }else{
                self.comments = [self.comments arrayByAddingObjectsFromArray:comments];
            }
        }
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}
- (void)planApi:(LCPlanApi *)api didAddCommentWithError:(NSError *)error{
    if (error) {
        NSString *errMsg = [NSString stringWithFormat:@"评论失败.%@",error.domain];
        [YSAlertUtil tipOneMessage:errMsg delay:TIME_FOR_ERROR_TIP];
    }else{
        [YSAlertUtil tipOneMessage:@"评论成功!" delay:TIME_FOR_RIGHT_TIP];
        //评论成功后，相当于进行一次下拉刷新
        self.isPullHeaderAction = YES;
        [self requestPlanCommentFromTimestamp:nil];
    }
}

#pragma mark - LCPlanCommentTableViewCell Delegate
- (void)avatarPressed:(NSInteger)row {
    LCCommentModel *model = [self.comments objectAtIndex:row];
    [LCViewSwitcher pushToShowUserInfo:model.userInfo onNavigationVC:self.navigationController];
}

#pragma mark - UITableView delgate & dataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.comments.count) {
        LCCommentModel *comment = [self.comments objectAtIndex:indexPath.row];
        float caculatedCellHeight = [LCStringUtil getHeightOfString:comment.content
                                                                 withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:14]
                                                                lineSpace:11
                                                               labelWidth:(tableView.frame.size.width-40)];
        caculatedCellHeight += 100;
        caculatedCellHeight = MAX(100, caculatedCellHeight);
        //RLog(@"caculated cell height: %f, row:%ld, textHeight:%f",caculatedCellHeight,(long)indexPath.row,caculatedCellHeight-100);
        return caculatedCellHeight;
    }
    
    RLog(@"caculate comment cell height error");
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCPlanCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanCommentCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.row = indexPath.row;
    cell.comment = [self.comments objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRowIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isInputting]) {
        [self.inputToolBar.inputTextView resignFirstResponder];
        self.inputToolBar.inputTextView.placeHolder = COMMENT_BASE_PLACEHOLDER;
    }else{
        [self.inputToolBar.inputTextView becomeFirstResponder];
        LCCommentModel *com = [self.comments objectAtIndex:indexPath.row];
        self.inputToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复:%@:",com.userInfo.nick];
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if ([self isInputting]) {
//        [self.inputToolBar.inputTextView resignFirstResponder];
//        self.inputToolBar.inputTextView.placeHolder = COMMENT_BASE_PLACEHOLDER;
//    }
//}

#pragma mark - InnerFunction
- (void)addComment:(NSString *)comment replyTo:(NSString *)commentID{
    RLog(@"Comment:%@ to comID:%@",comment,commentID);
    LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
    [planApi addCommentToPlanGuid:self.plan.planGuid planType:self.plan.planType comment:comment replyToComment:commentID];
}
- (void)requestPlanCommentFromTimestamp:(NSString *)timestamp{
    LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
    [planApi getCommentsFromPlanGuid:self.plan.planGuid planType:self.plan.planType startFromTimeStamp:timestamp];
}
- (BOOL)isInputting{
    return [self.inputToolBar.inputTextView isFirstResponder];
}
@end
