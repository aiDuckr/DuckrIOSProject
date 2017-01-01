//
//  LCPlanDetailADestCell.h
//  LinkCity
//
//  Created by Roy on 9/2/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanDetailADestCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *destLabel;
@property (weak, nonatomic) IBOutlet UIImageView *destArrowIcon;
@property (weak, nonatomic) IBOutlet UIView *dashView;


- (void)updateShowWithDes:(NSString *)dest isArrow:(BOOL)isArrow isDash:(BOOL)isDash;

+ (CGFloat)heightOfADestCell;
+ (CGSize)sizeOfADestCell:(NSString *)dest isArrow:(BOOL)isArrow isDash:(BOOL)isDash;
@end
