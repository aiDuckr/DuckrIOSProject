//
//  LCPlanDetailAThemeCell.h
//  LinkCity
//
//  Created by roy on 2/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanDetailAThemeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

+ (CGFloat)heightOfAThemeCell;
+ (CGSize)sizeOfAThemeCell:(LCRouteThemeModel *)theme;
@end
