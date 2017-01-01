//
//  LCUserRouteDetailCell.h
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCRoutePlaceModel.h"


@interface LCRoutePlaceCell : UITableViewCell
@property (nonatomic, strong) LCRoutePlaceModel *routePlace;

@property (nonatomic, assign) BOOL isFirstPlaceOfDay;
@property (nonatomic, assign) BOOL isLastPlaceOfDay;
@property (nonatomic, assign) BOOL isLastPlaceOfRoute;

//UI
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageHeight;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeDescriptionLabel;


@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;




+ (CGFloat)getCellHeightForRoutePlace:(LCRoutePlaceModel *)routePlace
                      firstPlaceOfDay:(BOOL)isFirstPlaceOfDay
                       lastPlaceOfDay:(BOOL)isLastPlaceOfDay
                     lastPlaceOfRoute:(BOOL)isLastPlaceOfRoute;
@end
