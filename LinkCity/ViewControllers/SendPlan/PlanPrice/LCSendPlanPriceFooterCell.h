//
//  LCSendPlanPriceFooterCell.h
//  LinkCity
//
//  Created by Roy on 8/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSendPlanPriceFooterCellDelegate;
@interface LCSendPlanPriceFooterCell : UITableViewCell
//UI

@property (weak, nonatomic) IBOutlet UIButton *addStageButton;

@property (weak, nonatomic) IBOutlet UIButton *earnestRadioBtnA;
@property (weak, nonatomic) IBOutlet UIButton *earnestRadioBtnB;
@property (weak, nonatomic) IBOutlet UIButton *earnestRadioBtnC;


@property (weak, nonatomic) IBOutlet UIView *priceIncludeBg;
@property (weak, nonatomic) IBOutlet SZTextView *priceIncludeTextView;
@property (weak, nonatomic) IBOutlet UIView *priceExcludeBg;
@property (weak, nonatomic) IBOutlet SZTextView *priceExcludeTextView;

@property (weak, nonatomic) IBOutlet UILabel *refundIntroLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, assign) NSInteger earnestRadioIndex;


//Data
@property (nonatomic, weak) id<LCSendPlanPriceFooterCellDelegate> delegate;
@property (nonatomic, strong) LCPlanModel *editingPlan;


+ (CGFloat)getCellHeight;
- (void)mergeUIDataIntoModel;
@end



@protocol LCSendPlanPriceFooterCellDelegate <NSObject>

- (void)sendPlanPriceFooterCell:(LCSendPlanPriceFooterCell *)footerCell requestToShowView:(UIView *)v;
- (void)sendPlanPriceFooterCellDidClickAddStageButton:(LCSendPlanPriceFooterCell *)footerCell;
- (void)sendPlanPriceFooterCellDidClickEarnestIntroButton:(LCSendPlanPriceFooterCell *)footerCell;
- (void)sendPlanPriceFooterCellDidClickSubmitButton:(LCSendPlanPriceFooterCell *)footerCell;

@end
