//
//  UITextView+LineSpace.m
//  LinkCity
//
//  Created by roy on 11/26/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "UITextView+LineSpace.h"

@implementation UITextView (LineSpace)
- (void)setText:(NSString *)text withLineSpace:(float)lineSpace withFont:(UIFont *)font color:(UIColor *)color{
    if (!text) {
        self.text = @" ";
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
        self.attributedText = attributedString;
        [self sizeToFit];
    }
}

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
@end
