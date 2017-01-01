//
//  LCHomeLocalPlaceCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeLocalPlaceCell.h"
#import "LCProvincePickerVC.h"

@interface LCHomeLocalPlaceCell()<LCProvincePickerDelegate>
@property (nonatomic, strong) LCProvincePickerVC *provincePickerVC;
@end

@implementation LCHomeLocalPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowCell:(LCCityModel *)cityObj withWeatherDay:(LCWeatherDay *)weatherDay {
    if (nil != cityObj && [LCStringUtil isNotNullString:cityObj.cityThumbImage]) {
        [self.coverImageView setImageWithURL:[NSURL URLWithString:cityObj.cityThumbImage] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }
    NSString *dayName = [LCStringUtil getNotNullStr:weatherDay.dayName];
    NSString *temperature = [LCStringUtil getNotNullStr:weatherDay.temperature];
    self.weatherNameLabel.text = [NSString stringWithFormat:@"%@ %@", dayName, temperature];
    self.weatherWindLabel.text = [LCStringUtil getNotNullStr:weatherDay.dWindLevel];
    
    NSString *imageName = nil;
    if ([LCStringUtil isNotNullString:weatherDay.dayName]) {
        imageName = [NSString stringWithFormat:@"WeatherDay%@", weatherDay.dayId];
    } else {
        imageName = [NSString stringWithFormat:@"WeatherDay%@", weatherDay.nightId];
    }
    
    self.weatherImageView.image = [UIImage imageNamed:imageName];
}

- (IBAction)switchCityAction:(id)sender {
    if (!self.provincePickerVC) {
        self.provincePickerVC = [LCProvincePickerVC createInstance];
        self.provincePickerVC.delegate = self;
    }
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:self.provincePickerVC animated:YES];
}

#pragma mark - LCProvincePicker Delegate
- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    [LCDataManager sharedInstance].isAlertLocationCity = YES;
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    if ([LCStringUtil isNotNullString:city.cityName] && ![city.cityName isEqualToString:locName]) {
        [self.coverImageView setImageWithURL:[NSURL URLWithString:city.cityThumbImage] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        [LCDataManager sharedInstance].currentCity = city;
    }
}

@end
