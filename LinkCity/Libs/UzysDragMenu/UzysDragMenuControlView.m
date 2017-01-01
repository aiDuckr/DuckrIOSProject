//
//  UzysDragMenuControlView.m
//  UzysDragMenu
//
//  Created by Jaehoon Jung on 13. 2. 25..
//  Copyright (c) 2013년 Uzys. All rights reserved.
//

#import "UzysDragMenuControlView.h"

@implementation UzysDragMenuControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (CGSize)intrinsicContentSize {
    return CGSizeMake(DEVICE_WIDTH, self.btnAction.frame.size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - using gestureRecognizer
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self intrinsicContentSize];
}

- (void)dealloc {
    [_btnAction release];
    [super ah_dealloc];
}

@end
