//
//  LCUserInfoEvaluationCell.m
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserEvaluationCell.h"

@interface LCUserEvaluationCell ()

@property (strong, nonatomic) NSArray *starImageArray;
@property (strong, nonatomic) NSArray *tagLabelArray;

@property (weak, nonatomic) IBOutlet UIImageView *starOne;
@property (weak, nonatomic) IBOutlet UIImageView *starTwo;
@property (weak, nonatomic) IBOutlet UIImageView *starThree;
@property (weak, nonatomic) IBOutlet UIImageView *starFour;
@property (weak, nonatomic) IBOutlet UIImageView *starFive;

@end

@implementation LCUserEvaluationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starImageArray = @[self.starOne,self.starTwo,self.starThree,self.starFour,self.starFive];
    self.tagLabelArray = @[self.tagOneLabel,self.tagTwoLabel,self.tagThreeLabel,self.tagFourLabel];

    [self.tagLabelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LCLabel *label = (LCLabel *)obj;
        label.edgeInset = UIEdgeInsetsMake(2, 4, 2, 4);
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = UIColorFromR_G_B_A(232, 228, 221, 1).CGColor;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserEvaluation:(LCUserEvaluationModel *)userEvaluation{
    _userEvaluation = userEvaluation;
    
    [self updateShow];
}

- (void)updateShow{
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.userEvaluation.avatarUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    
    NSString *title = self.userEvaluation.nick;
    
    if ([LCStringUtil isNotNullString:self.userEvaluation.updatedTime]) {
        NSString *dateString = [[self.userEvaluation.updatedTime componentsSeparatedByString:@" "] firstObject];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        title = [title stringByAppendingFormat:@"-%@",dateString];
        self.titleLabel.text = title;
    }
    
    NSInteger score = (NSInteger)self.userEvaluation.score;
    [self.starImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *img = (UIImageView *)obj;
        if (score > idx) {
            img.hidden = NO;
        }else{
            img.hidden = YES;
        }
    }];
    
    [self.contentLabel setText:self.userEvaluation.content withLineSpace:8];
    /*
     Roy 2015.9.4
     在IOS8+上，只要设置contentLabel三面的约束，就显示正常了
     在IOS7，导致Label特别高，文字居中后显示错位，因此手动计算Label应该的高度后调整
     */
    self.contentLabelHeight.constant = [LCStringUtil getHeightOfString:self.userEvaluation.content
                                     withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                    lineSpace:8
                                   labelWidth:(DEVICE_WIDTH-47-15)];
    
    [self.tagLabelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = (UILabel *)obj;
        
        if (self.userEvaluation.tags.count > idx) {
            label.hidden = NO;
            label.text = (NSString *)[self.userEvaluation.tags objectAtIndex:idx];
        }else{
            label.hidden = YES;
        }
    }];
}

+ (CGFloat)getCellHeightForEvaluation:(LCUserEvaluationModel *)userEvaluation{
    
    CGFloat height = 0;
    height += 40;
    if ([LCStringUtil isNotNullString:userEvaluation.content]) {
        height += [LCStringUtil getHeightOfString:userEvaluation.content
                                         withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                        lineSpace:8
                                       labelWidth:(DEVICE_WIDTH-47-15)];
        height += 10;
    }
    
    if (userEvaluation.tags && userEvaluation.tags.count>0) {
        height += 23;
    }
    height += 11;
    
    return height;
}
@end
