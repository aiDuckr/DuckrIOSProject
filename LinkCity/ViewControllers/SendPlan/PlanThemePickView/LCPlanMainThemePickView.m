//
//  LCPlanMainThemePickView.m
//  LinkCity
//
//  Created by Roy on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanMainThemePickView.h"
#import "UIView+BlocksKit.h"
//#import "UIView+BlocksKit.h"

@implementation LCPlanMainThemePickView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCPlanThemePickView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCPlanMainThemePickView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCPlanMainThemePickView *)v;
        }
    }
    
    
    return nil;
}

- (void)awakeFromNib{
    self.themeBtnArray = @[self.themeBtnA,
                           self.themeBtnD,
                           self.themeBtnE];
    
    self.imgViewArray = @[self.imgViewA,
                          self.imgViewD,
                          self.themeBtnE];
    
    self.nameLabelArray = @[self.nameLabelA,
                            self.nameLabelD,
                            self.nameLabelE];
    
    for (UIButton *btn in self.themeBtnArray){
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = [self getThemeBtnWidth] / 2.0;
        
        [btn addTarget:self action:@selector(themeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    for (UILabel *label in self.nameLabelArray) {
        label.textAlignment = NSTextAlignmentCenter;
    }
    [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    [self.MainView bk_whenTapped:^{
//        [self.delegate shouldDismissThemePickView];
//        //NSLog(@"tapped");
//    }];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT);
}

- (void)setThemeArray:(NSArray *)themeArray{
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    [self.MainView addSubview:view];
//    view.userInteractionEnabled = YES;
//    view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
  
//   //self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
//    _themeArray = themeArray;
//    //self.backgroundColor = [UIColor blueColor];
//    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
//    for (int i=0; i<self.themeBtnArray.count && i<self.themeArray.count; i++){
//        LCRouteThemeModel *aTheme = [self.themeArray objectAtIndex:i];
//        
//        UIImageView *imgView = [self.imgViewArray objectAtIndex:i];
//        imgView.hidden = NO;
//        [imgView setImageWithURL:[NSURL URLWithString:aTheme.iconUrl] placeholderImage:[UIImage imageNamed:@"SendFreePlanDefaultThemeIcon"]];
//        
//        UILabel *nameLabel = [self.nameLabelArray objectAtIndex:i];
//        nameLabel.hidden = NO;
//        [nameLabel setText:[LCStringUtil getNotNullStr:aTheme.themeDesc]];
//        
//        UIButton *btn = [self.themeBtnArray objectAtIndex:i];
//        btn.hidden = NO;
//    }
//    
//    if (self.themeArray.count < self.themeBtnArray.count) {
//        for (int i=(int)self.themeArray.count; i<self.themeBtnArray.count; i++){
//            UIImageView *imgView = [self.imgViewArray objectAtIndex:i];
//            imgView.hidden = YES;
//            UILabel *nameLabel = [self.nameLabelArray objectAtIndex:i];
//            nameLabel.hidden = YES;
//            UIButton *btn = [self.themeBtnArray objectAtIndex:i];
//            btn.hidden = YES;
//        }
//    }
}

- (void)themeBtnAction:(id)sender {
    NSInteger btnIndex = [self.themeBtnArray indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(planMainThemePickView:didSelectTheme:)]) {
        [self.delegate planMainThemePickView:self didSelectTheme:btnIndex];
    }
}


- (CGFloat)getThemeBtnWidth{
    NSInteger themeBtnWidth = (int)((DEVICE_WIDTH - 20 - 50.0) / 4.0);
    
    return themeBtnWidth % 2 == 0? themeBtnWidth : (themeBtnWidth-1);
}

- (void)dismiss {
    [self DismissPlusAnimation];
    
}
- (void)DismissPlusAnimation {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat angle =  -M_PI_4 * 3.0;
        CGAffineTransform at = CGAffineTransformMakeRotation(angle);
        [self.dismissButton setTransform:at];
    } completion:^(BOOL finished){
        [self.delegate shouldDismissThemePickView];
    }];
}


- (void)pushPlusAnimation {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat angle =  M_PI_4 * 3.0;
        CGAffineTransform at = CGAffineTransformMakeRotation(angle);
        [self.dismissButton setTransform:at];
    } completion:^(BOOL finished){
        //[self.delegate shouldDismissThemePickView];
    }];
}
@end
