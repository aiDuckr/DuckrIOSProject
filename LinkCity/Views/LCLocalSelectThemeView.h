//
//  LocalSelectThememView.h
//  LinkCity
//
//  Created by linkcity on 16/8/1.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFilterTagButton.h"

@class LCLocalSelectThemeView;

@protocol LCLocalSelectThemeViewDelegate <NSObject>
- (void)inviteFilterViewDidFilter:(LCLocalSelectThemeView *)userFilterView fitlerThemeId:(NSInteger)themeId userSex:(UserSex)sex filtType:(LCLocalSelectedType)type;
@end

@interface LCLocalSelectThemeView : UIView

+ (instancetype)createInstance;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *sexDefaultButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *sexMaleButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *sexFemaleButton;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderDistanceButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderDepartTimeButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) id<LCLocalSelectThemeViewDelegate> delegate;

@end

