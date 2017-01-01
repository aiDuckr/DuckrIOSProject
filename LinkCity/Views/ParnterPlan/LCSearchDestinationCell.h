//
//  SearchDestinationCell.h
//  LinkCity
//
//  Created by 张宗硕 on 11/7/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSearchDestinationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
