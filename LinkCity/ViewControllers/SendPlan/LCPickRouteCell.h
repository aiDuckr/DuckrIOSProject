//
//  LCPickRouteCell.h
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPickRouteCellDelegate;
@interface LCPickRouteCell : UITableViewCell
@property (nonatomic, weak) id<LCPickRouteCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;

- (void)updateShowWithRoute:(LCUserRouteModel *)route selected:(BOOL)selected;

@end


@protocol LCPickRouteCellDelegate <NSObject>
@optional
- (void)pickRouteCellDidClickSelect:(LCPickRouteCell *)cell;

@end
