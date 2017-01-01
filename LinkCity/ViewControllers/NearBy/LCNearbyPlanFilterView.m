//
//  LCNearbyPlanFilterView.m
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNearbyPlanFilterView.h"

@implementation LCNearbyPlanFilterView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCNearbyFilterViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCNearbyPlanFilterView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCNearbyPlanFilterView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, 182);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}


- (IBAction)departTimeButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyPlanFilterViewDidFiltDepartTime:)]) {
        [self.delegate nearbyPlanFilterViewDidFiltDepartTime:self];
    }
}
- (IBAction)publicButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyPlanFilterViewDidFiltPublishTime:)]) {
        [self.delegate nearbyPlanFilterViewDidFiltPublishTime:self];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyPlanFilterViewDidFiltCancel:)]) {
        [self.delegate nearbyPlanFilterViewDidFiltCancel:self];
    }
}



@end
