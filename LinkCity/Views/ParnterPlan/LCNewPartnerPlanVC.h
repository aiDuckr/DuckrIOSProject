//
//  LCNewParnterPlanVC.h
//  LinkCity
//
//  Created by 张宗硕 on 11/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTextView.h"
#import "CalendarHomeViewController.h"
#import "YSAlbumImageView.h"
#import "MBProgressHUD.h"
#import "YSAlertUtil.h"
#import "LCPlaceInfo.h"
#import "LCImageUtil.h"
#import "LCPartnerApi.h"
#import "LCBaseVC.h"
#import "LCPartnerPlan.h"

typedef enum {NPT_NEW_PARTNER, NPT_EDIT_PARTNER} NewPartnerType;

@interface LCNewPartnerPlanVC : LCBaseVC
@property (nonatomic, assign) NewPartnerType type;
@end
