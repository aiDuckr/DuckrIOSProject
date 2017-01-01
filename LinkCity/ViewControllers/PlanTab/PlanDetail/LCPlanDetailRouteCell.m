//
//  LCPlanDetailRouteCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailRouteCell.h"
#import "LCPlanDetailARouteDayCell.h"


@interface LCPlanDetailRouteCell()<UITableViewDelegate,UITableViewDataSource>

@end

static const float PlanDetailARouteDayCellHeight = 44;
static NSString *const reuseID_PlanDetailARouteDayCell = @"PlanDetailARouteDayCell";
@implementation LCPlanDetailRouteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *topBgImage = [UIImage imageNamed:LCCellTopBg];
    topBgImage = [topBgImage resizableImageWithCapInsets:LCCellTopBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.topBg.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:LCCellBottomBg];
    bottomImage = [bottomImage resizableImageWithCapInsets:LCCellBottomBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.bottomBg.image = bottomImage;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)getCellHeightOfPlan:(LCPlanModel *)plan{
    CGFloat height = 5;    // cell top
    height += 44; //top part
    height += [plan getRouteDayNum] * PlanDetailARouteDayCellHeight;    // every route day cell height
    height += 2; //bottom shadow
    height += 5; //cell bottom
    
    //LCLogInfo(@"PlanDetailRouteCell Height:%f",height);
    return height;
}

- (void)setPlan:(LCPlanModel *)plan{
    [super setPlan:plan];
    
    [self updateShow];
}

- (void)updateShow{
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.plan getRouteDayNum];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCPlanDetailARouteDayCell *aRouteDayCell = [tableView dequeueReusableCellWithIdentifier:reuseID_PlanDetailARouteDayCell forIndexPath:indexPath];
    
    aRouteDayCell.dayLabel.text = [NSString stringWithFormat:@"Day%ld",(long)(indexPath.row+1)];
    aRouteDayCell.destLabel.text = [self.plan getRoutePlaceStringForDay:(indexPath.row+1) withSeparator:@"-"];
    
    if (indexPath.row+1 == [self.plan getRouteDayNum]) {
        // last row
        aRouteDayCell.bottomLine.hidden = YES;
    }else{
        // not last row
        aRouteDayCell.bottomLine.hidden = NO;
    }
    
    //LCLogInfo(@"cell %ld   day:%@,dest:%@",(long)indexPath.row,aRouteDayCell.dayLabel.text,aRouteDayCell.destLabel.text);
    
    return aRouteDayCell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PlanDetailARouteDayCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(planDetailRouteCell:didSelectDayIndex:)]) {
        [self.delegate planDetailRouteCell:self didSelectDayIndex:indexPath.row];
    }
}


@end
