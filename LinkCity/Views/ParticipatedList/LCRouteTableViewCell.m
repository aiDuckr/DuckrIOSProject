//
//  LCRouteTableViewCell.m
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCRouteTableViewCell.h"
#import "EGOImageView.h"

@interface LCRouteTableViewCell()

@property (weak, nonatomic) IBOutlet EGOImageView *routeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottomLineHeight;


@end
@implementation LCRouteTableViewCell

- (void)awakeFromNib {
    self.routeImageView.userInteractionEnabled = YES;
    self.cellBottomLineHeight.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRouteInfo:(LCRouteInfo *)routeInfo{
    _routeInfo = routeInfo;
    
    self.routeImageView.imageURL = [NSURL URLWithString:routeInfo.imageThumb];
    self.titleLabel.text = routeInfo.placeName;
    [self.detailLabel setText:routeInfo.descriptionStr withLineSpace:8];
}


@end
