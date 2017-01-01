//
//  LCUserInfoUserRouteCell.m
//  LinkCity
//
//  Created by roy on 3/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserInfoUserRouteCell.h"

@implementation LCUserInfoUserRouteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    
    UIImage *maskImage = [[UIImage imageNamed:@"UserRouteMask"] resizableImageWithCapInsets:UIEdgeInsetsMake(60, 5, 1, 5)];
//    self.routeMaskImageView.backgroundColor = [UIColor redColor];
    self.routeMaskImageView.image = maskImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserRoute:(LCUserRouteModel *)userRoute{
    _userRoute = userRoute;
    [self updateShow];
}

- (void)updateShow{
    NSString *routeCoverUrl = nil;
    for (LCRoutePlaceModel *routePlace in self.userRoute.routePlaces){
        if ([LCStringUtil isNotNullString:routePlace.placeCoverUrl]) {
            routeCoverUrl = routePlace.placeCoverUrl;
            break;
        }
    }
    
    //TODO:   无图片时
    [self.routeImageView setImageWithURL:[NSURL URLWithString:routeCoverUrl] placeholderImage:nil];
    self.routeTitleLabel.text = [LCStringUtil getNotNullStr:self.userRoute.routeTitle];
    
    NSInteger dayNum = [self.userRoute getRouteDayNum];
    self.routeDayNumLabel.text = [NSString stringWithFormat:@"%ld",(long)dayNum];
    
    if (dayNum == 0) {
        self.routeLabelOne.hidden = YES;
        self.routeLabelTwo.hidden = YES;
        self.routeLabelThree.hidden = YES;
        self.routeLabelFour.hidden = YES;
    }else if(dayNum == 1){
        self.routeLabelOne.hidden = NO;
        self.routeLabelTwo.hidden = YES;
        self.routeLabelThree.hidden = YES;
        self.routeLabelFour.hidden = YES;
        
        NSString *str = [self.userRoute getRoutePlaceStringForDay:1 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day1: %@",str];
        self.routeLabelOne.text = str;
    }else if(dayNum == 2){
        self.routeLabelOne.hidden = NO;
        self.routeLabelTwo.hidden = NO;
        self.routeLabelThree.hidden = YES;
        self.routeLabelFour.hidden = YES;
        
        NSString *str = [self.userRoute getRoutePlaceStringForDay:1 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day1: %@",str];
        self.routeLabelOne.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:2 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day2: %@",str];
        self.routeLabelTwo.text = str;
    }else if(dayNum == 3){
        self.routeLabelOne.hidden = NO;
        self.routeLabelTwo.hidden = NO;
        self.routeLabelThree.hidden = NO;
        self.routeLabelFour.hidden = YES;
        
        NSString *str = [self.userRoute getRoutePlaceStringForDay:1 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day1: %@",str];
        self.routeLabelOne.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:2 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day2: %@",str];
        self.routeLabelTwo.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:3 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day3: %@",str];
        self.routeLabelThree.text = str;
    }else if(dayNum == 4){
        self.routeLabelOne.hidden = NO;
        self.routeLabelTwo.hidden = NO;
        self.routeLabelThree.hidden = NO;
        self.routeLabelFour.hidden = NO;
        
        NSString *str = [self.userRoute getRoutePlaceStringForDay:1 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day1: %@",str];
        self.routeLabelOne.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:2 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day2: %@",str];
        self.routeLabelTwo.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:3 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day3: %@",str];
        self.routeLabelThree.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:4 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day4: %@",str];
        self.routeLabelFour.text = str;
    }else{
        self.routeLabelOne.hidden = NO;
        self.routeLabelTwo.hidden = NO;
        self.routeLabelThree.hidden = NO;
        self.routeLabelFour.hidden = NO;
        
        NSString *str = [self.userRoute getRoutePlaceStringForDay:1 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day1: %@",str];
        self.routeLabelOne.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:2 withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day2: %@",str];
        self.routeLabelTwo.text = str;
        
        str = @"......";
        self.routeLabelThree.text = str;
        
        str = [self.userRoute getRoutePlaceStringForDay:dayNum withSeparator:@"-"];
        str = [NSString stringWithFormat:@"Day%ld: %@",(long)dayNum,str];
        self.routeLabelFour.text = str;
    }
}

+ (CGFloat)getCellHeightForUserRoute:(LCUserRouteModel *)userRoute{
    CGFloat height = 10;
    height += (DEVICE_WIDTH-10-30)/690*320;
    height += 10;
    
    NSInteger dayNum = [userRoute getRouteDayNum];
    dayNum = MIN(dayNum, 4);
    CGFloat fontHeight = 15;
    CGFloat gapHeight = 8;
    height += dayNum*fontHeight;
    if (dayNum-1 > 0) {
        height += (dayNum-1)*gapHeight;
    }

    height += 10;
    height += 10;
    
    LCLogInfo(@"LCUserInfoUserRouteCell getCellHeight %f",height);
    return height;
}

@end
