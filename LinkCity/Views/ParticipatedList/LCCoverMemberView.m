//
//  LCCoverMemberView.m
//  LinkCity
//
//  Created by roy on 11/15/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCCoverMemberView.h"
#import "EGOImageView.h"
#import "UIButton+AFNetworking.h"

@interface LCCoverMemberView()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *talkButtonBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *talkButtonImageView;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (nonatomic, assign) CGPoint talkButtonOrigionCenter;


@property (weak, nonatomic) IBOutlet UIImageView *leftTopLine;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopLine;
@property (weak, nonatomic) IBOutlet UIImageView *leftBottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomLine;

@property (weak, nonatomic) IBOutlet UIView *leftTopMemberView;
@property (weak, nonatomic) IBOutlet UIImageView *leftTopMemberSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTopMemeberNickLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTopMemberLocationLabel;
//@property (weak, nonatomic) IBOutlet EGOImageView *leftTopMemberAvaterImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftTopAvatarButton;

@property (weak, nonatomic) IBOutlet UIView *rightTopMemberView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopMemberSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTopMemberNickLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopMemberLocationLabel;
//@property (weak, nonatomic) IBOutlet EGOImageView *rightTopMemberAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *rightTopAvatarButton;

@property (weak, nonatomic) IBOutlet UIView *rightBottomMemberView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomMemberSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomMemberNickLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomMemberLocationLabel;
//@property (weak, nonatomic) IBOutlet EGOImageView *rightBottomMemberAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *rightBottomAvatarButton;


@property (weak, nonatomic) IBOutlet UIView *leftBottomMemberView;
@property (weak, nonatomic) IBOutlet UIImageView *leftBottomMemberSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomMemberNickLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomMemberLocationLabel;
//@property (weak, nonatomic) IBOutlet EGOImageView *leftBottomMemberAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftBottomAvatarButton;

@property (nonatomic,strong) UITapGestureRecognizer *leftTopTapRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *rightTopTapRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *leftBottomTapRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *rightBottomTapRecognizer;
@end
@implementation LCCoverMemberView


