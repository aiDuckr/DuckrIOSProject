//
//  LCHomeVCBannerCell.h
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeVCBannerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

+ (CGFloat)getCellHeight;
@end
