//
//  LCTableView.m
//  LinkCity
//
//  Created by roy on 12/13/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCTableView.h"

@interface LCTableView()
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *tipImageView;
@end

@implementation LCTableView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc]init];
        self.tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.tipLabel.textColor = UIColorFromR_G_B_A(219, 219, 219, 1);
        self.tipLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:15];
        self.tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.tipLabel.numberOfLines = 0;
        [self.superview addSubview:self.tipLabel];
        //[self.superview insertSubview:self.tipLabel belowSubview:self];
        NSLayoutConstraint *centerHorizontal = [NSLayoutConstraint constraintWithItem:self.tipLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *centerVertical = [NSLayoutConstraint constraintWithItem:self.tipLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.tipLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:DEVICE_WIDTH - 60];
        [self.superview addConstraint:centerHorizontal];
        [self.superview addConstraint:centerVertical];
        [self.superview addConstraint:widthConstraint];
        [self.tipLabel setText:self.tipWhenEmpty withLineSpace:8 textAlignment:NSTextAlignmentCenter];
        self.tipLabel.hidden = YES;
    }
    if (!self.tipImageView) {
        self.tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.tipImageName]];
        self.tipImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview addSubview:self.tipImageView];
        //[self.superview insertSubview:self.tipImageView belowSubview:self];
        NSLayoutConstraint *centerWithLabel = [NSLayoutConstraint constraintWithItem:self.tipImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tipLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *topToLabel = [NSLayoutConstraint constraintWithItem:self.tipImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tipLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10];
        
        [self.superview addConstraint:centerWithLabel];
        [self.superview addConstraint:topToLabel];
        self.tipImageView.hidden = YES;
    }
    
}

- (void)reloadData{
    
    if ([self isEmpty] && [LCStringUtil isNotNullString:self.tipWhenEmpty] && [LCStringUtil isNotNullString:self.tipImageName]) {
        [self showTip];
    }else{
        [self hideTip];
    }
    
    [super reloadData];
}

- (BOOL)isEmpty{
    if (self.dataSource &&
        [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] &&
        [self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSInteger sectionNum = [self.dataSource numberOfSectionsInTableView:self];
        for (int i=0; i<sectionNum; i++) {
            NSInteger rowNum = [self.dataSource tableView:self numberOfRowsInSection:i];
            if (rowNum>0) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)showTip{
    if (self.tipLabel && self.tipWhenEmpty) {
        [self.tipLabel setText:self.tipWhenEmpty withLineSpace:8 textAlignment:NSTextAlignmentCenter];
        self.tipLabel.hidden = NO;
    }
    if (self.tipImageView && self.tipImageName) {
        self.tipImageView.image = [UIImage imageNamed:self.tipImageName];
        self.tipImageView.hidden = NO;
    }
}
- (void)hideTip{
    if (self.tipLabel) {
        self.tipLabel.hidden = YES;
    }
    if (self.tipImageView) {
        self.tipImageView.hidden = YES;
    }
}
@end
