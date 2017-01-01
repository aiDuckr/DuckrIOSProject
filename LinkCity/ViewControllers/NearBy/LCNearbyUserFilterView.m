//
//  LCNearbyUserFilterView.m
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNearbyUserFilterView.h"

@implementation LCNearbyUserFilterView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCNearbyFilterViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCNearbyUserFilterView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCNearbyUserFilterView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, 255);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}



- (IBAction)filtFemaleButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyUserFilterView:filtType:)]) {
        [self.delegate nearbyUserFilterView:self filtType:LCUserFilterType_Female];
    }
}
- (IBAction)filterMaleButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyUserFilterView:filtType:)]) {
        [self.delegate nearbyUserFilterView:self filtType:LCUserFilterType_Male];
    }
}
- (IBAction)filterIdentifyButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyUserFilterView:filtType:)]) {
        [self.delegate nearbyUserFilterView:self filtType:LCUserFilterType_Identified];
    }
}
- (IBAction)filtAllButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyUserFilterView:filtType:)]) {
        [self.delegate nearbyUserFilterView:self filtType:LCUserFilterType_All];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyUserFilterViewDidFiltCancel:)]) {
        [self.delegate nearbyUserFilterViewDidFiltCancel:self];
    }
}



@end
