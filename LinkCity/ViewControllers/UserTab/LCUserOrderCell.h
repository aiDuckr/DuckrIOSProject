//
//  LCUserOrderCell.h
//  LinkCity
//
//  Created by godhangyu on 16/5/30.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCUserOrderCellViewType_PendingPayment,   //待付款
    LCUserOrderCellViewType_ToBeEvaluated,    //待评价
    LCUserOrderCellViewType_Refund,           //退款中
    LCUserOrderCellViewType_ToBeTravelling,   //待出行
    
} LCUserOrderCellType;

@class LCUserOrderCell;

@protocol LCUserOrderCellDelegate <NSObject>

- (void)orderRefundButtonClicked:(LCUserOrderCell *)cell;
- (void)orderEvaluatedButtonClicked:(LCUserOrderCell *)cell;
- (void)orderDeleteButtonClicked:(LCUserOrderCell *)cell;

@end

@interface LCUserOrderCell : UITableViewCell

@property (nonatomic, assign) LCUserOrderCellType cellType;

@property (weak, nonatomic) IBOutlet UIView *topViewContainer;
@property (weak, nonatomic) IBOutlet UIView *secondViewContainer;
@property (weak, nonatomic) IBOutlet UIView *thirdViewContainer;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *bottomViewContainer;

@property (weak, nonatomic) IBOutlet UIImageView *merchantImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantLabel;
@property (weak, nonatomic) IBOutlet UILabel *planStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *planImageView;
@property (weak, nonatomic) IBOutlet UILabel *planTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *planDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *planDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *planPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderRefundButton;
@property (weak, nonatomic) IBOutlet UIButton *orderEvaluateButton;
@property (weak, nonatomic) IBOutlet UIButton *orderDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *orderRefundSucceedButton;
@property (weak, nonatomic) IBOutlet UIButton *orderRefundingButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separateLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pendingPaymentTopSeparateLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pendingPaymentBottomSeparateLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparateLineHeight;


@property (strong, nonatomic) LCPlanModel *plan;
@property (strong, nonatomic) LCPartnerOrderModel *order;
@property (strong, nonatomic) id<LCUserOrderCellDelegate> delegate;

- (void)updateCell:(LCPlanModel *)plan partnerOrderModel:(LCPartnerOrderModel *)order withSpaInset:(BOOL)separateLine;

@end
