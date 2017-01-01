//
//  LCMultiTourPicCell_5.m
//  LinkCity
//
//  Created by godhangyu on 16/6/8.
//  Copyright © 2016年 linkcity. All rights reserved.
//


#import "LCMultiTourPicCell_5.h"

@implementation LCMultiTourPicCell_5

- (void)awakeFromNib {
    // Initialization code
    
    self.imageButtonOne.layer.masksToBounds = YES;
    self.imageButtonOne.layer.cornerRadius = 4;
    self.imageButtonTwo.layer.masksToBounds = YES;
    self.imageButtonTwo.layer.cornerRadius = 4;
    self.imageButtonThree.layer.masksToBounds = YES;
    self.imageButtonThree.layer.cornerRadius = 4;
    
    
    self.imageViewOne.layer.masksToBounds = YES;
    self.imageViewOne.layer.cornerRadius = 4;
    self.imageViewTwo.layer.masksToBounds = YES;
    self.imageViewTwo.layer.cornerRadius = 4;
    self.imageViewThree.layer.masksToBounds = YES;
    self.imageViewThree.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setTourPicArray:(NSArray *)tourPicArray{
    _tourPicArray = tourPicArray;
    
    [self setButtonShownAsClear:self.imageButtonOne];
    [self setButtonShownAsClear:self.imageButtonTwo];
    [self setButtonShownAsClear:self.imageButtonThree];
    
    if (tourPicArray.count>0) {
        NSString *url = [tourPicArray[0] thumbPicUrl];
        [self.imageViewOne setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        [self.imageViewOne setImage:nil];
    }
    
    if (tourPicArray.count>1) {
        NSString *url = [tourPicArray[1] thumbPicUrl];
        [self.imageViewTwo setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        [self.imageViewTwo setImage:nil];
    }
    
    if (tourPicArray.count>2) {
        NSString *url = [tourPicArray[2] thumbPicUrl];
        [self.imageViewThree setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        
        [self setButtonShownAsMore:self.imageButtonThree];
    }else{
        [self.imageViewThree setImage:nil];
        [self setButtonShownAsClear:self.imageButtonThree];
    }
}

- (void)setButtonShownAsClear:(UIButton *)btn{
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorFromRGBA(0x000000, 0)];
}
- (void)setButtonShownAsMore:(UIButton *)btn{
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorFromRGBA(0x000000, 0.5)];
}

- (IBAction)imageButtonOneAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(multiTourPicCell:didClickButtonIndex:)]) {
        [self.delegate multiTourPicCell:self didClickButtonIndex:0];
    }
}
- (IBAction)imageButtonTwoAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(multiTourPicCell:didClickButtonIndex:)]) {
        [self.delegate multiTourPicCell:self didClickButtonIndex:1];
    }
}
- (IBAction)imageButtonThreeButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(multiTourPicCell:didClickButtonIndex:)]) {
        [self.delegate multiTourPicCell:self didClickButtonIndex:2];
    }
}



+ (CGFloat)getCellHeight{
    return 11 + (DEVICE_WIDTH - 28)/3.0/230*188 + 13;
}

@end

