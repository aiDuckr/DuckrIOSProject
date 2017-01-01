//
//  LCUserBaseInfoView.h
//  LinkCity
//
//  Created by roy on 3/2/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@interface LCUserInfoTopView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;


+ (instancetype)createInstance;
@end
