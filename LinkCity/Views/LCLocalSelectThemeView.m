//
//  LocalSelectThememView.m
//  LinkCity
//
//  Created by linkcity on 16/8/1.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocalSelectThemeView.h"
#import "LCFilterTagButtonCell.h"

@interface LCLocalSelectThemeView()<LCFilterTagButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSArray *inviteThemeArr;
@property (strong, nonatomic) NSArray *sexButtonArr;
@property (strong, nonatomic) NSArray *orderButtonArr;
@property (strong, nonatomic) NSArray *themeButtonArr;

@property (assign, nonatomic) NSInteger fitlerThemeId;
@property (assign, nonatomic) UserSex filterSex;
@property (assign, nonatomic) LCLocalSelectedType filterOrderType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;

@end

@implementation LCLocalSelectThemeView

+ (instancetype)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCLocalSelectThemeView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCLocalSelectThemeView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCLocalSelectThemeView *)v;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    for (LCFilterTagButton *btn in self.sexButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Radio;
    }
    for (LCFilterTagButton *btn in self.orderButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Radio;
    }
    self.themeButtonArr = [[NSArray alloc] init];
    [self.sexDefaultButton updateFilterTagButtonStatus:YES];
    [self.orderDepartTimeButton updateFilterTagButtonStatus:YES];
    
    [self initCollectionsView];
    
    LCRouteThemeModel *allTheme = [[LCRouteThemeModel alloc] init];
    allTheme.title = @"全部";
    allTheme.tourThemeId = 0;
    
    self.inviteThemeArr = [[NSArray alloc] initWithObjects:allTheme, nil];
    NSArray *initInviteThemeArr = [LCDataManager sharedInstance].appInitData.inviteThemes;
    self.inviteThemeArr = [self.inviteThemeArr arrayByAddingObjectsFromArray:initInviteThemeArr];
    
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    NSInteger row = (self.inviteThemeArr.count - 1) / 4 + 1;
    self.collectionHeightConstraint.constant = 30.0f * row + 15 * (row - 1);
    [self intrinsicContentSize];
    
    self.filterOrderType = 0;
    self.filterSex = UserSex_Male;
    self.fitlerThemeId = 0;
    
    self.sexDefaultButton.tag = UserSex_Default;
    self.sexMaleButton.tag = UserSex_Male;
    self.sexFemaleButton.tag = UserSex_Female;
    
    self.orderDistanceButton.tag = LCLocalSelectedType_Distance;
    self.orderDepartTimeButton.tag = LCLocalSelectedType_DepartTime;
}

- (NSArray *)sexButtonArr {
    if (nil == _sexButtonArr) {
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        [mutArr addObject:self.sexDefaultButton];
        [mutArr addObject:self.sexMaleButton];
        [mutArr addObject:self.sexFemaleButton];
        _sexButtonArr = mutArr;
    }
    return _sexButtonArr;
}

- (NSArray *)orderButtonArr {
    if (nil == _orderButtonArr) {
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        [mutArr addObject:self.orderDistanceButton];//距离排序
        [mutArr addObject:self.orderDepartTimeButton];//时间排序
        _orderButtonArr = mutArr;
    }
    return _orderButtonArr;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(DEVICE_WIDTH, 136.0f + self.collectionHeightConstraint.constant);
}

- (void)initCollectionsView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCFilterTagButtonCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([LCFilterTagButtonCell class])];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = CGSizeMake(78.0f, 30.0f);
    self.collectionView.collectionViewLayout = layout;
}

- (void)inviteDidFitler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteFilterViewDidFilter:fitlerThemeId:userSex:filtType:)]) {
        for (LCFilterTagButton *btn in self.themeButtonArr) {
            if (YES == btn.selected) {
                self.fitlerThemeId = btn.tag;
                break ;
            }
        }
        self.filterSex = UserSex_Default;
        for (LCFilterTagButton *btn in self.sexButtonArr) {
            if (btn.selected) {
                self.filterSex = btn.tag;
                break ;
            }
        }
        self.filterOrderType = LCLocalSelectedType_DepartTime;
        for (LCFilterTagButton *btn in self.orderButtonArr) {
            if (btn.selected) {
                self.filterOrderType = btn.tag;
                break ;
            }
        }
        [self.delegate inviteFilterViewDidFilter:self fitlerThemeId:self.fitlerThemeId userSex:self.filterSex filtType:self.filterOrderType];
    }
}

#pragma mark - LCFilterTagButton Delegate.
- (void)filterTagButtonSelected:(LCFilterTagButton *)button {
    if (NSNotFound != [self.sexButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.sexButtonArr];
    }
    if (NSNotFound != [self.orderButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.orderButtonArr];
    }
    if (NSNotFound != [self.themeButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.themeButtonArr];
    }
    [self inviteDidFitler];
}

#pragma mark - UICollectionView Delegate.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (nil != self.inviteThemeArr) {
        num = self.inviteThemeArr.count;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCFilterTagButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCFilterTagButtonCell class]) forIndexPath:indexPath];
    if (nil != self.inviteThemeArr) {
        LCRouteThemeModel *model = [self.inviteThemeArr objectAtIndex:indexPath.row];
        [cell updateFilterTagButton:model];
        if (NSNotFound == [self.themeButtonArr indexOfObject:cell.filterTagButton]) {
            NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.themeButtonArr];
            [mutArr addObject:cell.filterTagButton];
            self.themeButtonArr = mutArr;
        }
        if (0 == model.tourThemeId) {
            [cell.filterTagButton updateFilterTagButtonStatus:YES];
        }
        cell.filterTagButton.type = FilterTagButtonType_Radio;
        cell.filterTagButton.delegate = self;
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

@end
