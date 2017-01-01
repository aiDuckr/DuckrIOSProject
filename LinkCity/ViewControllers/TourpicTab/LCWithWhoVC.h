//
//  LCWithWhoVC.h
//  LinkCity
//
//  Created by 张宗硕 on 3/23/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LCWithWhoVCDelegate <NSObject>

@optional
- (void)chooseFinished:(NSArray *)choosedArr;

- (void)chooseFinishedWithSwiftChoosedUserArr:(NSArray *)choosedUserArr ContactArr:(NSArray *)contactArr;


@end

@interface LCWithWhoVC : LCBaseVC
+ (instancetype)createInstance;
@property (retain, nonatomic) id<LCWithWhoVCDelegate> delegate;
@end
