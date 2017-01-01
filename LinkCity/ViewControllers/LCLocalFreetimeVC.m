//
//  LCLocalFreetimeVC.m
//  LinkCity
//
//  Created by linkcity on 16/7/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocalFreetimeVC.h"
#import "LCLocalFreetimeCell.h"
#import "UzysDragMenu.h"
#import "UzysDragMenuItemView.h"
#import "LCNetRequester+Local.h"
#import "LCLocalSelectThemeView.h"

#define LocalTime (48)

@interface LCLocalFreetimeVC ()<UITableViewDelegate,UITableViewDataSource,LCLocalSelectThemeViewDelegate,UzysDragMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *freeTimeArr;//缓存中显示的用户列表
@property (strong, nonatomic) NSDate *localselectedTime;//上次选择主题时间
@property (strong, nonatomic) NSString *orderStr;                // 数据请求顺序.
@property (assign, nonatomic) NSInteger fitlerThemeId;//筛选主题
@property (assign, nonatomic) NSInteger joinThemeId;//加入主题

@property (strong, nonatomic) NSString *ThemeStr;   //join用户自定义主题
@property (assign, nonatomic) UserSex inviteSex;
@property (assign, nonatomic) LCLocalSelectedType inviteOrderType;
@property (nonatomic,strong) UIView* backgroundView;

@property (nonatomic,assign) BOOL isOpen;//初始化是否展开
@property (nonatomic,strong) UzysDragMenu *uzysDmenu;
@property (nonatomic, strong) KLCPopup *localFilterPopup;


@end

@implementation LCLocalFreetimeVC

+ (instancetype)createInstance {
    return (LCLocalFreetimeVC *)[LCStoryboardManager viewControllerWithFileName:SBNameLocalTab identifier:VCIDLocalFreetimeVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
//    self.freeTimeArr = [[LCDataManager sharedInstance] freeTimeArr];//从本地缓存取出数组内容
    self.localselectedTime=[[LCDataManager sharedInstance] localSelectedTime];//取上次选择主题时间
    self.title = @"同城有空";
    self.orderStr=[NSString stringWithFormat:@""];
    self.inviteOrderType=LCLocalSelectedType_DepartTime;
    self.fitlerThemeId=0;
    //判断是否弹出菜单
    NSInteger hour=[LCDateUtil getTwoDateInterval:self.localselectedTime withDate2:[NSDate date]];
    if(self.localselectedTime&&hour<3600*LocalTime) {
        self.isOpen=NO;
    } else {
        self.isOpen=YES;
    }
    
    [self initTableView];
    [self requestFromServer];
    [self initNavigationBar];
    [self showPopView];//显示下面部分菜单
    [self initNotification];
}
- (void)initNotification {
    [self addObserveToNotificationNameToRefreshData:URL_GET_USER_RED_DOT_V_FIVE];//注册更新红点

}
- (void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound){//判断是否是返回上一界面，即当前界面释放
        //用户点击了返回按钮
        [self.uzysDmenu removeObserver:self.uzysDmenu forKeyPath:@"superview.frame"];//清除KVO监听self.uzysDmenu
        [self.uzysDmenu removeFromSuperview];
    }
    [super viewWillDisappear:animated];
}

//- (void)initShadowView {//阴影遮罩添加点击事件
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapAction:)];
//    [self.shadowView addGestureRecognizer:tapGesture];
//}

-(void)showPopView {
    UzysDragMenuControlView *controlView = [[[NSBundle mainBundle] loadNibNamed:@"UzysDragMenuControlView" owner:self options:nil] lastObject];
    [controlView.btnAction addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.isOpen = YES;
    self.uzysDmenu = [[UzysDragMenu alloc] initWithcontrolMenu:controlView superViewGesture:YES Open:self.isOpen];
    self.uzysDmenu.localDelegate = self;
    [self.view addSubview:self.uzysDmenu];
}



-(IBAction)actionBtn:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(self.isOpen) {//开
        self.isOpen = NO;
    }
    else {
        self.isOpen = YES;
    }
    [self.uzysDmenu toggleMenu];
}

#pragma mark UzysDragMenuDelegate
- (void)localDidSelectselfTheme:(NSString*)ThemeStr {
    self.view.backgroundColor = [UIColor whiteColor];
    self.isOpen = NO;
    [self.uzysDmenu closeMenu];
    self.ThemeStr=ThemeStr;
    //更新界面
    [self.tableView headerBeginRefreshing];
    [self requestToJoinLocal];
}

