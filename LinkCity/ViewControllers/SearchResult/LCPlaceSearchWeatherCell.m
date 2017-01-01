//
//  LCPlaceSearchWeatherCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlaceSearchWeatherCell.h"

@implementation LCPlaceSearchWeatherCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat width = DEVICE_WIDTH / 3.0f;
    self.todayViewWidthConstraint.constant = width;
    self.tomorrowWidthConstraint.constant = width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWeather:(NSArray *)weaterArray {
    if (nil == weaterArray || 0 == weaterArray.count) {
        return ;
    }
    
    LCWeatherDay *weather = nil;
    if (weaterArray.count > 0) {
        weather = [weaterArray objectAtIndex:0];
        self.dateLabel.text = weather.date;
        self.temperatureLabel.text = weather.temperature;
        NSString *imageName = nil;
        if ([LCStringUtil isNotNullString:weather.dayName]) {
            self.dayNameLabel.text = weather.dayName;
            imageName = [NSString stringWithFormat:@"WeatherDay%@", weather.dayId];
        } else {
            self.dayNameLabel.text = weather.nightName;
            imageName = [NSString stringWithFormat:@"WeatherDay%@", weather.nightId];
        }
        self.weatherImageView.image = [UIImage imageNamed:imageName];
    }

    if (weaterArray.count > 1) {
        weather = [weaterArray objectAtIndex:1];
        self.tDateLabel.text = weather.date;
        self.tTemperatureLabel.text = weather.temperature;
        NSString *imageName = nil;
        if ([LCStringUtil isNotNullString:weather.dayName]) {
            self.tDayNameLabel.text = weather.dayName;
            imageName = [NSString stringWithFormat:@"WeatherDay%@", weather.dayId];
        } else {
            self.tDayNameLabel.text = weather.nightName;
            imageName = [NSString stringWithFormat:@"WeatherDay%@", weather.nightId];
        }
        self.tWeatherImageView.image = [UIImage imageNamed:imageName];
    }
    
    if (weaterArray.count > 2) {
        weather = [weaterArray objectAtIndex:2];
        self.afDateLabel.text = weather.date;
        self.afTemperatureLabel.text = weather.temperature;
        NSString *imageName = nil;
        if ([LCStringUtil isNotNullString:weather.dayName]) {
            self.afDayNameLabel.text = weather.dayName;
            imageName = [NSString stringWithFormat:@"WeatherDay%@", weather.dayId];
        } else {
            self.afDayNameLabel.text = weather.nightName;
            imageName = [NSString stringWithFormat:@"WeatherDay%@", weather.nightId];
        }
        self.afWeatherImageView.image = [UIImage imageNamed:imageName];
    }
}
@end
