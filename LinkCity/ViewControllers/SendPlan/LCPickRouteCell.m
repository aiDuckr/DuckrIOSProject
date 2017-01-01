//
//  LCPickRouteCell.m
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPickRouteCell.h"

@implementation LCPickRouteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithRoute:(LCUserRouteModel *)route selected:(BOOL)selected{
    self.routeNameLabel.text = [LCStringUtil getNotNullStr:route.routeTitle];
    
    if (selected) {
        self.selectImageView.image = [UIImage imageNamed:@"SendPlanRouteSelected"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"SendPlanRouteUnselected"];
    }
}

- (IBAction)selectBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pickRouteCellDidClickSelect:)]) {
        [self.delegate pickRouteCellDidClickSelect:self];
    }
}


@end
