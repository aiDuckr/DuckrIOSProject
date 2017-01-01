//
//  LCThreePicView.h
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTourpicBaseView.h"

@interface LCThreePicView : LCTourpicBaseView

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightDownImageView;

@end
