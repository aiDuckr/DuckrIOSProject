//
//  LCRoutePlaceDayHeaderView.h
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRoutePlaceDayHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayRouteLabel;



+ (instancetype)createInstance;
+ (CGFloat)getCellHeight;
@end
