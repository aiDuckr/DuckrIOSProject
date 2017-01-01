//
//  LCSendFreePlanFinishUsersCell.h
//  LinkCity
//
//  Created by Roy on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UserCellGap 20
#define UserCellMarginLeft 10
@protocol LCSendFreePlanFinishUsersCellDelegate;
@interface LCSendFreePlanFinishUsersCell : UITableViewCell

@property (nonatomic, weak) id<LCSendFreePlanFinishUsersCellDelegate> delegate;
@property (nonatomic, strong) NSArray *userArray;
@property (nonatomic, strong) NSMutableArray *selectionArray;

//+ (CGFloat)getCellHeight;
@end


@protocol LCSendFreePlanFinishUsersCellDelegate <NSObject>

- (void)sendFreePlanFinishUsersCellDidClickInvite:(LCSendFreePlanFinishUsersCell *)cell;

@end