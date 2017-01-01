//
//  LCChatRoomMemberCell.h
//  LinkCity
//
//  Created by roy on 3/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@interface LCChatGroupMemberUserCell : UICollectionViewCell
@property (nonatomic, strong) LCUserModel *user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

+ (CGFloat)getCellHeight;
@end
