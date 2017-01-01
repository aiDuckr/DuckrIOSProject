//
//  UILabel+LineSpace.m
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "UILabel+LineSpace.h"

@implementation UILabel (LineSpace)

- (void)setText:(NSString *)text withLineSpace:(float)lineSpace{
    if (!text) {
        self.text = @" ";
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        self.attributedText = attributedString;
        [self sizeToFit];
    }
}
- (void)setText:(NSString *)text withLineSpace:(float)lineSpace textAlignment:(NSTextAlignment)alignment{
    if (!text) {
        self.text = @" ";
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];//调整行间距
        [paragraphStyle setAlignment:alignment];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        self.attributedText = attributedString;
    }
}

//- (void)sizeToFit{
//    //内容为空时，高度设为0
//    //否则，设为相应高度
//    if ([LCStringUtil isNullString:[self.attributedText string]]) {
//        self.bounds = CGRectMake(0, 0, 0, 0);
//    }else{
//        [super sizeToFit];
//    }
//}

@end
