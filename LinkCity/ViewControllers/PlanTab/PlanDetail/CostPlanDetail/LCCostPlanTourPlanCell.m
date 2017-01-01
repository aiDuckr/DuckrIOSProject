//
//  LCCostPlanTourPlanCell.m
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanTourPlanCell.h"
#import "LCRoutePlaceModel.h"
@interface LCCostPlanTourPlanCell()
@property (weak, nonatomic) IBOutlet UIButton *seeDetailButton;
@property (weak, nonatomic) IBOutlet UIImageView *datailIcon;
@property (weak, nonatomic) IBOutlet UILabel *routeInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) LCPlanModel *planModel;

@end

@implementation LCCostPlanTourPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.seeDetailButton addTarget:self action:@selector(seeDetailAction) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)bindWithData:(LCPlanModel *)model {
    NSMutableString * textString = [[NSMutableString alloc] init];
    self.planModel = model;
    if (![model.userRoute routePlaces] || [model.userRoute routePlaces].count == 0 ) {
        [textString appendString:@"暂无行程安排"];
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.hidden = NO;
        NSInteger routeDay = 0;
        for (int i = 0 ;i < self.planModel.userRoute.routePlaces.count; i++) {
            LCRoutePlaceModel *placeModel = model.userRoute.routePlaces[i];
            if (placeModel.routeDay != routeDay) {
                [textString appendString:[NSString stringWithFormat:@"Day %zd:",(routeDay+1)]];
                [textString appendString:placeModel.dayPlaces];
                [textString appendString:@"\n"];
                routeDay = placeModel.routeDay;
            }
            if (routeDay == 3) {
                break;
            }
       
            //LCRoutePlaceModel *placeModel = model.userRoute.routePlaces[i];// (LCRoutePlaceModel *) model.routePlaces[i];
            

            
                           //placeModel
//            [textString appendString:[NSString stringWithFormat:@"day %ld:",(long)i]];
//            [textString appendString:placeModel.dayPlaces];
//            [textString appendString:@"\n"];

        }
    }
    self.routeInfoLabel.text = textString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)seeDetailAction {
    [self.delegate jumpToTourPlanDetail];
    //跳转到日程详情页 bylhr
}

@end
