//
//  LCSearchDestinationRecmdCell.h
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LCSearchDestinationRecmdCellDelegate;
@interface LCSearchDestinationRecmdCell : UITableViewCell

//UI
@property (weak, nonatomic) IBOutlet UIView *borderBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBgViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBgViewTop;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftSubTitle;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitle;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

//Data
@property (nonatomic, weak) id<LCSearchDestinationRecmdCellDelegate> delegate;
@property (nonatomic, strong) LCHomeCategoryModel *leftPlace;
@property (nonatomic, strong) LCHomeCategoryModel *rightPlace;


+ (CGFloat)getCellHeight;
- (void)updateShowWithLeftPlace:(LCHomeCategoryModel *)left rightPlace:(LCHomeCategoryModel *)right isFirstCell:(BOOL)isFirst isLastCell:(BOOL)isLast;
@end



@protocol LCSearchDestinationRecmdCellDelegate <NSObject>

- (void)searchDestinationRecmdCell:(LCSearchDestinationRecmdCell *)cell didSelectPlace:(LCHomeCategoryModel *)place;

@end
