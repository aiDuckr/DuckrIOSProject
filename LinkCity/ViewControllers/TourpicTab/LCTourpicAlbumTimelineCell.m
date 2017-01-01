//
//  LCTourpicAlbumTimelineCell.m
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicAlbumTimelineCell.h"

@interface LCTourpicAlbumTimelineCell()

@property (nonatomic,strong) UIImageView *playIcon;

@property (nonatomic,strong) UIImageView *firstImageView;

@property (nonatomic,strong) UIImageView *secondImageView;

@property (nonatomic,strong) UIImageView *thirdImageView;

@property (nonatomic,strong) UIImageView *fourthImageView;

@end

@implementation LCTourpicAlbumTimelineCell

- (void)awakeFromNib {
    // Initialization code
    //self.descLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;

    //self.descLabel.numberOfLines = 0;
    self.withWhoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.withWhoLabel.numberOfLines = 0;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.firstImageView = [[UIImageView alloc] init];
    self.secondImageView = [[UIImageView alloc] init];
    self.thirdImageView = [[UIImageView alloc] init];
    self.fourthImageView = [[UIImageView alloc] init];
    
    self.firstImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.fourthImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.firstImageView.clipsToBounds = YES;
    self.secondImageView.clipsToBounds = YES;
    self.thirdImageView.clipsToBounds = YES;
    self.fourthImageView.clipsToBounds = YES;
    self.playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToupicVideoPlayIcon"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshLayout:(LCTourpic *)tourpic {
    if ([LCStringUtil isNullString:tourpic.desc]) {
        self.descAndWhereHeightConstraint.constant = 0;
    } else {
        self.descAndWhereHeightConstraint.constant = 11;
    }
    if (nil == tourpic.companyArr || 0 == tourpic.companyArr.count) {
        self.withWhoImageView.hidden = YES;
    } else {
        self.withWhoImageView.hidden = NO;
    }
}

- (void)updateCellWithTourpic:(LCTourpic *)tourpic {
    [self.playIcon removeFromSuperview];
    [self.firstImageView removeFromSuperview];
    [self.secondImageView removeFromSuperview];
    [self.thirdImageView removeFromSuperview];
    [self.fourthImageView removeFromSuperview];
    
    if (tourpic.thumbPhotoUrls && tourpic.thumbPhotoUrls.count == 1) {
        [self.coverImageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPicUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        if (tourpic.type == LCTourpicType_Video) {
            [self.playIcon sizeToFit];
            [self.coverImageView addSubview:self.playIcon];
            self.playIcon.center = CGPointMake(self.coverImageView.width / 2, self.coverImageView.height / 2);
        }
        return;
    } else {
        if (tourpic.thumbPhotoUrls && tourpic.thumbPhotoUrls.count > 0) {
            if (tourpic.thumbPhotoUrls.count > 1) {
                [self.coverImageView setImage:nil];
                self.coverImageView.backgroundColor = [UIColor whiteColor];
                [self.firstImageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPhotoUrls[0]] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
                [self.secondImageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPhotoUrls[1]] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
                [self.coverImageView addSubview:self.firstImageView];
                [self.coverImageView addSubview:self.secondImageView];
                
            }
            if (tourpic.thumbPhotoUrls.count > 2){
                [self.thirdImageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPhotoUrls[2]] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
                [self.coverImageView addSubview:self.thirdImageView];
            }
            if (tourpic.thumbPhotoUrls.count > 3){
                [self.fourthImageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPhotoUrls[3]] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
                [self.coverImageView addSubview:self.fourthImageView];
            }
            
            if (tourpic.thumbPhotoUrls.count == 2) {
                self.firstImageView.frame = CGRectMake(0, 0, self.coverImageView.width / 2 - 1, self.coverImageView.height);
                self.secondImageView.frame = CGRectMake(self.coverImageView.width / 2 + 1, 0, self.coverImageView.width / 2 - 1, self.coverImageView.height);
            } else if (tourpic.thumbPhotoUrls.count == 3) {
                self.firstImageView.frame = CGRectMake(0, 0, self.coverImageView.width / 2 - 1, self.coverImageView.height);
                self.secondImageView.frame = CGRectMake(self.coverImageView.width / 2 + 1, 0, self.coverImageView.width / 2 - 1, self.coverImageView.height / 2 -1);
                self.thirdImageView.frame = CGRectMake(self.coverImageView.width / 2 + 1, self.coverImageView.height / 2 + 1, self.coverImageView.width / 2 - 1, self.coverImageView.height / 2 -1);
            } else if (tourpic.thumbPhotoUrls.count >= 4) {
                self.firstImageView.frame = CGRectMake(0, 0, self.coverImageView.width / 2 - 1, self.coverImageView.height / 2 - 1);
                self.secondImageView.frame = CGRectMake(0, self.coverImageView.height / 2 + 1, self.coverImageView.width / 2 - 1, self.coverImageView.height / 2 - 1);
                self.thirdImageView.frame = CGRectMake(self.coverImageView.width / 2 + 1, 0, self.coverImageView.width / 2 - 1, self.coverImageView.height / 2 -1);
                self.fourthImageView.frame = CGRectMake(self.coverImageView.width / 2 + 1, self.coverImageView.height / 2 + 1, self.coverImageView.width / 2 - 1, self.coverImageView.height / 2 -1);
            }
            
            
        }
    }
}



+ (NSString *)getWithWhoStr:(LCTourpic *)tourpic {
    NSString *withWho = @"跟";
    NSInteger index = 0;
    for (LCPhoneContactorModel *contactor in tourpic.companyArr) {
        NSString *contactorName = contactor.name;
        if ([LCStringUtil isNullString:contactorName]) {
            continue ;
        }
        if (0 != index) {
            withWho = [NSString stringWithFormat:@"%@，%@", withWho, contactorName];
        } else {
            withWho = [NSString stringWithFormat:@"%@%@", withWho, contactorName];
        }
        index++;
    }
    withWho = [NSString stringWithFormat:@"%@在一起", withWho];
    if ([withWho isEqualToString:@"跟在一起"]) {
        withWho = @"";
    }
    return withWho;
}

+ (CGFloat)getCellHeight:(LCTourpic *)tourpic isShowBigGap:(BOOL)isShowBigGap {
    CGFloat cellHeight = 127.f;
//    NSString *desc = tourpic.desc;
//    NSString *withWho = [LCTourpicAlbumTimelineCell getWithWhoStr:tourpic];
//    
//    CGFloat descHeight = [LCStringUtil getDefaultHeightOfString:desc withFont:[UIFont fontWithName:APP_CHINESE_FONT size:13.0f] labelWidth:(DEVICE_WIDTH - 206.0f)];
//    CGFloat withWhoHeight = [LCStringUtil getDefaultHeightOfString:withWho withFont:[UIFont fontWithName:APP_CHINESE_FONT size:11.0f] labelWidth:(DEVICE_WIDTH - 206.0f)];
//    
//    CGFloat cellHeight = 11.0f + 13.0f + descHeight + withWhoHeight;
    
//    if (cellHeight < 120.0f) {
//        cellHeight = 110.0f;
//    }
//    if (isShowBigGap) {
//        cellHeight += 17.0f;
//    }
    //cellHeight = 10.0f + cellHeight;
    return cellHeight;
}

@end
