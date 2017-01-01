//
//  LCOnlineLocalCoverCell.h
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCOnlineLocalCoverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftCoverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightCoverImageView;

- (void)updateShowCell:(LCHomeCategoryModel *)leftCategory withRightCategory:(LCHomeCategoryModel *)rightCategory;
@end
