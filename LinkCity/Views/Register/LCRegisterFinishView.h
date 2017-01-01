//
//  LCRegisterFinishView.h
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@protocol LCRegisterFinishViewDelegate;
@interface LCRegisterFinishView : UIView

//Data
@property (nonatomic, weak) id<LCRegisterFinishViewDelegate> delegate;
@property (nonatomic, strong) LCUserModel *user;

//UI
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;



+ (instancetype)createInstance;
@end


@protocol LCRegisterFinishViewDelegate <NSObject>
@optional
- (void)registerFinishViewDidSubmit:(LCRegisterFinishView *)finishView;
- (void)registerFinishViewDidSkip:(LCRegisterFinishView *)finishView;

@end