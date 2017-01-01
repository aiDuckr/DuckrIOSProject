//
//  LCMarkPicPlaceVC.h
//  LinkCity
//
//  Created by 张宗硕 on 3/23/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCMarkPicPlaceVCDelegate <NSObject>
@optional
- (void)choosePlaceName:(NSString *)name;

@end

@interface LCMarkPicPlaceVC : LCBaseVC
+ (instancetype)createInstance;
@property (retain, nonatomic) id<LCMarkPicPlaceVCDelegate> delegate;

@end
