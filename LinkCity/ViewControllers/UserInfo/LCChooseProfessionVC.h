//
//  LCEditUserChooseProfessionVC.h
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

@protocol LCChooseProfessionVCDelegate;
@interface LCChooseProfessionVC : LCBaseVC
@property (nonatomic, weak) id<LCChooseProfessionVCDelegate> delegate;


+ (instancetype)createInstance;
@end

@protocol LCChooseProfessionVCDelegate <NSObject>
- (void)chooseProfessionVC:(LCChooseProfessionVC *)chooseProfessionVC didChooseProfession:(NSString *)pro;
@end


