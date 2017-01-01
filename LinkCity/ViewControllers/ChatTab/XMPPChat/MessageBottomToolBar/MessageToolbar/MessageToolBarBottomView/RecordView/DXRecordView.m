/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXRecordView.h"

@interface DXRecordView ()
{
    NSTimer *_timer;
    UIImageView *audioLeftImageView;
    UIImageView *audioRightImageView;
    UILabel *audioTimeLabel;
    UIImageView *stateImageView;
    UILabel *stateLabel;
    
    NSInteger timerTickNum;
}

@end

@implementation DXRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = UIColorFromRGBA(0x000000, 0.75);
        bgView.layer.cornerRadius = 15;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        CGFloat audioTimeLabelVerticalCenter = 33;
        CGFloat audioTimeLabelHorizontalCenter = self.bounds.size.width/2.0;
        
        
        audioLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [self addSubview:audioLeftImageView];
        audioLeftImageView.center = CGPointMake(audioTimeLabelHorizontalCenter - 13 - 8 - 4, audioTimeLabelVerticalCenter);
        
        
        audioTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 16)];
        audioTimeLabel.textAlignment = NSTextAlignmentCenter;
        audioTimeLabel.font = [UIFont fontWithName:FONT_FUTURA size:13];
        audioTimeLabel.textColor = UIColorFromRGBA(0xfeec68, 1);
        [self addSubview:audioTimeLabel];
        audioTimeLabel.center = CGPointMake(audioTimeLabelHorizontalCenter, audioTimeLabelVerticalCenter);
        
        audioRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [self addSubview:audioRightImageView];
        audioRightImageView.center = CGPointMake(audioTimeLabelHorizontalCenter + 13 + 8 + 4, audioTimeLabelVerticalCenter);
        
        
        stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 66, 80)];
        stateImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:stateImageView];
        stateImageView.center = CGPointMake(audioTimeLabelHorizontalCenter, 50 + 40);
        
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-20, 14)];
        stateLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
        stateLabel.textColor = UIColorFromRGBA(0xffffff, 1);
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:stateLabel];
        stateLabel.center = CGPointMake(audioTimeLabelHorizontalCenter, self.bounds.size.height - 15 - 7);

    }
    return self;
}

// 录音按钮按下
-(void)recordButtonTouchDown
{
    stateImageView.image = [UIImage imageNamed:@"AudioMicrophone"];
    stateLabel.text = @"手指上划，取消发送";
    stateLabel.textColor = UIColorFromRGBA(0xffffff, 1);
    
    timerTickNum = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];

}
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
}
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    stateImageView.image = [UIImage imageNamed:@"AudioMicrophone"];
    stateLabel.text = @"手指上划，取消发送";
    stateLabel.textColor = UIColorFromRGBA(0xffffff, 1);
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    stateImageView.image = [UIImage imageNamed:@"AudioCancel"];
    stateLabel.text = @"松开手指，取消发送";
    stateLabel.textColor = UIColorFromRGBA(0xff5a4d, 1);
}

-(void)timerAction {
    timerTickNum += 1;
    
    audioTimeLabel.text = [[NSString alloc] initWithFormat:@"%ld\"",(long)(timerTickNum/10)];
    
    NSInteger animalStep = (timerTickNum/5)%3;
    if (animalStep%3==0) {
        audioLeftImageView.image = [UIImage imageNamed:@"AudioLeftA"];
        audioRightImageView.image = [UIImage imageNamed:@"AudioRightA"];
    }else if(animalStep%3==1) {
        audioLeftImageView.image = [UIImage imageNamed:@"AudioLeftB"];
        audioRightImageView.image = [UIImage imageNamed:@"AudioRightB"];
    }else if(animalStep%3==2) {
        audioLeftImageView.image = [UIImage imageNamed:@"AudioLeftC"];
        audioRightImageView.image = [UIImage imageNamed:@"AudioRightC"];
    }
}

@end
