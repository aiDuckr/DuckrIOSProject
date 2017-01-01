//
//  LCSendFreePlanImageBottomCell.h
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSendFreePlanImageBottomCellDelegate;
@interface LCSendFreePlanImageBottomCell : UITableViewCell
@property (nonatomic, weak) id<LCSendFreePlanImageBottomCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *submibBtn;

@end


@protocol LCSendFreePlanImageBottomCellDelegate <NSObject>
@optional
- (void)sendFreePlanImageBottomCellDidClickSubmitBtn:(LCSendFreePlanImageBottomCell *)bottomCell;
@end