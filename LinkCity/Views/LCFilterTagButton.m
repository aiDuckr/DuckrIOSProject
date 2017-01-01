//
//  LCFilterTagButton.m
//  LinkCity
//
//  Created by 张宗硕 on 8/1/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCFilterTagButton.h"

@implementation LCFilterTagButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self updateButtonUnSelected];
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
    self.type = FilterTagButtonType_Default;
    self.appearance = FilterTagButtonAppearance_Normal;
}

- (void)setAppearance:(FilterTagButtonAppearance)appearance {
    _appearance = appearance;
    [self updateButtonUnSelectedAppearance];
}

- (void)clickAction:(id)sender {
    if (FilterTagButtonType_Radio == self.type && YES == self.selected) {
        [self updateFilterTagButtonStatus:self.selected];
        return ;

    }
    self.selected = !self.selected;
    [self updateFilterTagButtonStatus:self.selected];
}

- (void)updateFilterTagButtonStatus:(BOOL)isSelected {
//    self.isSelected = isSelected;
    self.selected = isSelected;
//    if (YES == self.isSelected) {
    if (YES == self.selected) {
        [self updateButtonSelected];
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterTagButtonSelected:)]) {
            [self.delegate filterTagButtonSelected:self];
        }
    } else {
        [self updateButtonUnSelected];
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterTagButtonUnSelected:)]) {
            [self.delegate filterTagButtonUnSelected:self];
        }
    }
}

- (void)updateFilterTagButtonApperance:(BOOL)isSelected {
    self.selected = isSelected;
    if (YES == self.selected) {
        [self updateButtonSelected];
    } else {
        [self updateButtonUnSelected];
    }
}

- (void)updateShowButtons:(NSArray *)buttons {
    switch (self.type) {
        case FilterTagButtonType_Radio:
            [self updateRadioButtons:buttons];
            break;
            
        default:
            break;
    }
}

- (void)updateRadioButtons:buttons {
    if (YES == self.isSelected) {
        for (LCFilterTagButton *btn in buttons) {
            if (btn != self) {
                [btn updateButtonUnSelected];
            }
        }
    }
}

- (void)updateButtonUnSelectedAppearance {
    switch (self.appearance) {
        case FilterTagButtonAppearance_Normal:
            self.backgroundColor = UIColorFromRGBA(0xf5f5f3, 1.0f);
            break;
        case FilterTagButtonAppearance_SearchGray:
            self.backgroundColor = UIColorFromRGBA(0xf7f7f5, 1.0f);
            break;
        case FilterTagButtonAppearance_SearchWhite:
            self.backgroundColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}

- (void)updateButtonUnSelected {
    self.selected = NO;
//    self.isSelected = NO;
    [self updateButtonUnSelectedAppearance];
    
    [self setTitleColor:UIColorFromRGBA(0x7d7975, 1.0f) forState:UIControlStateNormal];
    [self setTintColor:[UIColor clearColor]];
}

- (void)updateButtonSelected {
    self.selected = YES;
//    self.isSelected = YES;
    self.backgroundColor = UIColorFromRGBA(0xfedd00, 1.0f);
    [self setTitleColor:UIColorFromRGBA(0x7f4802, 1.0f) forState:UIControlStateSelected];
    [self setTintColor:[UIColor clearColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
