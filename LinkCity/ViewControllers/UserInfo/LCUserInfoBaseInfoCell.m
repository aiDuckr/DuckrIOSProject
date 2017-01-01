//
//  LCUserInfoBaseInfoCell.m
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserInfoBaseInfoCell.h"

#define PlaceHolder @"未填写"
static const NSInteger lineSpace = 7;
@implementation LCUserInfoBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithUser:(LCUserModel *)user showBottomGap:(BOOL)bottomGap{
    self.user = user;
    
    //Roy 如果不手动调用sizeToFit，在编辑个人信息后回到该页面，文字换内容，导致显示错乱
    //Roy 如果调用sizeToFit，会导致其super view高度变高
    //Roy 只得自己fit size
    self.livingPlaceLabel.text = [LCStringUtil getNotNullStrToShow:self.user.livingPlace placeHolder:PlaceHolder];
    [self.slogonLabel setText:[LCStringUtil getNotNullStrToShow:self.user.signature placeHolder:PlaceHolder] withLineSpace:lineSpace];
    [self fitSizeOfLabel:self.slogonLabel];
    NSString *wantToStr = [LCUserInfoBaseInfoCell getWantToStrFromUser:self.user];
    [self.wantToBeLabel setText:[LCStringUtil getNotNullStrToShow:wantToStr placeHolder:PlaceHolder] withLineSpace:lineSpace];
    [self fitSizeOfLabel:self.wantToBeLabel];
    NSString *haveBeenStr = [LCUserInfoBaseInfoCell getHaveBeenStrFromUser:self.user];
    [self.haveBeenLabel setText:[LCStringUtil getNotNullStrToShow:haveBeenStr placeHolder:PlaceHolder] withLineSpace:lineSpace];
    [self fitSizeOfLabel:self.haveBeenLabel];
    
    self.professionLabel.text = [LCStringUtil getNotNullStrToShow:self.user.professional placeHolder:PlaceHolder];
    if ([LCStringUtil isNotNullString:self.user.professional] &&
        ![self.user.professional isEqualToString:@"无"]) {
        self.professionLabelLeading.constant = 99;
        self.professionImageView.hidden = NO;
        NSString *professionImageName = [[LCDataManager sharedInstance].professionDic objectForKey:self.user.professional];
        self.professionImageView.image = [UIImage imageNamed:professionImageName];
    }else{
        self.professionLabelLeading.constant = 78;
        self.professionImageView.hidden = YES;
    }
    
    self.schoolLabel.text = [LCStringUtil getNotNullStrToShow:self.user.school placeHolder:PlaceHolder];
    
    self.bottomLine.hidden = !bottomGap;
}

+ (NSString *)getWantToStrFromUser:(LCUserModel *)user{
    __block NSString *wantToStr = @"";
    [user.wantGoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx!=0) {
            wantToStr = [wantToStr stringByAppendingString:@", "];
        }
        
        wantToStr = [wantToStr stringByAppendingString:(NSString *)obj];
    }];
    if (wantToStr.length<1) {
        wantToStr = @"";
    }
    return wantToStr;
}
+ (NSString *)getHaveBeenStrFromUser:(LCUserModel *)user{
    __block NSString *haveBeenStr = @"";
    [user.haveGoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx!=0) {
            haveBeenStr = [haveBeenStr stringByAppendingString:@", "];
        }
        
        haveBeenStr = [haveBeenStr stringByAppendingString:(NSString *)obj];
    }];
    if (haveBeenStr.length<1) {
        haveBeenStr = @"";
    }
    return haveBeenStr;
}



+ (CGFloat)getCellHeightForUser:(LCUserModel *)user showBottomGap:(BOOL)bottomGap{
    static LCUserInfoBaseInfoCell *staticCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCUserInfoBaseInfoCell class]) bundle:nil];
        NSArray *views = [nib instantiateWithOwner:nil options:nil];
        for (UIView *v in views){
            if ([v isKindOfClass:[LCUserInfoBaseInfoCell class]]) {
                staticCell = (LCUserInfoBaseInfoCell *)v;
                break;
            }
        }
    });
    
    CGFloat textWidth = DEVICE_WIDTH - 78 - 15;
    CGFloat height = 0;
    height += 50;
    CGFloat signatureHeight = [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStrToShow:user.signature placeHolder:PlaceHolder] withFont:staticCell.slogonLabel.font lineSpace:lineSpace labelWidth:textWidth];
//    signatureHeight = MAX(signatureHeight, 17);
    height += signatureHeight + 36;
    height += 10;
    
    NSString *wantToStr = [LCUserInfoBaseInfoCell getWantToStrFromUser:user];
    CGFloat wantToGoHeight = [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStrToShow:wantToStr placeHolder:PlaceHolder] withFont:staticCell.slogonLabel.font lineSpace:lineSpace labelWidth:textWidth];
//    wantToGoHeight = MAX(wantToGoHeight, 17);
    height += wantToGoHeight + 36;
    
    NSString *haveBeenStr = [LCUserInfoBaseInfoCell getHaveBeenStrFromUser:user];
    CGFloat haveBeenHeight = [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStrToShow:haveBeenStr placeHolder:PlaceHolder] withFont:staticCell.slogonLabel.font lineSpace:lineSpace labelWidth:textWidth];
//    haveBeenHeight = MAX(haveBeenHeight, 17);
    height += haveBeenHeight + 36;
    
    height += 10;
    
    height += 50;
    height += 50;
    
    if (bottomGap) {
        height += 11;
    }else{
        
    }
    
    LCLogInfo(@"BaseInfoCell getCellHeightForUser height:%f",height);
    return height;
}

- (void)fitSizeOfLabel:(UILabel *)label{
    CGRect frame = label.frame;
    CGSize rightSize = [label sizeThatFits:CGSizeMake(DEVICE_WIDTH - 78 - 15, 0)];
    frame.size = rightSize;
    label.frame = frame;
}

@end
