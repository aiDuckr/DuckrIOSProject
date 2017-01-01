//
//  LCTourpicBaseView.h
//  LinkCity
//
//  Created by 张宗硕 on 4/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourpic.h"

typedef enum : NSInteger {
    LCTourpicViewType_PicOne = 1,
    LCTourpicViewType_PicTwo = 2,
    LCTourpicViewType_PicThree = 3,
    LCTourpicViewType_PicFour = 4,
    LCTourpicViewType_PicFive = 5,
    LCTourpicViewType_PicSix = 6,
    LCTourpicViewType_PicSeven = 7,
    LCTourpicViewType_PicEight = 8,
    LCTourpicViewType_PicNine = 9,
} LCTourpicViewType;

@interface LCTourpicBaseView : UIView <UIGestureRecognizerDelegate>
+ (instancetype)createInstance:(LCTourpic *)tourpic;
- (void)updateTourpicView:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type;
- (void)addImageViewToArray:(NSMutableArray *)mutArr;
- (void)viewTourpicPhoto:(id)sender;

@property (retain, nonatomic) LCTourpic *tourpic;
@end
