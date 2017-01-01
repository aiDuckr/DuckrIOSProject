//
//  LCRoutesBrowserCollectionCell.m
//  LinkCity
//
//  Created by roy on 11/16/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCRoutesBrowserCollectionCell.h"
#import "EGOImageView.h"

@interface LCRoutesBrowserCollectionCell()
@property (weak, nonatomic) IBOutlet EGOImageView *routeImage;
@property (weak, nonatomic) IBOutlet UILabel *routeTitle;
@property (weak, nonatomic) IBOutlet UITextView *routeDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeBrowserContentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeDescriptionBottomSpace;

@end




@implementation LCRoutesBrowserCollectionCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.routeDescription.contentInset = UIEdgeInsetsMake(-5, -5, -5, -5);
    self.routeDescription.textAlignment = NSTextAlignmentLeft;
    
    if (IS_IPHONE_4_4S) {
        self.routeBrowserContentTop.constant = 80;
        self.routeDescriptionBottomSpace.constant = 56;
    }
}

- (void)setRoute:(LCRouteInfo *)route{
    _route = route;
    
    self.routeTitle.text = route.placeName;
    self.routeDescription.text = route.descriptionStr;
    self.routeImage.imageURL = [NSURL URLWithString:route.image];
    
//    //添加富文本
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:25];
//    NSDictionary *attribs = @{
//                              NSForegroundColorAttributeName: UIColorFromR_G_B_A(196, 191, 187, 1),
//                              NSFontAttributeName: [UIFont fontWithName:FONT_LANTINGBLACK size:14],
//                              NSParagraphStyleAttributeName: paragraphStyle
//                            };
//    
//    
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:route.descriptionStr];
//    [attributedText setAttributes:attribs range:[attributedText.string rangeOfString:route.descriptionStr]];
//    self.routeDescription.attributedText = attributedText;
    [self setTextForDescript:route.descriptionStr];
}

- (void)setTextForDescript:(NSString *)str{
    //添加富文本
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: UIColorFromR_G_B_A(196, 191, 187, 1),
                              NSFontAttributeName: [UIFont fontWithName:FONT_LANTINGBLACK size:14],
                              NSParagraphStyleAttributeName: paragraphStyle
                              };
    
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedText setAttributes:attribs range:[attributedText.string rangeOfString:str]];
    self.routeDescription.attributedText = attributedText;

    [self setNeedsDisplay];
    [self setNeedsLayout];
}


@end
