//
//  LCTourpicLikedCell.h
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourpic.h"

@interface LCTourpicLikedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *likedLabel;
@property (weak, nonatomic) IBOutlet UIView *likedView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (retain, nonatomic) LCTourpic *tourpic;

- (void)updateLikedCell:(LCTourpic *)tourpic;
@end
