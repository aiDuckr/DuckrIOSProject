//
//  LCPlaceSearchRouteCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlaceSearchRouteCell.h"

@implementation LCPlaceSearchRouteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowRouteView:(NSString *)routeTitle isLastOne:(BOOL)lastOne {
    self.routeTitleLabel.text = routeTitle;
    if (lastOne) {
        self.bottomViewHeightConstraint.constant = 10.0f;
    } else {
        self.bottomViewHeightConstraint.constant = 0.0f;
    }
}

@end
