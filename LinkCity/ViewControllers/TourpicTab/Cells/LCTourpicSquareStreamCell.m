//
//  LCTourpicSquareStreamCell.m
//  LinkCity
//
//  Created by lhr on 16/4/3.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCTourpicSquareStreamCell.h"
#import "LCImageUtil.h"

@interface LCTourpicSquareStreamCell()
@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tourPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *TourpicVideoIcon;
@property (nonatomic,strong) UILabel *
thumbNumlabel;
@property (nonatomic,strong) UIImageView
*thumbIconView;

@property (nonatomic, strong) NSURL *urlString;
@end
@implementation LCTourpicSquareStreamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
    //_thumbIconView = [[UIImageView alloc] initWithImage:@""];
    // Initialization code
}
- (void)setUpUI {
    _thumbIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _thumbNumlabel = [[UILabel alloc] init];
    [self.thumbUpButton addSubview:self.thumbNumlabel];
    [self.thumbUpButton addSubview:self.thumbIconView];
    [self.thumbUpButton addTarget:self action:@selector(thumbUp) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)bindWithData:(LCTourpic *)model {
    self.model = model;
    if (model.type == LCTourpicType_Photo) {
        self.TourpicVideoIcon.hidden = NO;
    } else {
        self.TourpicVideoIcon.hidden = YES;
        
    }
    self.urlString = [NSURL URLWithString:[model.thumbPhotoUrls objectAtIndex:0]];
    //[self.imageView setImage:];
    [self.imageView setImageWithURL:self.urlString placeholderImage:[UIImage imageNamed:@"DefaultTourpic"]];
    
    if (model.isLike == LCTourpicLike_IsLike) {
        self.thumbIconView.image = [UIImage imageNamed:@"TourpicThumbedIcon"];
    } else {
        self.thumbIconView.image = [UIImage imageNamed:@"TourpicunThumbIcon"];
        
    }
    if (model.photoNum == 0) {
        self.photoCountLabel.hidden = YES;
    } else {
        self.photoCountLabel.hidden = NO;
    }
    
    self.photoCountLabel.text = [NSString stringWithFormat:@"%ld张",(long)model.photoNum];
    self.thumbNumlabel.text = [NSString stringWithFormat:@"%ld",(long)model.likeNum];
    self.locationLabel.text = model.placeName;
    [self.thumbNumlabel sizeToFit];
    self.thumbNumlabel.frame = CGRectMake(self.thumbUpButton.frame.size.width -self.thumbNumlabel.frame.size.width, self.thumbUpButton.frame.size.height - self.thumbNumlabel.frame.size.height, self.thumbNumlabel.frame.size.width, self.thumbNumlabel.frame.size.height);
    self.thumbIconView.frame = CGRectMake(self.thumbNumlabel.frame.origin.x - 16 - 7 , self.thumbNumlabel.frame.origin.y, 16, 16);
    
    
    
//    } else if (model.isLike == LCTourpicLike_IsUnlike) {
//        
//    }
}


- (void)thumbUp {
    if (self.model.isLike) {
        //已经点过，不做操作
    } else {
        [self.delegate didThumbUpWithCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