-(void)localDidSelectTheme:(NSInteger)ThemeID {
    self.view.backgroundColor = [UIColor whiteColor];
    self.isOpen = NO;
    [self.uzysDmenu closeMenu];
    self.joinThemeId=ThemeID;
    self.ThemeStr=@"";
    [self.tableView headerBeginRefreshing];
    [self requestToJoinLocal];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.hidden = YES;
    //更新红点数
        [[LCRedDotHelper sharedInstance] startUpdateRedDot];
    //[self.navigationController.navigationBar setTintColor:];
}

- (void)initNavigationBar {
    UIImage *addRightIcon = [[UIImage imageNamed:@"LocalTabClearTabFiltClear"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *addFriendButton = [[UIBarButtonItem alloc] initWithImage:addRightIcon style:UIBarButtonItemStylePlain target:self action:@selector(addFilterAction)];
    self.navigationItem.rightBarButtonItem = addFriendButton;
}

-(void)addFilterAction{
    static CGFloat centerY = 0;
    if (!self.localFilterPopup) {
        LCLocalSelectThemeView *localFilterView = [LCLocalSelectThemeView createInstance];
        localFilterView.delegate = self;
        self.localFilterPopup = [KLCPopup popupWithContentView:localFilterView
                                                     showType:KLCPopupShowTypeSlideInFromTop
                                                  dismissType:KLCPopupDismissTypeSlideOutToTop
                                                     maskType:KLCPopupMaskTypeDimmed
                                     dismissOnBackgroundTouch:YES
                                        dismissOnContentTouch:NO];
       centerY = [localFilterView intrinsicContentSize].height / 2;
    }
    [self.localFilterPopup showAtCenter:CGPointMake(DEVICE_WIDTH / 2,centerY+80) inView:nil];
}

- (void)inviteFilterViewDidFilter:(LCLocalSelectThemeView *)userFilterView fitlerThemeId:(NSInteger)themeId userSex:(UserSex)sex filtType:(LCLocalSelectedType)type {
    [self.localFilterPopup dismissPresentingPopup];
    self.inviteSex = sex;
    self.inviteOrderType = type;
    self.fitlerThemeId = themeId;
    self.orderStr = @"";
    self.freeTimeArr = [[NSArray alloc] init];
    [self.tableView headerBeginRefreshing];
}

#pragma mark - Init
-(void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 90.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCLocalFreetimeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCLocalFreetimeCell class])];
//    self.tableView.backgroundColor=[UIColor blackColor];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}
#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserModel *model = [self.freeTimeArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:model on:self.navigationController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.freeTimeArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLocalFreetimeCell * cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCLocalFreetimeCell class])];
    LCUserModel *model = [self.freeTimeArr objectAtIndex:indexPath.row];
    [cell updateShowCell:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)updateView{//更新UI，选择主题、筛选条件
    
    [self.tableView reloadData];

}

#pragma mark - Server Request.
// 下拉刷新.
- (void)headerRefreshAction {//OrderStr赋值为空
    self.orderStr=@"";
    [self requestFromServer];
}

/// 上拉加载更多.
- (void)footerRefreshAction {//使用上一次返回的OrderStr即为加载下一页
    [self requestFromServer];
}
- (void)updateReddot {
    [[LCRedDotHelper sharedInstance] startUpdateRedDot];
}
- (void)requestFromServer {//获取默认列表信息
    __weak typeof(self) weakself = self;
    
    [LCNetRequester requestLocalList:self.orderStr themeId:self.fitlerThemeId sex:self.inviteSex orderType:self.inviteOrderType withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakself.tableView headerEndRefreshing];
        [weakself.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakself.freeTimeArr]) {
                if (nil != contentArr)
                    weakself.freeTimeArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:contentArr];
                 else
                    weakself.freeTimeArr = [[NSArray alloc] init];
            } else {
                if (nil != contentArr)
                    weakself.freeTimeArr = [LCSharedFuncUtil addFiltedArrayToArray:contentArr withUnfiltedArray:self.freeTimeArr];
            }
            [weakself.tableView reloadData];
//            [LCDataManager sharedInstance].freeTimeArr = weakself.freeTimeArr;
            weakself.orderStr=orderStr;
            [weakself updateReddot];//更新红点
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

//加入同城有空
- (void)requestToJoinLocal {
    __weak typeof(self) weakself = self;
    [LCNetRequester requestToJoinLocalwiththemeId:self.joinThemeId ThemeStr:self.ThemeStr withCallBack:^(NSArray *contentArr,NSError *error) {
        if (!error) {
            weakself.orderStr=@"";
//            [weakself requestFromServer];
//            [weakself.tableView headerBeginRefreshing];
            weakself.localselectedTime= [NSDate date];
            [LCDataManager sharedInstance].localSelectedTime = weakself.localselectedTime;
            [[LCDataManager sharedInstance]  saveData];
            [weakself requestFromServer];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
