//
//  LCMemberCollectionView.h
//  LinkCity
//
//  Created by roy on 11/13/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCMemberCollectionViewDelegate;
@interface LCMemberCollectionView : UICollectionView
@property (nonatomic,strong) NSArray *users;
@property (nonatomic,weak) id<LCMemberCollectionViewDelegate> memberCollectionViewDelegate;
@end


@protocol LCMemberCollectionViewDelegate <NSObject>

- (void)memberCollectionView:(LCMemberCollectionView *)memberColectionView didSelectIndex:(NSInteger)index;

@end