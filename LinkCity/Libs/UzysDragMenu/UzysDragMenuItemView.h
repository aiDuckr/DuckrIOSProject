//
//  UzysSMMenuView.h
//  UzysSlideMenu
//
//  Created by Jaehoon Jung on 13. 2. 21..
//  Copyright (c) 2013년 Uzys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UzysDragMenuItemView;

@protocol LCItemThemeDelegate <NSObject>
- (void) ItemdidSelectedThemeID:(NSInteger)ThemeID;
- (void) ItemdidSelectedThemeStr:(NSString*)ThemeStr;//用户已选择主题
- (void) changeViewForTextField:(float) height;

@end

@interface UzysDragMenuItemView : UIView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;//Button选择
@property (nonatomic, weak) id<LCItemThemeDelegate> itemDelegate;

@end
