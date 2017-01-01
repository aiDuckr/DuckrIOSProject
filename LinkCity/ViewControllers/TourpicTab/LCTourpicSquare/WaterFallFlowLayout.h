//
//  WaterFallFlowLayout.h
//  WaterFall
//
//  Created by JackXu on 15/5/8.
//  Copyright (c) 2015年 BFMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFallFlowLayout : UICollectionViewFlowLayout
@property(nonatomic,assign)id<UICollectionViewDelegateFlowLayout> delegate;
@property(nonatomic,assign)NSInteger cellCount;//cell的个数
@property(nonatomic,strong)NSMutableArray *colArr;//存放列的高度
@property(nonatomic,strong)NSMutableDictionary *attributeDict;//cell的位置信息
@end
