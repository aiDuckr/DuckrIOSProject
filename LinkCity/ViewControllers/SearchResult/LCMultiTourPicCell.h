//
//  LCMultiTourPicCell.h
//  LinkCity
//
//  Created by roy on 6/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourPic.h"

@protocol LCMultiTourPicCellDelegate;
@interface LCMultiTourPicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonTwo;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewThree;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonThree;

@property (nonatomic, assign) id<LCMultiTourPicCellDelegate> delegate;
@property (nonatomic, strong) NSArray *tourPicArray;    //LCTourPic array

+ (CGFloat)getCellHeight;

@end



@protocol LCMultiTourPicCellDelegate <NSObject>

- (void)multiTourPicCell:(LCMultiTourPicCell *)cell didClickButtonIndex:(NSInteger)index; //start from 0

@end