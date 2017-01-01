//
//  LCUserEvaluationVC.m
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserEvaluationVC.h"
#import "LCUserEvaluationTagCell.h"
#import "LCStarRatingView.h"

@interface LCUserEvaluationVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,StarRatingViewDelegate,UITextViewDelegate>
//Data
@property (nonatomic, strong) NSMutableArray *selectedTags; //array of bool
@property (nonatomic, strong) NSArray *tags;    // tags to choose, arry of LCUserTagModel

//UI
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIdentityImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


@property (weak, nonatomic) IBOutlet UIView *starCell;
@property (nonatomic, strong) LCStarRatingView *starRatingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagCellHeight;
@property (weak, nonatomic) IBOutlet UIView *tagCell;
@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentCellTop;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@property (weak, nonatomic) IBOutlet UILabel *anonymousSwitchTipLabel;
@property (weak, nonatomic) IBOutlet UISwitch *anonymousSwitch;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end


static NSString *const YellowStarImageName = @"YellowStar";
static NSString *const GreyStarImageName = @"GreyStar";
@implementation LCUserEvaluationVC

+ (instancetype)createInstance{
    return (LCUserEvaluationVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserEvaluationVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Data
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
    
    //scrollview
    self.scrollView.delegate = self;
    
    //star rating view
    self.starRatingView = [[LCStarRatingView alloc] initWithFrame:CGRectMake(20, 0, DEVICE_WIDTH-40, 72) numberOfStar:5 starWidth:30];
    self.starRatingView.delegate = self;
    [self.starCell addSubview:self.starRatingView];
    
    //tag collection view
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    self.tagCollectionView.scrollEnabled = NO;
    self.tagCollectionView.backgroundColor = [UIColor clearColor];
    [self.tagCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserEvaluationTagCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCUserEvaluationTagCell class])];
    
    self.contentTextView.delegate = self;
    [self.anonymousSwitch addTarget:self action:@selector(anonymousSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //有网络请求时显示hud，允许用户交互，所以页面消失时要hideHud
    [YSAlertUtil hideHud];
}

- (void)viewWillLayoutSubviews{
    
    self.tagCellHeight.constant = self.tagCollectionView.contentSize.height + 54;
    [self setStarRatingViewHiden:sRatingViewHiden];
    
    [super viewWillLayoutSubviews];
}

- (void)setUserUuidToEvaluate:(NSString *)userUuid{
    if ([LCStringUtil isNotNullString:userUuid]) {
        [YSAlertUtil showHudWithHint:nil inView:[UIApplication sharedApplication].delegate.window enableUserInteraction:YES];
        [LCNetRequester getUserInfo:userUuid callBack:^(LCUserModel *user, NSError *error) {
            [YSAlertUtil hideHud];
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                self.userToEvaluate = user;
            }
        }];
    }
}
- (void)setUserToEvaluate:(LCUserModel *)userToEvaluate{
    _userToEvaluate = userToEvaluate;
    
    if (userToEvaluate) {
        if ([LCStringUtil isNullString:_userToEvaluate.nick]) {
            //用户信息为空，说明只有uuid，重新请求用户信息
            [self setUserUuidToEvaluate:userToEvaluate.uUID];
        }else{
            if ([self.userToEvaluate isMerchant]) {
                self.tags = [LCDataManager sharedInstance].appInitData.serviceTags;
            }else if ([self.userToEvaluate getUserSex] == UserSex_Male) {
                self.tags = [[NSArray alloc] init];
//                self.tags = [LCDataManager sharedInstance].appInitData.maleTags;
            }else{
                self.tags = [[NSArray alloc] init];
//                self.tags = [LCDataManager sharedInstance].appInitData.femaleTags;
            }
            
            self.selectedTags = [[NSMutableArray alloc] initWithCapacity:0];
            for (LCUserTagModel *tag in self.tags){
                BOOL selected = NO;
                for (NSString *tagName in self.evaluation.tags){
                    if ([tagName isEqualToString:tag.tagName]) {
                        selected = YES;
                        break;
                    }
                }
                [self.selectedTags addObject:[NSNumber numberWithBool:selected]];
            }
            
            [self updateShow];
        }
    }
}

- (LCUserEvaluationModel *)evaluation{
    if (!_evaluation) {
        _evaluation = [[LCUserEvaluationModel alloc] init];
        _evaluation.type = 1;
        _evaluation.evaluationId = -1;
        _evaluation.score = 0;
    }
    return _evaluation;
}

