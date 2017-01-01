//
//  LCHomeDuckrBoardUserCell.h
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeDuckrBoardUserCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveGoLabel;
@property (strong, nonatomic) LCUserModel *user;

- (void)updateShowCell:(LCUserModel *)user;
@end
