//
//  LCNinePicView.h
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTourpicBaseView.h"

@interface LCNinePicView : LCTourpicBaseView
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fiveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sixImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sevenImageView;
@property (weak, nonatomic) IBOutlet UIImageView *eightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nineImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;


@end
