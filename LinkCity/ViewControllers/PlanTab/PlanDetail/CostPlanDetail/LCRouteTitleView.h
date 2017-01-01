//
//  LCRouteTitleView.h
//  LinkCity
//
//  Created by Roy on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRouteTitleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dayNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesLabel;

+ (instancetype)createInstance;
+ (CGFloat)getCellHeight;
@end
