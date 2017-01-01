//
//  AddPlacesCell.h
//  LinkCity
//
//  Created by 张宗硕 on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface LCAddPlacesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EGOImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeIntroLabel;

@end
