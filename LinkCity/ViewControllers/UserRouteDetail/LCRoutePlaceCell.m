//
//  LCUserRouteDetailCell.m
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRoutePlaceCell.h"

@implementation LCRoutePlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.coverImageView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = UIColorFromR_G_B_A(232, 228, 221, 1).CGColor;
    
    self.isFirstPlaceOfDay = NO;
    self.isLastPlaceOfDay = NO;
    self.isLastPlaceOfRoute = NO;
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
    if (self.isFirstPlaceOfDay) {
        self.topLineHeight.constant = 14;
    }else{
        self.topLineHeight.constant = 0;
    }
    
    
    if (self.isLastPlaceOfRoute) {
        self.bottomLineView.hidden = YES;
        self.bottomLineHeight.constant = 10;
    }else{
        self.bottomLineView.hidden = NO;
        
        if (self.isLastPlaceOfDay) {
            self.bottomLineHeight.constant = 14;
        }else{
            self.bottomLineHeight.constant = 10;
        }
    }
    
    if ([LCStringUtil isNotNullString:self.routePlace.placeCoverThumbUrl]) {
        self.coverImageHeight.constant = (DEVICE_WIDTH-20)/712*475;
        [self.coverImageView setImageWithURL:[NSURL URLWithString:self.routePlace.placeCoverThumbUrl] placeholderImage:nil];
    }else{
        self.coverImageHeight.constant = 0;
    }
    
    self.placeNameLabel.text = [LCStringUtil getNotNullStr:self.routePlace.placeName];
    [self.placeDescriptionLabel setText:[LCStringUtil getNotNullStr:self.routePlace.descriptionStr] withLineSpace:LCTextFieldLineSpace];

}

+ (CGFloat)getCellHeightForRoutePlace:(LCRoutePlaceModel *)routePlace
                      firstPlaceOfDay:(BOOL)isFirstPlaceOfDay
                       lastPlaceOfDay:(BOOL)isLastPlaceOfDay
                     lastPlaceOfRoute:(BOOL)isLastPlaceOfRoute{
    
    CGFloat height = 0;
    
    static LCRoutePlaceCell *staticCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCRoutePlaceCell class]) bundle:nil];
        NSArray *views = [nib instantiateWithOwner:nil options:nil];
        for (UIView *v in views){
            if ([v isKindOfClass:[LCRoutePlaceCell class]]) {
                staticCell = (LCRoutePlaceCell *)v;
                break;
            }
        }
    });
    
    
    if (isFirstPlaceOfDay) {
        height += 14;
    }else{
        height += 0;
    }
    
    if (isLastPlaceOfRoute) {
        height += 10;
    }else{
        if (isLastPlaceOfDay) {
            height += 14;
        }else{
            height += 10;
        }
    }
    
    if ([LCStringUtil isNotNullString:routePlace.placeCoverThumbUrl]) {
        height += (DEVICE_WIDTH-20)/712*475;
    }else{
        height += 0;
    }
    
    height += 33;
    
    height += [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStr:routePlace.descriptionStr] withFont:staticCell.placeDescriptionLabel.font lineSpace:LCTextFieldLineSpace labelWidth:(DEVICE_WIDTH-40)];
    
    height += 12;
    
    height += 10; //调整误差
    LCLogInfo(@"LCRoutePlaceCellHeight %f forRouteName:%@",height,routePlace.placeName);
    
    return height;
}

@end
