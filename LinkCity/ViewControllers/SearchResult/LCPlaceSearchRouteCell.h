//
//  LCPlaceSearchRouteCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlaceSearchRouteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *routeTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

- (void)updateShowRouteView:(NSString *)routeTitle isLastOne:(BOOL)lastOne;
@end
