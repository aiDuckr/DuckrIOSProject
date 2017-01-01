//
//  LCContactListVC.m
//  LinkCity
//
//  Created by lhr on 16/6/8.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCContactListVC.h"
#import "LCHomeUserCell.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface LCContactListVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *searchResult;

@property (strong, nonatomic) NSArray *contactUserList;

@property (strong, nonatomic) NSMutableArray *chineseSortedArray;

@property (strong, nonatomic) NSMutableArray *sectionTitleArray;

@end

@implementation LCContactListVC

+ (instancetype)createInstance {
    return (LCContactListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDContactListVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactUserList = [[LCDataManager sharedInstance] contactUserList];
    [self initTableView];
    [self requestFromServer];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
    
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserModel *model = [self.contactUserList objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:model on:self.navigationController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactUserList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCHomeUserCell * cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class])];
    LCUserModel *model = [self.contactUserList objectAtIndex:indexPath.row];
    [cell updateShowCell:model withType:LCHomeUserCellViewType_HomeRecmOnlineDuckr];
    return cell;
}

- (void)sortByPinYin {
    //排序相关的代码 暂时不用，如果后面需要优化做本地昵称字母顺序排序需要对这个函数进行改造（sectionArray内容需要改成UserModel）
    NSMutableArray * keyArray = [[NSMutableArray alloc] init];
    for (LCUserModel *model in self.contactUserList) {
        [keyArray addObject:model.nick];
    }
     //= [self.contactUserList mutableCopy];
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[keyArray count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        chineseString.string=[NSString stringWithString:[keyArray objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.firstpinYin = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:0])]uppercaseString];
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    //排完序之后
    NSInteger section = 0;
    NSString *firstLetter = [[NSString alloc] init];
    firstLetter = @"notFirstLetter";
    
    NSMutableArray *sectionArray;
    for (ChineseString * chineseString in chineseStringsArray) {
        if (![firstLetter isEqualToString:chineseString.firstpinYin]) {
            if (section != 0) {
                [self.chineseSortedArray addObject:sectionArray];
            }
            section = section + 1;
            sectionArray = [NSMutableArray array];
            [self.sectionTitleArray addObject:chineseString.firstpinYin];
        }
        firstLetter = chineseString.firstpinYin;
        [sectionArray addObject:chineseString.string];
    }
    [self.chineseSortedArray addObject:sectionArray];
    
}


- (void)requestFromServer {
    //[[LCNetRequester getInstance] ]
    
    __weak typeof(self) weakself = self;
    [LCNetRequester getAllContactUserWithCallBack:^(NSArray *userList,NSError* error) {
        if (!error) {
            weakself.contactUserList = userList;
            //[weakself sortByPinYin];
            [weakself.tableView reloadData];
            [LCDataManager sharedInstance].contactUserList = weakself.contactUserList;
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
    
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
