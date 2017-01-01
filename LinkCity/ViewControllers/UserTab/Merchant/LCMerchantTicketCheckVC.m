//
//  LCMerchantTicketCheckVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/15/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantTicketCheckVC.h"
#import "LCMerchantTicketCheckCell.h"
#import "LCMerchantTicketSuccessVC.h"

#define TICKET_MAX_NUM 12

@interface LCMerchantTicketCheckVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextFiled;
@property (strong, nonatomic) NSArray *contentArr;
@property (strong, nonatomic) NSString *activityCode;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation LCMerchantTicketCheckVC
#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantTicketCheckVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantTicketCheckVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self initTextField];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    if (nil != self.view) {
        [self.view addGestureRecognizer:singleTap];
    }
}

- (void)handleSingleTap:(id)sender {
    [self.inputTextFiled resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShow];
}

- (void)initCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = CGSizeMake(50.0f, 50.0f);
    self.collectionView.collectionViewLayout = layout;
}

- (void)initTextField {
    self.inputTextFiled.delegate = self;
    [self.inputTextFiled becomeFirstResponder];
}

- (void)updateShow {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    for (i = 0; i < self.activityCode.length; ++i) {
        NSString *number = [[self.activityCode substringFromIndex:i] substringToIndex:1];
        [arr addObject:number];
    }
    if (TICKET_MAX_NUM == i) {
        [self.inputTextFiled resignFirstResponder];
        [self.confirmButton setBackgroundColor:UIColorFromRGBA(0xffdf00, 1.0f)];
        [self.confirmButton setTitleColor:UIColorFromRGBA(0x6b450a, 1.0f) forState:UIControlStateNormal];
    } else {
        [self.confirmButton setBackgroundColor:UIColorFromRGBA(0xd9d5d1, 1.0f)];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    for (; i < TICKET_MAX_NUM; ++i) {
        [arr addObject:@""];
    }
    self.contentArr = arr;
    [self.collectionView reloadData];
}

- (IBAction)showKeyboardAction:(id)sender {
    [self.inputTextFiled becomeFirstResponder];
}

- (IBAction)confirmAction:(id)sender {
    [self.inputTextFiled resignFirstResponder];
    if ([LCStringUtil isNullString:self.activityCode] || TICKET_MAX_NUM != self.activityCode.length) {
        [YSAlertUtil tipOneMessage:@"请输入合法的12位活动码"];
        return ;
    }
    [LCNetRequester requestMerchantCheckTicket:self.activityCode callBack:^(LCPlanModel *plan, LCUserModel *user, NSError *error) {
        if (!error) {
            if (nil != plan && nil != user) {
                LCMerchantTicketSuccessVC *vc = [LCMerchantTicketSuccessVC createInstance];
                vc.plan = plan;
                vc.user = user;
                [self.navigationController pushViewController:vc animated:APP_ANIMATION];
            }
            [YSAlertUtil tipOneMessage:@"验票成功"];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
        self.activityCode = @"";
        self.inputTextFiled.text = @"";
        [self updateShow];
    }];
}

#pragma mark - UITextField Delegate.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.inputTextFiled) {
        self.activityCode = textField.text;
        self.activityCode = [self.activityCode  stringByReplacingCharactersInRange:range withString:string];
        [self updateShow];
        if (self.activityCode.length > TICKET_MAX_NUM) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UICollectionView Delegate.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return TICKET_MAX_NUM;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCMerchantTicketCheckCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCMerchantTicketCheckCell class]) forIndexPath:indexPath];
    NSString *str = [self.contentArr objectAtIndex:indexPath.row];
    [cell updateShowCell:str];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

@end
