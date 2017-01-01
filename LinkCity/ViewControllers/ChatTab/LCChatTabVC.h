//
//  LCChatTabVC.h
//  LinkCity
//
//  Created by roy on 3/15/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

//typedef enum : NSUInteger {
//    LCChatTabVCTab_Chat,
//    LCChatTabVCTab_Contact,
//} LCChatTabVCTab;

@interface LCChatTabVC : LCAutoRefreshVC
//@property (nonatomic, assign) LCChatTabVCTab showingTab;

+ (UINavigationController *)createNavInstance;
@end
