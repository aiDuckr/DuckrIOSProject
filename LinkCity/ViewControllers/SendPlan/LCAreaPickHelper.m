//
//  LCAreaPickHelper.m
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAreaPickHelper.h"
#import "LCTagCell.h"
#import "LCAllCountryCityVC.h"
#import "LCLocationManager.h"

@interface LCAreaPickHelper()<UICollectionViewDelegate, UICollectionViewDataSource, LCAllCountryCityVCDelegate>
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSMutableArray *alphaArray;
@property (nonatomic, strong) NSMutableArray *arrayOfCityArray;
@property (nonatomic, strong) LCAllCountryCityVC *cityVC;
@property (nonatomic, strong) NSDictionary *curCityDic;
@property (nonatomic, strong) NSString *curAreaName;
@end
@implementation LCAreaPickHelper

+ (instancetype)instanceWithNavVC:(UINavigationController *)navVC{
    LCAreaPickHelper *instance = [[LCAreaPickHelper alloc] init];
    instance.navVC = navVC;
    [instance updateData];
    
    return instance;
}

- (void)updateData{
    self.cityArray = [LCLocationManager getCityDicArrayFromPlist];
    
    self.alphaArray = [[NSMutableArray alloc] init];
    self.arrayOfCityArray = [[NSMutableArray alloc] init];
    
    [self.alphaArray addObject:@"热门"];
    NSMutableArray *hotCityArray = [[NSMutableArray alloc] init];
    for(NSDictionary *cityDic in self.cityArray){
        NSString *cityName = [cityDic objectForKey:@"name"];
        if ([cityName isEqualToString:@"北京市"] ||
            [cityName isEqualToString:@"上海市"] ||
            [cityName isEqualToString:@"广州市"] ||
            [cityName isEqualToString:@"深圳市"] ||
            [cityName isEqualToString:@"杭州市"]) {
            [hotCityArray addObject:cityDic];
        }
    }
    [self.arrayOfCityArray addObject:hotCityArray];
    
    NSString *lastAlpha = @"";
    NSString *curAlpha = @"";
    NSMutableArray *cityArrayOfLastAlpha;
    for (NSDictionary *aCity in self.cityArray){
        NSString *pinyin = [aCity objectForKey:@"pinyin"];
        curAlpha = [pinyin substringWithRange:NSMakeRange(0, 1)];
        
        if ([curAlpha compare:lastAlpha] != NSOrderedSame) {
            if (cityArrayOfLastAlpha) {
                [self.alphaArray addObject:[lastAlpha uppercaseString]];
                [self.arrayOfCityArray addObject:cityArrayOfLastAlpha];
            }
            
            cityArrayOfLastAlpha = [[NSMutableArray alloc] init];
            [cityArrayOfLastAlpha addObject:aCity];
        }else{
            [cityArrayOfLastAlpha addObject:aCity];
        }
        
        lastAlpha = curAlpha;
    }
    
    [self.alphaArray addObject:[lastAlpha uppercaseString]];
    [self.arrayOfCityArray addObject:cityArrayOfLastAlpha];
}

- (void)startAreaPickWithCityName:(NSString *)city areaName:(NSString *)areaName callBack:(void (^)(NSString *))callBack{
    self.callBack = callBack;
    self.curCityDic = nil;
    self.curAreaName = nil;
    
    if ([LCStringUtil isNotNullString:city]) {
        for(NSDictionary *cityDic in self.cityArray){
            if ([[cityDic objectForKey:@"name"] compare:city] == NSOrderedSame) {
                self.curCityDic = cityDic;
                break;
            }
        }
        
        if ([LCStringUtil isNotNullString:areaName] &&
            self.curCityDic) {
            NSArray *areaArray = [self.curCityDic objectForKey:@"areas"];
            for (NSString *area in areaArray) {
                if ([area compare:areaName] == NSOrderedSame) {
                    self.curAreaName = area;
                }
            }
        }
    }
    
    
    if (self.curCityDic) {
        [self showPickView];
    }else{
        [self showPickVC];
    }
}

- (void)showPickView{
    [self pickViewUpdateShow];
    [self.pickPopup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (void)showPickVC{
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:self.cityVC] animated:YES completion:nil];
}

#pragma mark Set & Get
- (LCAreaPickView *)pickView{
    if (!_pickView) {
        _pickView = [LCAreaPickView createInstance];
        
        [_pickView.changeBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _pickView.collectionView.delegate = self;
        _pickView.collectionView.dataSource = self;
        _pickView.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [_pickView.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTagCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCTagCell class])];
    }
    return _pickView;
}

- (void)pickViewUpdateShow{
    if (self.curCityDic) {
        NSString *cityName = [self.curCityDic objectForKey:@"name"];
        self.pickView.curCityLabel.text = [NSString stringWithFormat:@"当前城市：%@",cityName];
        [self.pickView.collectionView reloadData];
    }
}

- (KLCPopup *)pickPopup{
    if (!_pickPopup) {
        _pickPopup = [KLCPopup popupWithContentView:self.pickView
                                           showType:KLCPopupShowTypeSlideInFromBottom
                                        dismissType:KLCPopupDismissTypeSlideOutToBottom
                                           maskType:KLCPopupMaskTypeDimmed
                           dismissOnBackgroundTouch:YES
                              dismissOnContentTouch:NO];
        _pickPopup.dimmedMaskAlpha = 0.5;
    }
    return _pickPopup;
}

- (LCAllCountryCityVC *)cityVC{
    if (!_cityVC) {
        _cityVC = [LCAllCountryCityVC createInstance];
        _cityVC.alphaArray = self.alphaArray;
        _cityVC.arrayOfCityArray = self.arrayOfCityArray;
        _cityVC.delegate = self;
    }
    return _cityVC;
}

#pragma mark BtnAction
- (void)changeBtnAction:(id)sender{
    [self.pickPopup dismiss:YES];
    [self showPickVC];
}

#pragma mark LCAllCountryCityVCDelegate
- (void)allCountryCityVC:(LCAllCountryCityVC *)vc didSelectCityDic:(NSDictionary *)cityDic{
    self.curCityDic = cityDic;
    [vc dismissViewControllerAnimated:YES completion:^{
        [self showPickView];
    }];
}


#pragma mark UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *areaArray = [self.curCityDic objectForKey:@"areas"];
    return areaArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCTagCell class]) forIndexPath:indexPath];
    
    NSArray *areaArray = [self.curCityDic objectForKey:@"areas"];
    NSString *areaName = [areaArray objectAtIndex:indexPath.item];
    BOOL selcted = NO;
    if ([LCStringUtil isNotNullString:self.curAreaName] &&
        [areaName compare:self.curAreaName] == NSOrderedSame) {
        
        selcted = YES;
    }
    
    [cell updateShowWithText:areaName selected:selcted];
    
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 13;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellWidth = (DEVICE_WIDTH - 13*5 ) / 4.0;
    CGSize cellSize = CGSizeMake(cellWidth, 35);
    
    return cellSize;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSArray *areaArray = [self.curCityDic objectForKey:@"areas"];
    NSString *areaName = [areaArray objectAtIndex:indexPath.item];
    NSString *cityName = [self.curCityDic objectForKey:@"name"];
    
    if (self.callBack) {
        self.callBack([NSString stringWithFormat:@"%@-%@",cityName,areaName]);
    }
    
    [self.pickPopup dismiss:YES];
}














@end
