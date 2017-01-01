//
//  LCPlanTabTabView.m
//  LinkCity
//
//  Created by Roy on 12/9/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanTabTabView.h"

#define FiltBtnWidth (50)
#define ThemeBtnWidth ((DEVICE_WIDTH - FiltBtnWidth) / 4.0)

#define AnimateDuration_ShowSortView (0.4)
#define AnimateDuration_SelectThemeBtn (0.1)
#define AnimateDuration_SelectSortBtn (0.1)

#define HighlightThemeBtnFontSize (17)
#define NormalThemeBtnFontSize (15)
#define HighlightThemeBtnColor (0xad7f2d)
#define NormalThemeBtnColor (0x2c2a28)

#define HighlightSortBtnColor (0x2c2a28)
#define NormalSortBtnColor (0xaba7a2)

@interface LCPlanTabTabView()
//UI
@property (weak, nonatomic) IBOutlet UIView *themeBtnView;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnA;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnB;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnC;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnD;

@property (weak, nonatomic) IBOutlet UIView *sortBtnView;
@property (weak, nonatomic) IBOutlet UIButton *sortBtnA;
@property (weak, nonatomic) IBOutlet UIButton *sortBtnB;
@property (weak, nonatomic) IBOutlet UIButton *sortBtnC;

@property (weak, nonatomic) IBOutlet UIButton *filtBtn;
@property (weak, nonatomic) IBOutlet UIImageView *filtBtnBrownIcon;
@property (weak, nonatomic) IBOutlet UIImageView *filtBtnClearIcon;

@property (weak, nonatomic) IBOutlet UIImageView *markLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markLineCenterConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortBtnViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortBtnViewLeadConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeBtnBLeadConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeBtnCLeadConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeBtnDLeadConstraint;


//Date
@property (nonatomic, strong) NSArray *themeBtnArray;
@property (nonatomic, strong) NSArray *sortBtnArray;

@end

@implementation LCPlanTabTabView

#pragma mark - Public Interface
+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCPlanTabTabView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCPlanTabTabView class]]) {
            return (LCPlanTabTabView *)v;
        }
    }
    
    return nil;
}

- (void)awakeFromNib{
    NSLog(@"_______awake from nib");
    
    self.sortBtnViewWidthConstraint.constant = (DEVICE_WIDTH - FiltBtnWidth) / 4.0 * 3.0;
    
    self.themeBtnArray = @[self.themeBtnA, self.themeBtnB, self.themeBtnC, self.themeBtnD];
    self.sortBtnArray  =@[self.sortBtnA, self.sortBtnB, self.sortBtnC];
    
    self.selectedThemeIndex = -1;
    [self setThemeIndex:0 asSelectedWithAnimation:NO];
    
    self.selectedSortIndexArray = [[NSMutableArray alloc] init];
    for(int i=0; i<4; i++){
        [self.selectedSortIndexArray addObject:[NSNumber numberWithInteger:0]];
    }
}

- (void)updateShowWithThemes:(NSArray *)themes{
    for (int i=0; i<4 && i<themes.count; i++){
        LCRouteThemeModel *theme = themes[i];
        UIButton *btn = self.themeBtnArray[i];
        [btn setTitle:theme.title forState:UIControlStateNormal];
    }
}

- (void)setThemeIndex:(NSInteger)themeIndex asSelectedWithAnimation:(BOOL)animate{
    self.selectedThemeIndex = themeIndex;
    
    void(^markLineAnimate)() = ^(){
        if (self.markLineCenterConstraint) {
            [self.themeBtnView removeConstraint:self.markLineCenterConstraint];
        }
        UIButton *selectedThemeBtn = [self.themeBtnArray objectAtIndex:self.selectedThemeIndex];
        self.markLineCenterConstraint = [NSLayoutConstraint constraintWithItem:self.markLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:selectedThemeBtn attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.themeBtnView addConstraint:self.markLineCenterConstraint];
        
        [self layoutIfNeeded];
    };
    
    if (animate) {
        for(int i=0; i<self.themeBtnArray.count; i++){
            UIButton *themeBtn = self.themeBtnArray[i];
            if (i == themeIndex) {
                [UIView transitionWithView:themeBtn duration:AnimateDuration_SelectThemeBtn options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
                    [themeBtn setTitleColor:UIColorFromRGBA(HighlightThemeBtnColor, 1) forState:UIControlStateNormal];
                    [themeBtn.titleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:HighlightThemeBtnFontSize]];
                } completion:nil];
            }else{
                [UIView transitionWithView:themeBtn duration:AnimateDuration_SelectThemeBtn options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
                    [themeBtn setTitleColor:UIColorFromRGBA(NormalThemeBtnColor, 1) forState:UIControlStateNormal];
                    [themeBtn.titleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:NormalThemeBtnFontSize]];
                } completion:nil];
            }
        }
        
        [UIView animateWithDuration:AnimateDuration_SelectThemeBtn
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:markLineAnimate
                         completion:nil];
    }else{
        for(int i=0; i<self.themeBtnArray.count; i++){
            UIButton *themeBtn = self.themeBtnArray[i];
            if (i == themeIndex) {
                [themeBtn setTitleColor:UIColorFromRGBA(HighlightThemeBtnColor, 1) forState:UIControlStateNormal];
                [themeBtn.titleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:HighlightThemeBtnFontSize]];
            }else{
                [themeBtn setTitleColor:UIColorFromRGBA(NormalThemeBtnColor, 1) forState:UIControlStateNormal];
                [themeBtn.titleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:NormalThemeBtnFontSize]];
            }
        }
        
        markLineAnimate();
    }
    
    [self setSortViewHiden:YES withAnimation:animate];
}

