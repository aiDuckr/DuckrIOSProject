//
//  LCAreaPickView.h
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAreaPickView : UIView

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *curCityLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (instancetype)createInstance;
@end
