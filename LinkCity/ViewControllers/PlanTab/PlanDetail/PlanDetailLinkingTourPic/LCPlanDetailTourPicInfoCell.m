//
//  LCPlanDetailTourPicInfoCell.m
//  LinkCity
//
//  Created by lhr on 16/5/9.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCPlanDetailTourPicInfoCell.h"
#import "UIView+BlocksKit.h"
@interface LCPlanDetailTourPicInfoCell()
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel1;
@property (weak, nonatomic) IBOutlet UILabel *countLabel2;
@property (weak, nonatomic) IBOutlet UILabel *countLabel3;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIView *shadowMaskView;


@property (strong, nonatomic) UIImageView *iconView1;
@property (strong, nonatomic) UIImageView *iconView2;
@property (strong, nonatomic) UIImageView *iconView3;

@end


@implementation LCPlanDetailTourPicInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView1.layer.cornerRadius = 1.0f;
    self.imageView2.layer.cornerRadius = 1.0f;
    self.imageView3.layer.cornerRadius = 1.0f;
    self.countLabel1.layer.cornerRadius = 1.5f;
    self.countLabel2.layer.cornerRadius = 1.5f;
    self.countLabel3.layer.cornerRadius = 1.5f;
    _iconView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlanToupicVideoPlayIcon"]];
    _iconView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlanToupicVideoPlayIcon"]];
    _iconView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlanToupicVideoPlayIcon"]];
    [self.iconView1 sizeToFit];
    [self.iconView2 sizeToFit];
    [self.iconView3 sizeToFit];
    self.iconView1.center = CGPointMake(self.imageView1.width / 2, self.imageView1.height / 2);
    self.iconView2.center = self.iconView1.center;
    self.iconView3.center = self.iconView2.center;
    [self.imageView1 addSubview:self.iconView1];
    [self.imageView2 addSubview:self.iconView2];
    [self.imageView3 addSubview:self.iconView3];
//    self.iconView1.center = 
//    self.iconView2.center =
    //ToupicVideoPlayIcon
    // Initialization code
}

- (void)bindWithData:(NSArray *)tourPicList {
    //
    self.imageView1.hidden = YES;
    self.imageView2.hidden = YES;
    self.imageView3.hidden = YES;
    self.countLabel1.hidden = YES;
    self.countLabel2.hidden = YES;
    self.countLabel3.hidden = YES;
    self.shadowMaskView.hidden = YES;
    self.iconView1.hidden = YES;
    self.iconView2.hidden = YES;
    self.iconView3.hidden = YES;
    __weak typeof(self) weakSelf = self;
    if (tourPicList && tourPicList.count > 0) {

        if (tourPicList.count > 0) {
            
            LCTourpic *model = [[LCTourpic alloc] initWithDictionary:tourPicList[0]];
            if (model.type == LCTourpicType_Video) {
                self.iconView1.hidden = NO;
            }
            if (model.photoNum > 1) {
                self.countLabel1.text = [NSString stringWithFormat:@"%zd张",model.photoNum];
                self.countLabel1.hidden = NO;
            }
            [self.imageView1 setImageWithURL:[NSURL URLWithString:model.thumbPicUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
            self.imageView1.hidden = NO;
            [self.imageView1 bk_whenTapped:^{
                [weakSelf.delegate didPressImageViewWithTourPlan:model];
            }];

        }
        if (tourPicList.count > 1) {
            LCTourpic *model = [[LCTourpic alloc] initWithDictionary:tourPicList[1]];
            if (model.type == LCTourpicType_Video) {
                self.iconView2.hidden = NO;
            }
            if (model.photoNum > 1) {
                self.countLabel2.text = [NSString stringWithFormat:@"%zd张",model.photoNum];
                self.countLabel2.hidden = NO;
            }
            [self.imageView2 setImageWithURL:[NSURL URLWithString:model.thumbPicUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
            self.imageView2.hidden = NO;
            [self.imageView2 bk_whenTapped:^{
                [weakSelf.delegate didPressImageViewWithTourPlan:model];
            }];
        }
        if (tourPicList.count > 2) {
            LCTourpic *model = [[LCTourpic alloc] initWithDictionary:tourPicList[2]];
            if (model.type == LCTourpicType_Video) {
                self.iconView3.hidden = NO;
            }
            if (model.photoNum > 1) {
                self.countLabel3.text = [NSString stringWithFormat:@"%zd张",model.photoNum];
                self.countLabel3.hidden = NO;
            }
            [self.imageView3 setImageWithURL:[NSURL URLWithString:model.thumbPicUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
            self.imageView3.hidden = NO;
            if (tourPicList.count > 3) {
                self.shadowMaskView.hidden = NO;
                [self.shadowMaskView bk_whenTapped:^{
                    [weakSelf.delegate didPressImageViewForMoreTourpics];
                }];
            } else {
                [self.imageView3 bk_whenTapped:^{
                    [weakSelf.delegate didPressImageViewWithTourPlan:model];
                }];
            }
            
        }
       
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
