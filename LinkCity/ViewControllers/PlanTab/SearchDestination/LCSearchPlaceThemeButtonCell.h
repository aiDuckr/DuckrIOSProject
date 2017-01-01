//
//  LCSearchPlaceThemeButtonCell.h
//  LinkCity
//
//  Created by 张宗硕 on 8/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCSearchPlaceThemeButtonCell;

@protocol LCSearchPlaceThemeButtonCellDelegate <NSObject>
- (void)searchPlaceThemeButtonDidClick:(NSString *)text;

@end

@interface LCSearchPlaceThemeButtonCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *labelButton;
@property (strong, nonatomic) id<LCSearchPlaceThemeButtonCellDelegate> delegate;

- (void)updateShowSearchPlaceThemeButtonCell:(NSString *)title;
@end
