//
//  LCSendPlanDetailTagCell.m
//  LinkCity
//
//  Created by lhr on 16/4/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendPlanDetailTagCell.h"
#import "LCSendPlanTagView.h"
#import "LCRouteThemeModel.h"
@interface LCSendPlanDetailTagCell()<LCSendPlanTagViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;
@property (nonatomic,strong) NSMutableArray *tagViewArray;
@property (nonatomic, assign) NSInteger selectedTagCount;


@end

static const CGFloat leftMargin = 12.0f;
static const CGFloat topMargin = 15.0f;
static const CGFloat leftMarginInset = 15.0f;
static const CGFloat topMarginInset = 12.0f;
static const CGFloat tagHeight = 28.0f;


@implementation LCSendPlanDetailTagCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.tagItemArray = @[@"小明",@"电影",@"我是小芳",@"小红",@"小刚",@"明天",@"日了狗",@"小刚",@"明天",@"日了狗"];
   
    _tagViewArray = [[NSMutableArray alloc] init];
    self.selectedTagCount = 0;
    
    
    // Initialization code
}
- (void)setIsInTheSameCity:(BOOL)isInTheSameCity {
    if (isInTheSameCity == YES && self.tagViewArray.count == 0) {
        self.tagItemArray = [[LCDataManager sharedInstance].appInitData routeLocalTags];
        [self initTagView];

    } else if (isInTheSameCity == NO &&self.tagViewArray.count == 0) {
        self.tagItemArray = [[LCDataManager sharedInstance].appInitData routePlanTags];
        [self initTagView];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initTagView {
    //CGFloat centerX = DEVICE_WIDTH / 8;
    //CGFloat centerY = tagViewHeight / 2;
    for (LCRouteThemeModel *item in self.tagItemArray) {
        LCSendPlanTagView * view = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 0, tagHeight) isFixedFrame:NO titleString:item.title];
        [self.tagViewArray addObject:view];
        view.delegate = self;
        
        
    }
    CGFloat offsetX = leftMargin;
    CGFloat offsetY = topMargin;
    
    NSInteger itemCount = 0;
    for (LCSendPlanTagView * view in self.tagViewArray) {
//        view.center =  CGPointMake(centerX, centerY);
//        centerX += DEVICE_WIDTH / 4;
        itemCount += 1;
        
        
        if ((offsetX + view.frame.size.width) > (DEVICE_WIDTH - leftMargin)) {
            offsetX = leftMargin;
            offsetY += topMarginInset;
            offsetY += tagHeight;
        }
        if (itemCount == self.tagViewArray.count) {
            self.tagViewHeight.constant = (offsetY + topMargin + tagHeight);
        }
        view.frame = CGRectMake(offsetX, offsetY, view.frame.size.width, view.frame.size.height);
        offsetX += view.frame.size.width;
        offsetX += leftMarginInset;
        [self.tagView addSubview:view];
        
        
    }

}

- (void)didPressLCSendPlanTagView:(LCSendPlanTagView *)view {
    [self.delegate didSelectTag];
    if (view.isSelected) {
        view.isSelected = NO;
        self.selectedTagCount -= 1;
    } else {
        if (self.selectedTagCount < 3) {
            self.selectedTagCount += 1;
            view.isSelected = YES;
        } else {
            [YSAlertUtil tipOneMessage:@"不能选择更多标签了"];
        }
        
    }
}

- (NSArray *)selectedItemArrStr {
    NSMutableArray * tagArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.tagViewArray.count; i++) {
        LCSendPlanTagView* view = self.tagViewArray[i];
        if (view.isSelected) {
            LCRouteThemeModel * model = [self.tagItemArray objectAtIndex:i];
            [tagArray addObject:model];
        }
    }
    _selectedItemArrStr = tagArray;
    return _selectedItemArrStr;
    
}

- (void)updateShowWithPlan:(LCPlanModel *)plan {
        if (plan.tagsArray && plan.tagsArray.count > 0)  {
            for (LCRouteThemeModel * model in plan.tagsArray) {
                if (self.tagItemArray) {
                    //self.tagItemArray
                    //model.tourThemeId
                    for (LCRouteThemeModel *viewModel in self.tagItemArray) {
                        if (model.tourThemeId == viewModel.tourThemeId) {
                            NSInteger index = [self.tagItemArray indexOfObject:viewModel];
                            if (index != NSNotFound && index < self.tagViewArray.count) {
                                LCSendPlanTagView * view = [self.tagViewArray objectAtIndex:index];
                                view.isSelected = YES;
                            }
                            break;
                        }
                    }
                    
                }
            }
        }

    
   
}
@end
