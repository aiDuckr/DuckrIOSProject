//
//  LCChatTabNavTitleView.h
//  LinkCity
//
//  Created by roy on 5/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChatTabNavTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *receivingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


+ (instancetype)createInstance;
- (void)showAsNormal;
- (void)showAsReceiving;
- (void)showAsReceivingAndAutoStop;
@end
