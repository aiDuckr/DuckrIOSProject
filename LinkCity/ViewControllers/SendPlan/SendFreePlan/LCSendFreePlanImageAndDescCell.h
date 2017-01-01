//
//  LCSendFreePlanImageTopCell.h
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@protocol LCSendFreePlanImageAndDescCellDelegate;
@interface LCSendFreePlanImageAndDescCell : UITableViewCell
@property (nonatomic, weak) id<LCSendFreePlanImageAndDescCellDelegate> delegate;
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, assign) NSInteger uploadingImageNum;


//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnA;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnB;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnC;
//@property (weak, nonatomic) IBOutlet SZTextView *descTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;

+ (instancetype)createInstance;
- (void)updateShowWithPlan:(LCPlanModel *)plan;

@end

@protocol LCSendFreePlanImageAndDescCellDelegate <NSObject>
@optional
- (void)sendFreePlanImageAndDescCellDidUpdateImage:(LCSendFreePlanImageAndDescCell *)topCell;
- (void)sendFreePlanImageAndDescCellDidEndInputDescription:(LCSendFreePlanImageAndDescCell *)topCell;
- (void)sendFreePlanImageAndDescCellDidEndUploadImage:(LCSendFreePlanImageAndDescCell *)topCell;

@end
