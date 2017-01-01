//
//  LCFooterCell.m
//  LinkCity
//
//  Created by David Chen on 2016/8/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCFooterCell.h"
#import "LCSearchDestinationMoreVC.h"
#import "LCSearchDestinationMoreVC1.h"
@interface LCFooterCell ()
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *buttonText;
@end

@implementation LCFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1;
        button.frame = CGRectMake(0, 0, DEVICE_WIDTH, 45.0f);
        button.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:UIColorFromRGBA(0x7d7975, 1.0f) forState:UIControlStateNormal];
        UIImage *imageArrow = [UIImage imageNamed:@"tiaozhuan_1"];
        [button setImage:imageArrow forState:UIControlStateNormal];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageArrow.size.width, 0, imageArrow.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 179, 0, -button.titleLabel.bounds.size.width)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.contentView addSubview:button];
        
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(12, 44, DEVICE_WIDTH - 24, 1);
        line.backgroundColor = UIColorFromRGBA(0xe8e4dd, 1.0f).CGColor;
        [self.contentView.layer addSublayer:line];
    }
    return self;
}

-(void)setButtonTitleWithText:(NSString *)text searchText:(NSString *)str {
    UIButton *button = [self.contentView viewWithTag:1];
    self.searchText = str;
    self.buttonText = text;
    [button setTitle:NSLocalizedString(text, nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpToMore) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGSize)intrinsicContentSize {
    return CGSizeMake(DEVICE_WIDTH, 45);
}

- (void)jumpToMore{
    LCSearchDestinationMoreVC *vc = [LCSearchDestinationMoreVC createInstance];
//    LCSearchDestinationMoreVC1 *vc = [LCSearchDestinationMoreVC1 createInstance];
    if ([self.buttonText isEqualToString:@"查看更多活动"]) {
        vc.isCost = YES;
    } else if ([self.buttonText isEqualToString:@"查看更多邀约"]){
        vc.isCost = NO;
    }
    vc.searchText = self.searchText;
    [self.delegate pushVC:vc];
}


@end
