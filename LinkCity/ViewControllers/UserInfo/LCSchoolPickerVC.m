//
//  LCSchoolPickerVC.m
//  LinkCity
//
//  Created by roy on 5/31/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSchoolPickerVC.h"
#import "LCSchoolCell.h"
#import "LCSearchBar.h"
#import "LCDialogInputter.h"

@interface LCSchoolPickerVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LCSearchBar *mySearchBar;

@property (nonatomic, strong) NSArray *schoolArray;
@end

@implementation LCSchoolPickerVC

+ (instancetype)createInstance{
    return (LCSchoolPickerVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDSchoolPickerVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mySearchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 2), 44.0f)];
    self.mySearchBar.delegate = self;
    self.mySearchBar.text = @"";
    [self.mySearchBar setPlaceholder:@"搜索学校"];
    self.mySearchBar.showsCancelButton = NO;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 2), 44.0f)];
    [searchView addSubview:self.mySearchBar];
    self.navigationItem.titleView = searchView;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(tableViewDidPan:)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mySearchBar becomeFirstResponder];
    self.mySearchBar.text = [LCStringUtil getNotNullStr:self.defaultSearchStr];
}

static NSString *lastSearchStr = @"";
- (void)searchSchoolBySearchStr:(NSString *)searchStr{
    if ([LCStringUtil isNullString:searchStr] ||
        [searchStr isEqualToString:lastSearchStr]) {
        return;
    }
    
    lastSearchStr = searchStr;
    
    LCLogInfo(@"searchSchoolBySearchStr:%@",searchStr);
    
    if ([LCStringUtil isNotNullString:searchStr]) {
        [LCNetRequester getSchoolListByString:searchStr callBack:^(NSArray *schoolArray, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
            }else{
                self.schoolArray = schoolArray;
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.mySearchBar resignFirstResponder];
    
    [self searchSchoolBySearchStr:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    /// 实时搜索地点.
    LCLogInfo(@"searchInfo %@",searchText);
    
    [self searchSchoolBySearchStr:searchText];
}


#pragma mark - UITableView
- (void)tableViewDidPan:(UIPanGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    [self.mySearchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.schoolArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
     cell.schoolLabel.text = @"自定义...";
    }else{
    cell.schoolLabel.text = [LCStringUtil getNotNullStr:[self.schoolArray objectAtIndex:indexPath.row-1]];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LCSchoolCell getCellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [[LCDialogInputter sharedInstance] showInputterWithDefaultText:@"" placeHolder:@"自定义学校名称" title:@"学校" completion:^(NSString *destination) {
            [self didPickSchool:destination];
        }];
    }else{
        [self didPickSchool:[self.schoolArray objectAtIndex:indexPath.row-1]];
    }
}

- (void)didPickSchool:(NSString *)schoolName{
    if ([self.delegate respondsToSelector:@selector(schoolPickerVC:didPickSchool:)]) {
        [self.delegate schoolPickerVC:self didPickSchool:schoolName];
    }
}


@end
