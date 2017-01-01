//
//  LCTwoPicView.h
//  LinkCity
//
//  Created by 张宗硕 on 4/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTourpicBaseView.h"

@interface LCTwoPicView : LCTourpicBaseView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end
