//
//  LCTextThreePhotosCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCopyableLabel.h"

@interface LCTextThreePhotosCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageButtonWidthConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageButtonWidthConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdImageButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet LCCopyableLabel *textDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageButton;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (retain, nonatomic) LCPlanModel *plan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *locationCityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *toupicLocationIcon;

@property (strong, nonatomic) NSArray *tagItemArray;
@property (strong, nonatomic) NSMutableArray *tagViewArray;

- (void)updateShowTextThreePhotos:(LCPlanModel *)plan;
@end
