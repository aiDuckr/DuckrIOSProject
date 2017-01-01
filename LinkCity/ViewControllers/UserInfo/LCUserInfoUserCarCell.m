//
//  LCUserInfoUserCarCell.m
//  LinkCity
//
//  Created by roy on 3/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserInfoUserCarCell.h"

@implementation LCUserInfoUserCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *topBgImage = [UIImage imageNamed:LCPlanCellTopBg];
    topBgImage = [topBgImage resizableImageWithCapInsets:LCCellTopBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.topBgImageView.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:LCPlanCellBottomBg];
    bottomImage = [bottomImage resizableImageWithCapInsets:LCCellBottomBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.bottomImageView.image = bottomImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserCar:(LCCarIdentityModel *)userCar{
    _userCar = userCar;
    [self updateShow];
}

- (void)updateShow{
    [self.carImageView setImageWithURL:[NSURL URLWithString:self.userCar.carPictureThumbUrl] placeholderImage:nil];
    
    self.carBrandLabel.text = [NSString stringWithFormat:@"%@%@",
                               [LCStringUtil getNotNullStr:self.userCar.carBrand],
                               [LCStringUtil getNotNullStr:self.userCar.carType]];
    
    self.drivingYearLabel.text = [self getNotEmptyStrFromInteger:self.userCar.drivingYear];
    self.carYearLabel.text = [self getNotEmptyStrFromInteger:self.userCar.carYear];
    self.seatLabel.text = [self getNotEmptyStrFromInteger:self.userCar.carSeat];
    
    if ([LCDecimalUtil isOverZero:self.userCar.dayPrice]) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@元/天",self.userCar.dayPrice];
    }else{
        self.priceLabel.text = @"-";
    }
    
    self.serviceNumLabel.text = [NSString stringWithFormat:@"服务人数：%@人",[self getNotEmptyStrFromInteger:self.userCar.serviceNumber]];
    
    self.carAreaLabel.text = [NSString stringWithFormat:@"服务路线：%@",self.userCar.carArea];
}

- (IBAction)carPicButtonAction:(id)sender {
    if ([LCStringUtil isNotNullString:self.userCar.carPictureUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.userCar.carPictureUrl;
        imageModel.imageUrlThumb = self.userCar.carPictureThumbUrl;
        
        [LCViewSwitcher presentPhotoScannerToShow:@[imageModel] fromIndex:0];
    }
}


+ (CGFloat)getCellHeight{
    return 182;
}

- (NSString *)getNotEmptyStrFromInteger:(NSInteger)aNum{
    if (aNum < 0) {
        return @"-";
    }else{
        return [NSString stringWithFormat:@"%ld",(long)aNum];
    }
}


@end
