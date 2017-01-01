//
//  LCFreePlanDetailVC+Comment.m
//  LinkCity
//
//  Created by 张宗硕 on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCFreePlanDetailVC.h"

static const CGFloat InputContainerHeight = 46;

@implementation LCFreePlanDetailVC (Comment)
- (void)showInputToolBarWithPlaceHolder:(NSString *)placeHolder withReplyCommentId:(NSInteger)replyCommentId {
    self.replyCommentId = replyCommentId;
    if (!self.inputToolBar) {
        self.inputContainer = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-InputContainerHeight, DEVICE_WIDTH, InputContainerHeight)];
        self.inputContainer.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
        topLine.backgroundColor = UIColorFromR_G_B_A(232, 228, 221, 1);
        
        self.inputToolBar = [[LCTextMessageToolBar alloc]initWithFrame:CGRectMake(0, InputContainerHeight/2-[LCTextMessageToolBar defaultHeight]/2, DEVICE_WIDTH, [LCTextMessageToolBar defaultHeight])];
        
        self.inputToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        
        self.inputToolBar.inputTextView.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
        self.inputToolBar.inputTextView.textColor = UIColorFromR_G_B_A(196, 191, 187, 1);
        self.inputToolBar.delegate = self;
        
        [self.inputContainer addSubview:topLine];
        [self.inputContainer addSubview:self.inputToolBar];
    }
    
    self.inputContainer.frame = CGRectMake(0, DEVICE_HEIGHT-InputContainerHeight, DEVICE_WIDTH, InputContainerHeight);
    
    [self.view addSubview:self.inputContainer];
    [self.inputToolBar.inputTextView becomeFirstResponder];
    
    self.inputToolBar.inputTextView.placeHolder = placeHolder;
    self.shadowView.hidden = NO;
}

- (void)hideInputToolBar {
    self.shadowView.hidden = YES;
    if (self.inputToolBar) {
        [self.inputToolBar.inputTextView resignFirstResponder];
        [self.inputContainer removeFromSuperview];
    }
}

#pragma mark LCTextMessageInputToolBar Delegate
- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    LCLogInfo(@"%f",toHeight);
    CGFloat containerHeight = toHeight;
    self.inputContainer.frame = CGRectMake(0, DEVICE_HEIGHT-containerHeight, DEVICE_WIDTH, containerHeight);
}

- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView{
    LCLogInfo(@"did begin edit");
}

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    LCLogInfo(@"will begin edit");
}

- (void)didSendText:(NSString *)text {
    LCLogInfo(@"did send %@",text);
    [self hideInputToolBar];
    [LCNetRequester addCommentToPlan:self.plan.planGuid content:text replyToId:self.replyCommentId callBack:^(LCCommentModel *comment, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            [YSAlertUtil tipOneMessage:@"评论成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            [self refreshData];
        }
    }];
}
@end
