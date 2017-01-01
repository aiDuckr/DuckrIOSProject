//
//  LCPlanTabTimeFilterView.h
//  LinkCity
//
//  Created by 张宗硕 on 6/21/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanTabTimeFilterView : UIView
+ (instancetype)createInstance;

@property (weak, nonatomic) IBOutlet UIButton *tomorrowButton;
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *buttonArr;
@property (strong, nonatomic) NSString *planStartDate;
@property (strong, nonatomic) NSString *planEndDate;
@end
