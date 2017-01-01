//
//  LCSearchDestinationVC.h
//  LinkCity
//
//  Created by 张宗硕 on 11/7/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchBar.h"
#import "LCDataManager.h"
#import "LCDestinationCollectionCell.h"
#import "LCSearchDestinationRecmdCell.h"
#import "LCStoryboardManager.h"
#import "LCAutoRefreshVC.h"

//typedef enum : NSUInteger {
//    LCSearchDestinationVCType_Plan,
//    LCSearchDestinationVCType_Tourpic,
//} LCSearchDestinationVCType;

@class LCSearchDestinationVC;

@interface LCSearchDestinationVC : LCAutoRefreshVC {
    
}

+ (instancetype)createInstance;
//@property (nonatomic, assign) LCSearchDestinationVCType searchType;
@end
