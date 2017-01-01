//
//  LCCostPlanEvaluationView.m
//  LinkCity
//
//  Created by 张宗硕 on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanEvaluationView.h"

@interface LCCostPlanEvaluationView()<UITextViewDelegate, StarRatingViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *planTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *evaluationTextView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (nonatomic, strong) LCStarRatingView *starRatingView;
@property (assign, nonatomic) NSInteger score;

@end

@implementation LCCostPlanEvaluationView

+ (instancetype)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCCostPlanEvaluationView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCCostPlanEvaluationView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCCostPlanEvaluationView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(250.0f, 300.0f);
}

- (void)awakeFromNib {
    self.score = 0;
    self.starRatingView = [[LCStarRatingView alloc] initWithFrame:CGRectMake(43.0f, 0.0f, 164.0f, 24.0f) numberOfStar:5 starWidth:24.0f];
    self.starRatingView.delegate = self;
    self.starRatingView.delegate = self;
    [self.starView addSubview:self.starRatingView];
    [self.starRatingView setScore:0.0f withAnimation:YES];
    self.evaluationTextView.delegate = self;
}

- (void)updateShowEvaluationView:(LCPlanModel *)plan {
    self.plan = plan;
    self.planTitleLabel.text = plan.declaration;
    [self.firstImageView setImageWithURL:[NSURL URLWithString:plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    if ([LCStringUtil isNotNullString:plan.secondPhotoThumbUrl]) {
        self.secondImageView.hidden = NO;
        [self.secondImageView setImageWithURL:[NSURL URLWithString:plan.secondPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.secondImageView.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:plan.thirdPhotoThumbUrl]) {
        self.thirdImageView.hidden = NO;
        [self.thirdImageView setImageWithURL:[NSURL URLWithString:plan.thirdPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.thirdImageView.hidden = YES;
    }
}

- (BOOL)checkInput {
    if (self.score > 0) {
        return YES;
    }
    
    [YSAlertUtil tipOneMessage:@"请完成星级评价" yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
    return NO;
}


- (void)handleSingleTap:(id)sender {
    [self.evaluationTextView resignFirstResponder];
}

- (void)sendEvaluationToServer {
    [LCNetRequester addCommentToPlan:self.plan.planGuid
                             content:self.evaluationTextView.text
                           replyToId:DefaultCommentReplyToId
                               score:self.score
                            withType:PlanCommentTypeEvalPlan
                            callBack:^(LCCommentModel *comment, NSError *error) {
                                [YSAlertUtil hideHud];
                                if (error) {
                                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                                } else {
                                    [YSAlertUtil tipOneMessage:@"评价成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                                    if ([self.delegate respondsToSelector:@selector(costPlanEvaluationViewDidCancel:)]) {
                                        [self.delegate costPlanEvaluationViewDidCancel:self];
                                    }
                                }
                            }];
}

#pragma mark UIButton Action
- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(costPlanEvaluationViewDidCancel:)]) {
        [self.delegate costPlanEvaluationViewDidCancel:self];
    }
}

- (IBAction)finishButtonAction:(id)sender {
    if ([self checkInput]) {
        [YSAlertUtil showHudWithHint:nil];
        [self sendEvaluationToServer];
    }
}

#pragma mark StarRating Delegate
- (void)starRatingView:(LCStarRatingView *)view score:(NSInteger)score {
    self.score = score;
}

#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    if (nil != self.superview.superview) {
        [self.superview.superview addGestureRecognizer:singleTap];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