+ (instancetype)createInstance{
    return [[[NSBundle mainBundle]loadNibNamed:@"LCCoverMemberView" owner:nil options:nil]objectAtIndex:0];;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.leftTopTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftTopTapAction:)];
    [self.leftTopMemberView addGestureRecognizer:self.leftTopTapRecognizer];
    [self.leftTopAvatarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.leftTopAvatarButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [self.leftTopAvatarButton addTarget:self action:@selector(leftTopTapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightTopTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTopTapAction:)];
    [self.rightTopMemberView addGestureRecognizer:self.rightTopTapRecognizer];
    [self.rightTopAvatarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.rightTopAvatarButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [self.rightTopAvatarButton addTarget:self action:@selector(rightTopTapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftBottomTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBottomTapAction:)];
    [self.leftBottomMemberView addGestureRecognizer:self.leftBottomTapRecognizer];
    [self.leftBottomAvatarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.leftBottomAvatarButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [self.leftBottomAvatarButton addTarget:self action:@selector(leftBottomTapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBottomTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBottomTapAction:)];
    [self.rightBottomMemberView addGestureRecognizer:self.rightBottomTapRecognizer];
    [self.rightBottomAvatarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.rightBottomAvatarButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [self.rightBottomAvatarButton addTarget:self action:@selector(rightBottomTapAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.talkButtonOrigionCenter = self.center;
    CGFloat origionFrontSize = 46;
    CGFloat origionBackSize = 17;
    self.talkButtonImageView.frame = CGRectMake(0, 0, origionFrontSize, origionFrontSize);
    self.talkButtonImageView.center = self.talkButtonOrigionCenter;
    self.talkButtonBgImageView.frame = CGRectMake(0, 0, origionBackSize, origionBackSize);
    self.talkButtonBgImageView.center = self.talkButtonOrigionCenter;
    self.talkButtonBgImageView.alpha = 1;
}


- (void)setMembers:(NSArray *)members{
    _members = members;
    
    if (members.count >= 4) {
        [self setRightBottomUser:[members objectAtIndex:(members.count-4)]];
    }else{
        [self setRightBottomUser:nil];
    }
    
    if (members.count >= 3) {
        [self setLeftBottomUser:[members objectAtIndex:(members.count-3)]];
    }else{
        [self setLeftBottomUser:nil];
    }
    
    if (members.count >= 2) {
        [self setRightTopUser:[members objectAtIndex:(members.count-2)]];
    }else{
        [self setRightTopUser:nil];
    }
    
    if (members.count >= 1) {
        [self setLeftTopUser:[members objectAtIndex:(members.count-1)]];
    }else{
        [self setLeftTopUser:nil];
    }

    [self beginAnimation];
}

- (void)beginAnimation{
    [self.layer removeAllAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.talkButtonOrigionCenter = self.center;
        CGFloat origionFrontSize = 46;
        CGFloat origionBackSize = 17;
        self.talkButtonImageView.frame = CGRectMake(0, 0, origionFrontSize, origionFrontSize);
        self.talkButtonImageView.center = self.talkButtonOrigionCenter;
        self.talkButtonBgImageView.frame = CGRectMake(0, 0, origionBackSize, origionBackSize);
        self.talkButtonBgImageView.center = self.talkButtonOrigionCenter;
        self.talkButtonBgImageView.alpha = 1;
        
        
        [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^(){
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^(){
                self.talkButtonImageView.frame = CGRectMake(0, 0, 51, 51);
                self.talkButtonImageView.center = self.talkButtonOrigionCenter;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^(){
                self.talkButtonImageView.frame = CGRectMake(0, 0, 50, 50);
                self.talkButtonImageView.center = self.talkButtonOrigionCenter;
            }];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^(){
                self.talkButtonBgImageView.frame = CGRectMake(0, 0, 107, 107);
                self.talkButtonBgImageView.alpha = 0;
                self.talkButtonBgImageView.center = self.talkButtonOrigionCenter;
            }];
        } completion:^(BOOL finished){
            
        }];
    });
}


- (void)setLeftTopUser:(LCUserInfo *)user{
    if (!user) {
        self.leftTopMemberView.hidden = YES;
        self.leftTopAvatarButton.hidden = YES;
        self.leftTopLine.hidden = YES;
    }else{
        self.leftTopMemberView.hidden = NO;
        self.leftTopAvatarButton.hidden = NO;
        self.leftTopLine.hidden = NO;
        
        self.leftTopMemberLocationLabel.text = [LCStringUtil getLocationStrWhichMaybeNil:user.livingPlace];
        self.leftTopMemberSexImageView.image = [user getSexImageForPlanDetailPage];
        [self.leftTopAvatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl]];
        self.leftTopMemeberNickLabel.text = user.nick;
    }
}
- (void)setRightTopUser:(LCUserInfo *)user{
    if (!user) {
        self.rightTopMemberView.hidden = YES;
        self.rightTopAvatarButton.hidden = YES;
        self.rightTopLine.hidden = YES;
    }else{
        self.rightTopMemberView.hidden = NO;
        self.rightTopAvatarButton.hidden = NO;
        self.rightTopLine.hidden = NO;
        
        self.rightTopMemberLocationLabel.text = [LCStringUtil getLocationStrWhichMaybeNil:user.livingPlace];
        self.rightTopMemberSexImageView.image = [user getSexImageForPlanDetailPage];
        [self.rightTopAvatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl]];
        self.rightTopMemberNickLabel.text = user.nick;
    }
    
}
- (void)setLeftBottomUser:(LCUserInfo *)user{
    if (!user) {
        self.leftBottomMemberView.hidden = YES;
        self.leftBottomAvatarButton.hidden = YES;
        self.leftBottomLine.hidden = YES;
    }else{
        self.leftBottomMemberView.hidden = NO;
        self.leftBottomAvatarButton.hidden = NO;
        self.leftBottomLine.hidden = NO;
        
        self.leftBottomMemberLocationLabel.text = [LCStringUtil getLocationStrWhichMaybeNil:user.livingPlace];
        self.leftBottomMemberSexImageView.image = [user getSexImageForPlanDetailPage];
        [self.leftBottomAvatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl]];
        self.leftBottomMemberNickLabel.text = user.nick;
    }
}
- (void)setRightBottomUser:(LCUserInfo *)user{
    if (!user) {
        self.rightBottomMemberView.hidden = YES;
        self.rightBottomAvatarButton.hidden = YES;
        self.rightBottomLine.hidden = YES;
    }else{
        self.rightBottomMemberView.hidden = NO;
        self.rightBottomAvatarButton.hidden = NO;
        self.rightBottomLine.hidden = NO;
        
        self.rightBottomMemberLocationLabel.text = [LCStringUtil getLocationStrWhichMaybeNil:user.livingPlace];
        self.rightBottomMemberSexImageView.image = [user getSexImageForPlanDetailPage];
        [self.rightBottomAvatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl]];
        self.rightBottomMemberNickLabel.text = user.nick;
    }
}

- (IBAction)talkButtonClick:(id)sender {
    RLog(@"talkButtonClick");
    if (self.delegate && [self.delegate respondsToSelector:@selector(talkButtonClicked)])
    {
        [self.delegate talkButtonClicked];
    }
}

- (void)leftTopTapAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverMemberView:didClickUserIndex:)]) {
        [self.delegate coverMemberView:self didClickUserIndex:self.members.count-1];
    }
}
- (void)rightTopTapAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverMemberView:didClickUserIndex:)]) {
        [self.delegate coverMemberView:self didClickUserIndex:self.members.count-2];
    }
}
- (void)leftBottomTapAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverMemberView:didClickUserIndex:)]) {
        [self.delegate coverMemberView:self didClickUserIndex:self.members.count-3];
    }
}
- (void)rightBottomTapAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverMemberView:didClickUserIndex:)]) {
        [self.delegate coverMemberView:self didClickUserIndex:self.members.count-4];
    }
}

@end
