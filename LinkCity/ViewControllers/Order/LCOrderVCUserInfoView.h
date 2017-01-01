//
//  LCOrderUserView.h
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCOrderVCUserInfoView : UIView

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;

+ (instancetype)createInstance;
@end
