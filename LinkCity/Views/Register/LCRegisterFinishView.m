//
//  LCRegisterFinishView.m
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRegisterFinishView.h"

@implementation LCRegisterFinishView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCRegisterFinishView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCRegisterFinishView *finishView = (LCRegisterFinishView *)v;
            return finishView;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 300);
}

- (void)setUser:(LCUserModel *)user{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    
    self.titleLabel.text = [NSString stringWithFormat:@"你好，%@",user.nick];
}

- (IBAction)submitButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerFinishViewDidSubmit:)]) {
        [self.delegate registerFinishViewDidSubmit:self];
    }
}
- (IBAction)skipButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerFinishViewDidSkip:)]) {
        [self.delegate registerFinishViewDidSkip:self];
    }
}



@end
