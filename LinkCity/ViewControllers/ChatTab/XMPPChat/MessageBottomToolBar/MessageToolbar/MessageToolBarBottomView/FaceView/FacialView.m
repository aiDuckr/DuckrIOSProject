/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "FacialView.h"
#import "Emoji.h"

@interface FacialView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faces = [Emoji allEmoji];
    }
    return self;
}


//给faces设置位置
-(void)loadFacialView:(int)page size:(CGSize)size
{
    int maxRow = 5;
    int maxCol = 8;
    int maxMotionRow = 4;
    CGFloat itemWidth = self.frame.size.width / maxCol;
    CGFloat itemHeight = self.frame.size.height / maxRow;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, maxCol * itemWidth, maxMotionRow * itemHeight)];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(page * maxCol * itemWidth, maxMotionRow * itemHeight);
    [self addSubview:scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, maxMotionRow * itemHeight, maxCol * itemWidth, itemHeight)];
    self.pageControl.numberOfPages = page;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = UIColorFromR_G_B_A(168, 164, 160, 0.3);
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    [self addSubview:self.pageControl];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setBackgroundColor:[UIColor clearColor]];
    [deleteButton setFrame:CGRectMake((maxCol - 2) * itemWidth - 30, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
    [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
    deleteButton.tag = 10000;
    [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:12];
    [sendButton setFrame:CGRectMake((maxCol - 1) * itemWidth - 30, (maxRow - 1) * itemHeight + (itemHeight-25)/2.0, 58, 25)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:UIColorFromRGBA(DUCKER_YELLOW, 1)];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 3;
    [self addSubview:sendButton];
    
    for (int p = 0; p < page; p++){
        for (int row = 0; row < maxMotionRow; row++) {
            for (int col = 0; col < maxCol; col++) {
                int index = p * maxMotionRow * maxCol + row * maxCol + col;
                if (index < [_faces count]) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setFrame:CGRectMake(p * maxCol * itemWidth + col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                    [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                    [button setTitle: [_faces objectAtIndex:(p * maxMotionRow * maxCol + row * maxCol + col)] forState:UIControlStateNormal];
                    button.tag = p * maxMotionRow * maxCol + row * maxCol + col;
                    [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:button];
                }
                else{
                    break;
                }
            }
        }
    }
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger curPage = (NSInteger)(scrollView.contentOffset.x + 10)  /  (NSInteger)(scrollView.frame.size.width);
    self.pageControl.currentPage = curPage;
}


@end
