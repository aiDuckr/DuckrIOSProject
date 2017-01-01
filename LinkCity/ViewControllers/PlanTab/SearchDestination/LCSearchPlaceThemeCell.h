//
//  LCSearchPlaceThemeCell.h
//  LinkCity
//
//  Created by 张宗硕 on 8/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCSearchPlaceThemeCell;

@protocol LCSearchPlaceThemeCellDelegate <NSObject>
- (void)searchPlaceThemeDidSelected:(LCSearchPlaceThemeCell *)cell withText:(NSString *)text;

@end

@interface LCSearchPlaceThemeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (strong, nonatomic) NSArray *themeCategoryArr;
@property (strong, nonatomic) id<LCSearchPlaceThemeCellDelegate> delegate;

- (void)updateSearchPlaceThemeCell:(NSArray *)themeCategoryArr;

@end
