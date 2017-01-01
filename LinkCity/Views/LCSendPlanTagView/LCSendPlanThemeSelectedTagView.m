//
//  LCSendPlanThemeSelectedTagView.m
//  LinkCity
//
//  Created by lhr on 16/4/30.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendPlanThemeSelectedTagView.h"
#import "UIView+BlocksKit.h"

#import "LCRouteThemeModel.h"

@interface LCSendPlanThemeSelectedTagView()

@property (nonatomic, strong) UIView *spaLineViewV1;

@property (nonatomic, strong) UIView *spaLineViewV2;

@property (nonatomic, strong) UIView *spaLineViewH1;

@property (nonatomic, strong) UIView *spaLineViewH2;

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UIButton *button3;

@property (nonatomic, strong) UIButton *button4;

@property (nonatomic, strong) UIButton *button5;

@property (nonatomic, strong) UIButton *button6;

@property (nonatomic, strong) UIButton *button7;

@property (nonatomic, strong) UIButton *button8;

@property (nonatomic, strong) UIButton *button9;

@property (nonatomic, assign) NSInteger selectedItemIndex;

@property (nonatomic, strong) NSMutableArray * buttonArray;

@end

@implementation LCSendPlanThemeSelectedTagView

- (void)setUpWithFrame:(CGRect)frame {
    //self = [super initWithFrame:frame];
    NSInteger insetX1 = round(frame.size.width / 3);
    NSInteger insetX2 = round(frame.size.width / 3 ) * 2;
    NSInteger insetY1 = round(frame.size.height / 3);
    NSInteger insetY2 = round(frame.size.height / 3) * 2;
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    self.buttonArray = [NSMutableArray arrayWithCapacity:0];
    self.spaLineViewH1 = [[UIView alloc] initWithFrame:CGRectMake(insetX1,0,0.5,height)];
    self.spaLineViewH2 = [[UIView alloc] initWithFrame:CGRectMake(insetX2,0,0.5,height)];
    self.spaLineViewV1 = [[UIView alloc] initWithFrame:CGRectMake(0,insetY1,width,0.5)];
    self.spaLineViewV2 = [[UIView alloc] initWithFrame:CGRectMake(0,insetY2,width,0.5)];
    self.spaLineViewH1.backgroundColor = DefaultSpalineColor;
    self.spaLineViewH2.backgroundColor = DefaultSpalineColor;
    self.spaLineViewV1.backgroundColor = DefaultSpalineColor;
    self.spaLineViewV2.backgroundColor = DefaultSpalineColor;
    [self addSubview:self.spaLineViewH1];
    [self addSubview:self.spaLineViewH2];
    [self addSubview:self.spaLineViewV1];
    [self addSubview:self.spaLineViewV2];
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button7 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button8 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button9 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonInforWithIndex:0 button:self.button1];
    [self.buttonArray addObject:self.button1];
    [self setButtonInforWithIndex:1 button:self.button2];
    [self.buttonArray addObject:self.button2];
    [self setButtonInforWithIndex:2 button:self.button3];
    [self.buttonArray addObject:self.button3];
    [self setButtonInforWithIndex:3 button:self.button4];
    [self.buttonArray addObject:self.button4];
    [self setButtonInforWithIndex:4 button:self.button5];
    [self.buttonArray addObject:self.button5];
    [self setButtonInforWithIndex:5 button:self.button6];
    [self.buttonArray addObject:self.button6];
    [self setButtonInforWithIndex:6 button:self.button7];
    [self.buttonArray addObject:self.button7];
    [self setButtonInforWithIndex:7 button:self.button8];
    [self.buttonArray addObject:self.button8];
    [self setButtonInforWithIndex:8 button:self.button9];
    [self.buttonArray addObject:self.button9];
    
    self.button1.frame = CGRectMake(0, 0, insetX1 + 0.5, insetY1 + 0.5);
    self.button2.frame = CGRectMake(insetX1, 0, insetX1 + 1, insetY1 + 0.5);
    self.button3.frame = CGRectMake(insetX2, 0, insetX1 + 0.5, insetY1 + 0.5);
    
    self.button4.frame = CGRectMake(0, insetY1, insetX1 + 0.5, insetY1 + 1);
    self.button5.frame = CGRectMake(insetX1, insetY1, insetX1 + 1, insetY1 + 1);
    self.button6.frame = CGRectMake(insetX2, insetY1, insetX1 + 0.5, insetY1 + 1);
    
    self.button7.frame = CGRectMake(0, insetY2, insetX1 + 0.5, insetY1 + 0.5);
    self.button8.frame = CGRectMake(insetX1, insetY2, insetX1 + 1, insetY1 + 0.5);
    self.button9.frame = CGRectMake(insetX2, insetY2, insetX1 + 0.5, insetY1 + 0.5);
    
    
}


- (void)setItemArray:(NSArray *)itemArray {
    int i = 0;
    for (LCRouteThemeModel * model in itemArray) {
        UIButton * button = [self.buttonArray objectAtIndex:i];
        [button setTitle:model.title forState:UIControlStateNormal];
        i++;
    }
    _itemArray = itemArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setButtonInforWithIndex:(NSInteger)index button:(UIButton *)button {
    //button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    
    button.titleLabel.font = LCDefaultFontSize(14);
    [button setTitleColor:UIColorFromRGBA(0x2c2a28, 1.0) forState:UIControlStateNormal];
    //button.titleLabel.textColor = ;
    //button.backgroundColor = [UIColor redColor];
    [self addSubview:button];
}

- (BOOL)selectItemWithThemeId:(NSInteger)ID {
    BOOL result = NO;
    for (LCRouteThemeModel * model in self.itemArray) {
        if (model.tourThemeId == ID) {
            NSInteger index = [self.itemArray indexOfObject:model];
            UIButton * button = [self.buttonArray objectAtIndex:index];

                //[self.delegate didSelectedThemeWithIndex:sender.tag view:self];
                button.layer.borderColor = [UIColorFromRGBA(0xFEDD00, 1.0) CGColor];
                button.layer.borderWidth = 2.0;
                result = YES;
            break;
        }
    }
    return result;
}
- (void)buttonAction:(UIButton *)sender {
    UIButton * button = [self.buttonArray objectAtIndex:sender.tag];
    if (self.itemArray.count > sender.tag) {
        [self.delegate didSelectedThemeWithIndex:sender.tag view:self];
        button.layer.borderColor = [UIColorFromRGBA(0xFEDD00, 1.0) CGColor];
        button.layer.borderWidth = 2.0;
    }
}
- (void)clearSelection {
    for (UIButton * button  in self.buttonArray) {
        button.layer.borderWidth = 0;
        button.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}

@end
