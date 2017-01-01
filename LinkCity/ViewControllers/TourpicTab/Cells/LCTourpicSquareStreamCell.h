//
//  LCTourpicSquareStreamCell.h
//  LinkCity
//
//  Created by lhr on 16/4/3.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourpic.h"

@class LCTourpicSquareStreamCell;
@protocol LCTourpicSquareStreamCellDelegate <NSObject>
//delegate to do: 发送点赞请求，改变界面对应的model （数字+1，已经点过赞）重新绑定
- (void)didThumbUpWithCell:(LCTourpicSquareStreamCell *)cell;

- (void)didGetImageWithImageHeight:(CGFloat)Cellheight cell:(LCTourpicSquareStreamCell *)cell;
@end
@interface LCTourpicSquareStreamCell : UITableViewCell

@property (nonatomic, strong) LCTourpic *model;
@property (nonatomic, weak)  id <LCTourpicSquareStreamCellDelegate> delegate;


- (void)bindWithData:(LCTourpic *)model;


@end
