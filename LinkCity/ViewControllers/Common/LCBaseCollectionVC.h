//
//  LCBaseCollectionController.h
//  LinkCity
//
//  Created by roy on 12/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBaseCollectionVC : UICollectionViewController
@property (nonatomic,assign) BOOL haveLayoutSubViews;
@property (nonatomic,assign) BOOL isFirstTimeViewWillAppear;
@property (nonatomic,assign) BOOL statisticByMob;
@property (nonatomic,assign) BOOL isAppearing;
@end