- (void)setSortIndex:(NSInteger)sortIndex asSelectedWithAnimation:(BOOL)animate{
    [self.selectedSortIndexArray replaceObjectAtIndex:self.selectedThemeIndex withObject:[NSNumber numberWithInteger:sortIndex]];
    
    if (animate) {
        for(int i=0; i<self.sortBtnArray.count; i++){
            UIButton *sortBtn = self.sortBtnArray[i];
            if (i == sortIndex) {
                [UIView transitionWithView:sortBtn duration:AnimateDuration_SelectThemeBtn options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
                    [sortBtn setTitleColor:UIColorFromRGBA(HighlightSortBtnColor, 1) forState:UIControlStateNormal];
                } completion:nil];
            }else{
                [UIView transitionWithView:sortBtn duration:AnimateDuration_SelectThemeBtn options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
                    [sortBtn setTitleColor:UIColorFromRGBA(NormalSortBtnColor, 1) forState:UIControlStateNormal];
                } completion:nil];
            }
        }
    }else{
        for(int i=0; i<self.sortBtnArray.count; i++){
            UIButton *sortBtn = self.sortBtnArray[i];
            if (i == sortIndex) {
                [sortBtn setTitleColor:UIColorFromRGBA(HighlightSortBtnColor, 1) forState:UIControlStateNormal];
            }else{
                [sortBtn setTitleColor:UIColorFromRGBA(NormalSortBtnColor, 1) forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSortViewHiden:(BOOL)hiden withAnimation:(BOOL)animate{
    [self layoutIfNeeded];
    
    if (hiden) {
        self.sortBtnViewLeadConstraint.constant = 0;
    }else{
        self.sortBtnViewLeadConstraint.constant = 0 - self.sortBtnViewWidthConstraint.constant;
    }
    
    if (hiden) {
        self.themeBtnBLeadConstraint.constant = 0;
        self.themeBtnCLeadConstraint.constant = 0;
        self.themeBtnDLeadConstraint.constant = 0;
    }else{
        self.themeBtnBLeadConstraint.constant = 0-ThemeBtnWidth;
        self.themeBtnCLeadConstraint.constant = 0-ThemeBtnWidth;
        self.themeBtnDLeadConstraint.constant = 0-ThemeBtnWidth;
    }
    
    void(^animateBlock)() = ^(){
        self.sortBtnView.alpha = hiden ? 0 : 1;
        self.filtBtnBrownIcon.alpha = hiden ? 0 : 1;
        self.filtBtnClearIcon.alpha = hiden ? 1 : 0;
        for(int i=0; i<self.themeBtnArray.count; i++){
            UIButton *themeBtn = self.themeBtnArray[i];
            if (hiden) {
                themeBtn.alpha = 1;
            }else{
                if (i == self.selectedThemeIndex) {
                    themeBtn.alpha = 1;
                }else{
                    themeBtn.alpha = 0;
                }
            }
        }
        [self layoutIfNeeded];
    };
    
    if (animate) {
        [UIView animateWithDuration:AnimateDuration_ShowSortView delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:animateBlock completion:nil];
    }else{
        animateBlock();
    }
}


#pragma mark Button Action
- (IBAction)themeBtnAction:(id)sender {
    NSInteger selectedThemeIndex = 0;
    for(int i=0; i<self.themeBtnArray.count; i++){
        if (sender == self.themeBtnArray[i]) {
            selectedThemeIndex = i;
            break;
        }
    }
    
    [self setThemeIndex:selectedThemeIndex asSelectedWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(planTabTabView:didSelectThemeIndex:)]) {
        [self.delegate planTabTabView:self didSelectThemeIndex:self.selectedThemeIndex];
    }
}

- (IBAction)sortBtnAction:(id)sender {
    NSInteger sortBtnIndex = [self.sortBtnArray indexOfObject:sender];
    
    [self setSortIndex:sortBtnIndex asSelectedWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(planTabTabView:didSelectSortIndex:)]) {
        [self.delegate planTabTabView:self didSelectSortIndex:sortBtnIndex];
    }
}

- (IBAction)filtBtnAction:(id)sender {
    BOOL isSortViewHiden = [self isSortViewHiden];
    
    NSNumber *curSortIndex = [self.selectedSortIndexArray objectAtIndex:self.selectedThemeIndex];
    [self setSortIndex:[curSortIndex integerValue] asSelectedWithAnimation:NO];
    [self setSortViewHiden:!isSortViewHiden withAnimation:YES];
}

#pragma mark Inner Function
- (BOOL)isSortViewHiden{
    if (self.sortBtnViewLeadConstraint.constant < 0) {
        return NO;
    }else{
        return YES;
    }
}





@end