- (void)updateShow{
    if (self.userToEvaluate && [LCStringUtil isNotNullString:self.userToEvaluate.nick]) {
        [self.avatarBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.userToEvaluate.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = self.userToEvaluate.nick;
        self.ageLabel.text = [self.userToEvaluate getUserAgeString];
        if (self.userToEvaluate.isIdentify == LCIdentityStatus_Done) {
            self.userIdentityImageView.hidden = NO;
        }else{
            self.userIdentityImageView.hidden = YES;
        }
        if ([self.userToEvaluate getUserSex] == UserSex_Male) {
            self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
        }else{
            self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
        }
    }
    
    
    [self.starRatingView setScore:(NSInteger)self.evaluation.score withAnimation:NO];
    if ([LCUserEvaluationModel isAnonymousOfType:self.evaluation.type]) {
        self.anonymousSwitch.on = YES;
        self.anonymousSwitchTipLabel.text = @"匿名";
    }else{
        self.anonymousSwitch.on = NO;
        self.anonymousSwitchTipLabel.text = @"无须";
    }
    
    [self.tagCollectionView reloadData];
    for (UICollectionViewCell *cell in [self.tagCollectionView visibleCells]){
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }
}


#pragma mark ButtonActions
- (IBAction)avatarBtnAction:(id)sender {
    [LCViewSwitcher pushToShowUserInfoVCForUser:self.userToEvaluate on:self.navigationController];
}
- (IBAction)userInfoBtnAction:(id)sender {
    [LCViewSwitcher pushToShowUserInfoVCForUser:self.userToEvaluate on:self.navigationController];
}


- (void)anonymousSwitchAction:(id)sender{
    BOOL isAnonymous = self.anonymousSwitch.on;
    self.evaluation.type = [LCUserEvaluationModel getTypeForAnonymous:isAnonymous];
    [self updateShow];
}

- (IBAction)submitButtonAction:(id)sender {
    [self.contentTextView resignFirstResponder];
    
    if (self.evaluation.score < 1) {
        [YSAlertUtil tipOneMessage:@"评分至少为一星" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }
    
    self.evaluation.content = self.contentTextView.text;
    
    NSMutableArray *selectedTagNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.selectedTags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *selection = (NSNumber *)obj;
        if ([selection boolValue]) {
            LCUserTagModel *tag = [self.tags objectAtIndex:idx];
            [selectedTagNameArray addObject:tag.tagName];
        }
    }];
    
    [LCNetRequester evaluateUser:self.userToEvaluate.uUID
                            type:self.evaluation.type
                           score:self.evaluation.score
                         content:self.evaluation.content
                            tags:selectedTagNameArray
                        callBack:^(LCUserEvaluationModel *userEvaluation, NSError *error)
     {
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
         }else{
             [YSAlertUtil tipOneMessage:@"评价成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
             
             
             if (self.navigationController.presentingViewController) {
                 [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
             }else{
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }
     }];
}

- (void)panGestureAction:(id)sender{
    if (!self.isJustShowKeyboard) {
        [self.contentTextView resignFirstResponder];
    }
}

#pragma mark StarRatingView
static BOOL sRatingViewHiden = NO;
- (void)setStarRatingViewHiden:(BOOL)hiden{
    sRatingViewHiden = hiden;
    
    if (hiden) {
        self.commentCellTop.constant = 9;
        self.tagCell.hidden = YES;
    }else{
        self.commentCellTop.constant = self.tagCellHeight.constant + 18;
        self.tagCell.hidden = NO;
    }
}


#pragma mark StarRatingView Delegate
static NSInteger lastSetScore = -1;
- (void)starRatingView:(LCStarRatingView *)view score:(NSInteger)score{
    if (lastSetScore != score) {
        lastSetScore = score;
        
        self.evaluation.score = score;
        
        if ([self.userToEvaluate isMerchant]) {
            //商家
            if (self.evaluation.score > 0 && self.evaluation.score < 3) {
                //1～2星，显示tag
                [self setStarRatingViewHiden:NO];
            }else{
                //3~5星，隐藏tag，把选中的tag清零
                [self setStarRatingViewHiden:YES];
                
                self.evaluation.tags = nil;
                for (int i=0; i<self.selectedTags.count; i++){
                    [self.selectedTags replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                }
            }
        }else{
            //普通用户，始终显示tag
            [self setStarRatingViewHiden:NO];
        }
        
        [self updateShow];
    }
}

#pragma mark -
#pragma mark UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tags.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LCUserEvaluationTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCUserEvaluationTagCell class]) forIndexPath:indexPath];
    
    LCUserTagModel *tag = [self.tags objectAtIndex:indexPath.item];
    cell.subjectLabel.text = tag.tagName;
    NSNumber *selected = [self.selectedTags objectAtIndex:indexPath.item];
    [cell setSubjectSelected:[selected boolValue]];
    
    return cell;
}
#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLogInfo(@"didSelectItem:%ld,%ld",(long)indexPath.section,(long)indexPath.item);
    LCUserEvaluationTagCell *cell = (LCUserEvaluationTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BOOL wasSelected = cell.isSubjectSelected;
    
    if (wasSelected) {
        [cell setSubjectSelected:NO];
        [self.selectedTags replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:NO]];
    }else{
        NSInteger tagNum = 0;
        for (NSNumber *num in self.selectedTags){
            if ([num boolValue]) {
                tagNum ++;
            }
        }
        if (tagNum >= MaxTagNumWhenEvaluateUser) {
            [YSAlertUtil tipOneMessage:@"最多贴4个标签" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            [cell setSubjectSelected:YES];
            [self.selectedTags replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:YES]];
        }
    }
}

#pragma mark UICollectionView Layout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width/4.0, 40);
    
    return cellSize;
}

#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.contentSize.height-10, 10, 10) animated:YES];
    
    return YES;
}

#pragma mark UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView && !self.isJustShowKeyboard) {
        [self.contentTextView resignFirstResponder];
    }
}

@end
