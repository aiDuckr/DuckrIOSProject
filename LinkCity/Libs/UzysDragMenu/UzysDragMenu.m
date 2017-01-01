//
//  UzysDragMenu.m
//  UzysDragMenu
//
//  Created by Jaehoon Jung on 13. 2. 25..
//  Copyright (c) 2013년 Uzys. All rights reserved.
//

#import "UzysDragMenu.h"

@interface UzysDragMenu()<LCItemThemeDelegate>
@property (nonatomic,strong) NSMutableArray *itemViews;
@property (nonatomic,strong) UzysDragMenuControlView *controlView;

@property (nonatomic,assign) CGRect openFrame;
@property (nonatomic,assign) CGRect textFieldFrame;//键盘出现时的位置
@property (nonatomic,assign) CGRect closeFrame;
@property (nonatomic,assign) BOOL isSuperViewGesture;
@property (nonatomic,assign) BOOL isOpen;//初始化是否展开

-(void)setupLayout;
-(void)setupGesture;
@end

@implementation UzysDragMenu

-(id)initWithcontrolMenu:(UzysDragMenuControlView *)controlView superViewGesture:(BOOL)isSuperViewGesture Open:(BOOL)isOpen{
    self = [super init];
    if(self)
    {
        //Initialization code
        self.userInteractionEnabled = YES;
        self.itemViews = [NSMutableArray array];
        self.controlView = controlView;
        self.isSuperViewGesture = isSuperViewGesture;
        self.isOpen=isOpen;
        [self setupLayout];
        [self setupGesture];
    }
    return self;
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"superview.frame"];
    [_pItems release];
    [_controlView release];
    [_itemViews release];
    [super ah_dealloc];
}

-(void)didMoveToSuperview{

    if([self observationInfo]){
        [self removeObserver:self forKeyPath:@"superview.frame"];
    }
    [self addObserver:self forKeyPath:@"superview.frame" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setupGesture{
    UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)] autorelease];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:panGestureRecognizer];
    if(self.isSuperViewGesture)
        [self.superview addGestureRecognizer:panGestureRecognizer];
}
-(void)setupLayout{
    [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.itemViews removeAllObjects];
    [self.controlView removeFromSuperview];


    _itemView = [[[NSBundle mainBundle] loadNibNamed:@"UzysDragMenuItemView" owner:self options:nil] lastObject];
    CGFloat menuHeight =_itemView.bounds.size.height + self.controlView.bounds.size.height;
    CGFloat menuWidth = DEVICE_WIDTH;
    CGFloat menuYPos = _itemView.bounds.size.height  +self.controlView.bounds.size.height;
    CGFloat superHeight = self.superview.bounds.size.height;
    
    
    self.closeFrame = CGRectMake(0, superHeight - self.controlView.bounds.size.height, menuWidth, menuHeight);
    self.openFrame = CGRectMake(0, superHeight - menuYPos, menuWidth, menuHeight);
    if(self.isOpen){
        [self.controlView.imageView setImage:[UIImage imageNamed:@"LocalTabCloseSelectedView"]];
        [self setFrame:self.openFrame];
    }
    else{
        [self setFrame:self.closeFrame];
        [self.controlView.imageView setImage:[UIImage imageNamed:@"OpenSelectedView"]];
    }
    
    self.pItems=[NSArray arrayWithObjects:@"", nil];
    [self.pItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UzysDragMenuItemView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"UzysDragMenuItemView" owner:self options:nil] lastObject];
        itemView.itemDelegate=self;
        itemView.frame = CGRectMake(0, self.controlView.bounds.size.height + itemView.bounds.size.height*idx, DEVICE_WIDTH, itemView.bounds.size.height);
        itemView.userInteractionEnabled = YES;
//        itemView.tag = itemView.item.tag;
        
        [self addSubview:itemView];
        [self sendSubviewToBack:itemView];
        [self.itemViews addObject:itemView];
        
    }];
    
    self.controlView.frame = CGRectMake((self.bounds.size.width-self.controlView.bounds.size.width)/2, 0,DEVICE_WIDTH, self.controlView.bounds.size.height);
    [self addSubview:self.controlView];
    NSLog(@"UzysDMenu Frame %@",NSStringFromCGRect(self.frame));
    NSLog(@"UzysControlView Frame %@",NSStringFromCGRect(self.controlView.frame));
    
}
#pragma mark - menu

-(void)toggleMenu{
    if(CGRectEqualToRect(self.frame, self.openFrame)){
        [self closeMenu];
    }
    else{
        [self openMenu];
    }
}
-(void)openMenu{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        [self.controlView.imageView setImage:[UIImage imageNamed:@"LocalTabCloseSelectedView"]];
        self.frame = self.openFrame;
    } completion:^(BOOL finished) {
    }];
}
-(void)closeMenu{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = self.closeFrame;
        [self.controlView.imageView setImage:[UIImage imageNamed:@"OpenSelectedView"]];
    } completion:^(BOOL finished) {
    }];
}
- (void)ItemdidSelectedThemeStr:(NSString*)ThemeStr{//用户输入主题
    if([self.localDelegate respondsToSelector:@selector(localDidSelectselfTheme:)])
    [self.localDelegate localDidSelectselfTheme:ThemeStr];
}
- (void) ItemdidSelectedThemeID:(NSInteger)ThemeID{
    if ([self.localDelegate respondsToSelector:@selector(localDidSelectTheme:)])
        [self.localDelegate localDidSelectTheme:ThemeID];
}
- (void) changeViewForTextField:(float) height{
    self.textFieldFrame=CGRectMake(0, self.openFrame.origin.y-height, self.openFrame.size.width, self.openFrame.size.height);
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = self.textFieldFrame;
    } completion:^(BOOL finished) {
    }];
}


- (IBAction)cancelButtonAction:(id)sender {
    // 选择或者输入主题。
//    if ([self.delegate respondsToSelector:@selector(localDidSelectTheme:)]) {
//        [self.delegate localDidSelectTheme:1];
//    }
//    else if ([self.delegate respondsToSelector:@selector(localDidSelectselfTheme:)]) {
//        [self.delegate localDidSelectselfTheme:@""];
//    }
}
#pragma mark - Observe Keypath

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if([keyPath isEqualToString:@"superview.frame"])
    {
        [self setupLayout];
        [self setupGesture];
    }
}
#pragma mark - Gesture Recognizer
- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer
{
    if(([recognizer state] == UIGestureRecognizerStateBegan)||([recognizer state] == UIGestureRecognizerStateChanged) )
    {
        CGPoint movement = [recognizer translationInView:self.superview];
        CGRect old_rect = self.frame;
        
        old_rect.origin.y = old_rect.origin.y + movement.y;
        if(old_rect.origin.y < self.openFrame.origin.y) {
            self.frame = self.openFrame;
        } else if (old_rect.origin.y > self.closeFrame.origin.y) {
            self.frame = self.closeFrame;
        } else {
            self.frame = old_rect;            
        }
        
        [recognizer setTranslation:CGPointZero inView:self.superview];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        CGFloat halfPoint = (self.closeFrame.origin.y + self.openFrame.origin.y)/ 2;
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if(self.frame.origin.y > halfPoint)
        {
            [self closeMenu];
        }
        else
        {
            [self openMenu];
        }
    }

}

@end
