//
//  LCMultiTourPicCell_5.m
//  LinkCity
//
//  Created by godhangyu on 16/6/8.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourPic.h"

@protocol LCMultiTourPicCellDelegate_5;
@interface LCMultiTourPicCell_5 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonTwo;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewThree;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonThree;

@property (nonatomic, assign) id<LCMultiTourPicCellDelegate_5> delegate;
@property (nonatomic, strong) NSArray *tourPicArray;    //LCTourPic array

+ (CGFloat)getCellHeight;

@end



@protocol LCMultiTourPicCellDelegate_5 <NSObject>

- (void)multiTourPicCell:(LCMultiTourPicCell_5 *)cell didClickButtonIndex:(NSInteger)index; //start from 0

@end