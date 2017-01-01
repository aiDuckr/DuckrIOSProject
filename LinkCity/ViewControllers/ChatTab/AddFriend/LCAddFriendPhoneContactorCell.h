//
//  LCAddAddressBookUserCell.h
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCAddFriendPhoneContactorCellType_Favor,
    LCAddFriendPhoneContactorCellType_Favored,
    LCAddFriendPhoneContactorCellType_Invite,
    LCAddFriendPhoneContactorCellType_Invited,
} LCAddFriendPhoneContactorCellType;


@protocol LCAddFriendPhoneContactorCellDelegate;
@interface LCAddFriendPhoneContactorCell : UITableViewCell
@property (nonatomic, weak) id<LCAddFriendPhoneContactorCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;

@property (nonatomic, assign) LCAddFriendPhoneContactorCellType showType;

+ (CGFloat)getCellHeight;
@end


@protocol LCAddFriendPhoneContactorCellDelegate <NSObject>

- (void)addFriendPhoneContactorCellDidClickButton:(LCAddFriendPhoneContactorCell *)cell;

@end