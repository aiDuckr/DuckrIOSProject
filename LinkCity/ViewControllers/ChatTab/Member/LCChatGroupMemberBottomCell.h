//
//  LCChatGroupMemberBottomCell.h
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCChatGroupModel.h"

@protocol LCChatGroupMemeberBottomCellDelegate;
@interface LCChatGroupMemberBottomCell : UICollectionViewCell
@property (nonatomic, strong) LCChatGroupModel *chatGroup;
@property (nonatomic, weak) id<LCChatGroupMemeberBottomCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *banDisturbSwitch;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

+ (CGFloat)getCellheightForChatGroup:(LCChatGroupModel *)chatGroup;
@end


@protocol LCChatGroupMemeberBottomCellDelegate <NSObject>

//- (void)chatGroupMemberBottomCellDidClickSubmit:(LCChatGroupMemberBottomCell *)bottomCell;
//- (void)chatGroupMemberBottomCellDidClickSwitch:(LCChatGroupMemberBottomCell *)bottomCell;
- (void)chatGroupMemberBottomCellDidUpdateData:(LCChatGroupMemberBottomCell *)bottomCell;
- (void)chatGroupMemberBottomCellDidJoinChatGroup:(LCChatGroupMemberBottomCell *)bottomCell newChatGroup:(LCChatGroupModel *)newChatGroup;
- (void)chatGroupMemberBottomCellDidQuitChatGroup:(LCChatGroupMemberBottomCell *)bottomCell;

@end