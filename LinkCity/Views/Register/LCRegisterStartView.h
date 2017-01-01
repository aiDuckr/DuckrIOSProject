//
//  LCRegisterStartView.h
//  LinkCity
//
//  Created by roy on 2/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCRegisterStartViewDelegate;
@interface LCRegisterStartView : UIView
@property (nonatomic,weak) id<LCRegisterStartViewDelegate> delegate;

+ (instancetype)createInstance;

@end


@protocol LCRegisterStartViewDelegate <NSObject>
@optional
- (void)registerStartViewDidCancel:(LCRegisterStartView *)registerStartView;
- (void)registerStartViewDidChooseRegister:(LCRegisterStartView *)registerStartView;
- (void)registerStartViewDidChooseLogin:(LCRegisterStartView *)registerStartView;
@end
