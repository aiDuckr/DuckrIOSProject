//
//  LCInviteFilterView.h
//  LinkCity
//
//  Created by 张宗硕 on 8/1/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFilterTagButton.h"

@class LCInviteFilterView;

@protocol LCInviteFilterViewDelegate <NSObject>
- (void)inviteFilterViewDidFilter:(LCInviteFilterView *)userFilterView fitlerThemeId:(NSInteger)themeId userSex:(UserSex)sex filtType:(LCPlanOrderType)type;
@end

@interface LCInviteFilterView : UIView
@property (weak, nonatomic) IBOutlet LCFilterTagButton *sexDefaultButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *sexMaleButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *sexFemaleButton;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderDefaultButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderDistanceButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderCreatedTimeButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderDepartTimeButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


+ (instancetype)createInstance;

@property (nonatomic, weak) id<LCInviteFilterViewDelegate> delegate;

@end
