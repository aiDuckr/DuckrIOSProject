//
//  LCDelegateManager.h
//  LinkCity
//
//  Created by lhr on 16/5/20.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCFreePlanCell.h"
@protocol LCDelegateManagerDelegate <NSObject>

- (void)updateViewShow;
//- (void)planCommentSelected:(LCFreePlanCell *)cell;

@end

@interface LCDelegateManager : NSObject <LCFreePlanCellDelegate>

@property (nonatomic, weak) id<LCDelegateManagerDelegate>  delegate;

+ (instancetype)sharedInstance;


@end
