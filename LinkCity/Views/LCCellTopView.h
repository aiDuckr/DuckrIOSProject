//
//  LCCellTopView.h
//  LinkCity
//
//  Created by lhr on 16/6/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCellTopView : UIView

+ (instancetype)createInstance;

- (void)updateShowWithUserModel:(LCUserModel *)user withTimeLabelText:(NSString *)createTime;
@end
