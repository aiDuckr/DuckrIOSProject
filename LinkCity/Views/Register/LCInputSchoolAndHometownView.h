//
//  LCInputSchoolAndHometownView.h
//  LinkCity
//
//  Created by whb on 16/8/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LCInputSchoolAndHometownViewDelegate;
@interface LCInputSchoolAndHometownView : UIView
@property (nonatomic, weak) id<LCInputSchoolAndHometownViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTitle;
@property (weak, nonatomic) IBOutlet UILabel *schoolTitle;
@property (weak, nonatomic) IBOutlet UILabel *tradeTitle;


+ (instancetype)createInstance;
@end


@protocol LCInputSchoolAndHometownViewDelegate <NSObject>
@optional
- (void)inputSchoolAndHometownViewDidClickPass:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView;
- (void)inputSchoolAndHometownViewDidClickCancel:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView;

- (void)inputSchoolAndHometownView:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView didUpdateinfo:(LCUserModel *)user;
    
- (void)inputUserinfoViewDidClickHomeButton:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView;
- (void)inputUserinfoViewDidClickSchoolButton:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView;
- (void)inputUserinfoViewDidClickTradeButton:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView;

@end