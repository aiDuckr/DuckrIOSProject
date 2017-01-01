//
//  LCYellowSectionHeaderCell.h
//  LinkCity
//
//  Created by roy on 6/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>



#define YellowHeaderCellHeight 55
@protocol LCYellowSectionHeaderDelegate;
@interface LCYellowSectionHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yellowLineTop;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *seeAllView;

@property (nonatomic, weak) id<LCYellowSectionHeaderDelegate> delegate;

+ (CGFloat)getCellHeight;
@end


@protocol LCYellowSectionHeaderDelegate <NSObject>

- (void)yellowSectionHeaderDidClick:(LCYellowSectionHeaderCell *)header;

@end