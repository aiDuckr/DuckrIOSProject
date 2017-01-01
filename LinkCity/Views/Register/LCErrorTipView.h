//
//  LCErrorTipView.h
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCErrorTipView : UIView

//Data
@property (nonatomic, strong) void(^callBack)(BOOL canceled);

//UI
@property (weak, nonatomic) IBOutlet UILabel *errorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


+ (instancetype)createInstanceWithTitle:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle callBack:(void(^)(BOOL canceled))callBack;
@end