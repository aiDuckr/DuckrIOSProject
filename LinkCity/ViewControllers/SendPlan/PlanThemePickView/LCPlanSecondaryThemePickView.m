//
//  LCPlanSecondaryThemePickView.m
//  LinkCity
//
//  Created by Roy on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanSecondaryThemePickView.h"

@interface LCPlanSecondaryThemePickView()
@property (nonatomic, strong) UIButton *selectedThemeBtn;
@end

@implementation LCPlanSecondaryThemePickView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCPlanThemePickView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCPlanSecondaryThemePickView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCPlanSecondaryThemePickView *)v;
        }
    }
    
    return nil;
}

- (void)awakeFromNib{
    self.themeBtnArray = @[self.themeBtnA,
                           self.themeBtnB,
                           self.themeBtnC,
                           self.themeBtnD,
                           self.themeBtnE,
                           self.themeBtnF,
                           self.themeBtnG,
                           self.themeBtnH];
    
    for (UIButton *btn in self.themeBtnArray){
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 14;
        [self setThemeBtn:btn selected:NO];
        
        [btn addTarget:self action:@selector(themeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    self.nextBtn.layer.borderColor = DefaultSpalineColor.CGColor;
    [self.nextBtn setTitleColor:UIColorFromRGBA(0xaba7a2, 1) forState:UIControlStateNormal];
    self.nextBtn.layer.borderWidth = 1;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 14;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH-18, 184);
}

- (void)setThemeArray:(NSArray *)themeArray{
    _themeArray = themeArray;
    
    for(int i=0; i<self.themeArray.count && i<self.themeBtnArray.count; i++){
        LCRouteThemeModel *aTheme = [self.themeArray objectAtIndex:i];
        UIButton *aBtn = [self.themeBtnArray objectAtIndex:i];
        aBtn.hidden = NO;
        [aBtn setTitle:aTheme.themeDesc forState:UIControlStateNormal];
    }
    
    if (self.themeArray.count < self.themeBtnArray.count) {
        for (int i=(int)self.themeArray.count; i<self.themeBtnArray.count; i++){
            UIButton *aBtn = [self.themeBtnArray objectAtIndex:i];
            aBtn.hidden = YES;
        }
    }
}

- (IBAction)backBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(planSecondaryThemePickViewDidBack:)]) {
        [self.delegate planSecondaryThemePickViewDidBack:self];
    }
}

- (void)themeBtnAction:(UIButton *)sender {
    self.selectedThemeBtn = sender;
    
    for(UIButton *btn in self.themeBtnArray){
        [self setThemeBtn:btn selected:NO];
    }
    [self setThemeBtn:sender selected:YES];
    
    [self.nextBtn setTitleColor:UIColorFromRGBA(0x2c2a28, 1) forState:UIControlStateNormal];
}

- (IBAction)nextBtnAction:(id)sender {
    if (!self.selectedThemeBtn) {
        [YSAlertUtil tipOneMessage:@"请选择邀约标签" onView:self yoffset:0 delay:TipDefaultDelay];
        return;
    }
    
    NSInteger btnIndex = [self.themeBtnArray indexOfObject:self.selectedThemeBtn];
    if ([self.delegate respondsToSelector:@selector(planSecondaryThemePickView:didSelectTheme:)] &&
        self.themeArray.count > btnIndex) {
        [self.delegate planSecondaryThemePickView:self didSelectTheme:[self.themeArray objectAtIndex:btnIndex]];
    }
}


- (void)setThemeBtn:(UIButton *)btn selected:(BOOL)select{
    if (select) {
        btn.backgroundColor = UIColorFromRGBA(0xfee100, 1);
        [btn setTitleColor:UIColorFromRGBA(0x6b450a, 1) forState:UIControlStateNormal];
    }else{
        btn.backgroundColor = UIColorFromRGBA(0xfaf9f8, 1);
        [btn setTitleColor:UIColorFromRGBA(0x7d7975, 1) forState:UIControlStateNormal];
    }
}

@end
