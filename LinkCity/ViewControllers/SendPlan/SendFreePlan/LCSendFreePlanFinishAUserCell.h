//
//  LCSendFreePlanFinishAUserCell.h
//  LinkCity
//
//  Created by Roy on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSendFreePlanFinishAUserCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

- (void)updateShowWithUser:(LCUserModel *)user selected:(BOOL)selected;
@end
