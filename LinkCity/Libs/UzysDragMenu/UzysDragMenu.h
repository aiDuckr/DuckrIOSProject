//
//  UzysDragMenu.h
//  UzysDragMenu
//
//  Created by Jaehoon Jung on 13. 2. 25..
//  Copyright (c) 2013년 Uzys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysDragMenuItemView.h"
#import "UzysDragMenuControlView.h"

@protocol UzysDragMenuDelegate;

@interface UzysDragMenu : UIView
@property (nonatomic, weak) id<UzysDragMenuDelegate> localDelegate;
@property (nonatomic,strong) UzysDragMenuItemView *itemView;
@property (nonatomic,strong) NSArray *pItems;

-(id)initWithcontrolMenu:(UIView *)controlView superViewGesture:(BOOL)isSuperViewGesture Open:(BOOL)isOpen;

-(void)toggleMenu;
-(void)openMenu;
-(void)closeMenu;
@end

@protocol UzysDragMenuDelegate <NSObject>
- (void)localDidSelectTheme:(NSInteger)ThemeId;//用户已选择主题
- (void)localDidSelectselfTheme:(NSString*)ThemeStr ;//用户自定义主题
@end