//
//  LCPlanRouteCellForRoute.m
//  LinkCity
//
//  Created by roy on 2/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanRouteCellForRoute.h"

static NSString *const DefaultImageName = @"DefaultPlaceImageGray";

@implementation LCPlanRouteCellForRoute

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRoutePlace:(LCRoutePlaceModel *)routePlace{
    _routePlace = routePlace;
    
    [self updateShow];
}

- (void)updateShow{
    if (self.routePlace) {
        if ([LCStringUtil isNotNullString:self.routePlace.placeName]) {
            self.routeTitleLabel.text = self.routePlace.placeName;
        }else{
            self.routeTitleLabel.text = @"";
        }
        if ([LCStringUtil isNotNullString:self.routePlace.descriptionStr]) {
            self.routeDetailLabel.text = self.routePlace.descriptionStr;
        }else{
            self.routeDetailLabel.text = @"";
        }
        if ([LCStringUtil isNotNullString:self.routePlace.placeCoverThumbUrl]) {
            [self.routeImageView setImageWithURL:[NSURL URLWithString:self.routePlace.placeCoverThumbUrl] placeholderImage:[UIImage imageNamed:DefaultImageName]];
        }else{
            [self.routeImageView setImage:[UIImage imageNamed:DefaultImageName]];
        }
    }
}

@end
