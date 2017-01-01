//
//  LCSendFreePlanImageBottomCell.m
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendFreePlanImageBottomCell.h"

@implementation LCSendFreePlanImageBottomCell

- (void)awakeFromNib {
    [self.submibBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitBtnAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(sendFreePlanImageBottomCellDidClickSubmitBtn:)]) {
        [self.delegate sendFreePlanImageBottomCellDidClickSubmitBtn:self];
    }
}

@end
