//
//  LCPlanTabYellowLocView.h
//  LinkCity
//
//  Created by Roy on 6/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanTabYellowLocView : UIView
@property (weak, nonatomic) IBOutlet UILabel *locNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeLocationButton;

+ (instancetype)createInstance;
@end
