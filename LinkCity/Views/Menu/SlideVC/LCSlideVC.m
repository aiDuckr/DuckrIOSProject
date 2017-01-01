//
//  LCSlideVC.m
//  LinkCity
//
//  Created by roy on 10/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCSlideVC.h"
#import "LCCommonApi.h"
#import "LCChatManager.h"

// constants
const CGFloat LCSlideMenuMinimumRelativePanDistanceToOpen = 0.5;
const CGFloat LCSlideDefaultMenuWidth = 240.0;
const CGFloat LCSlideDefaultDamping = 1;
const CGFloat LCSlideMinimumPanGestureLeftScreenEdgeToOpen = 30;
// animation times
const CGFloat LCSlideDefaultOpenAnimationTime = 0.4;
const CGFloat LCSlideDefaultCloseAnimationTime = 0.4;

@interface LCSlideVC ()<UIGestureRecognizerDelegate, LCCommonApiDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, assign) CGFloat contentViewTranslationX; //use for pan gesture animation
@property (nonatomic, assign) CGFloat contentViewTranslationY;

@property (nonatomic, strong) UIView *maskView;
@end

@implementation LCSlideVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //set defaut value
    _menuWidth = LCSlideDefaultMenuWidth;
    _tapGestureEnabled = YES;
    _panGestureEnabled = YES;
    
    //init gesture recognizer
    //Fuck this imageView!!
    self.bgImageView.userInteractionEnabled = YES;
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.tapRecognizer.delegate = self;
    self.tapRecognizer.cancelsTouchesInView = NO;
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:self.panRecognizer];
    self.panRecognizer.delegate = self;
    self.panRecognizer.cancelsTouchesInView = YES;
    
    [self addObservers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //RLog(@"viewDidAppear:%@,transform:%@",NSStringFromCGRect(self.contentVC.view.frame),NSStringFromCGAffineTransform(self.contentVC.view.transform));
}

- (void)viewDidLayoutSubviews{
    [self addChildViewControllers];
}

- (void)viewWillDisappear:(BOOL)animated{
    /***
     for bug: if showing menu, and present view at the same time
               present view will stop show menu animtaion, keep it's frame but change it's transform
               then showing wrong.
     how to fix:   every time will appear, set view frame to start position, and transform to transformIdentity
     */
    self.contentVC.view.transform = CGAffineTransformIdentity;
    self.contentVC.view.frame = CGRectMake(0, 0, self.contentVC.view.frame.size.width, self.contentVC.view.frame.size.height);
    [super viewWillDisappear:animated];
    
    //RLog(@"viewDidAppear:%@,transform:%@",NSStringFromCGRect(self.contentVC.view.frame),NSStringFromCGAffineTransform(self.contentVC.view.transform));
}

- (void)dealloc{
    [self removeObservers];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMenuNotify:) name:NotificationShowMenu object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideMenuNotify:) name:NotificationHideMenu object:nil];
}
- (void)removeObservers{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowMenu object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationHideMenu object:nil];

    [self.contentVC.view removeObserver:self forKeyPath:@"transform" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"transform"]) {
//        if (!self.maskView) {
//            self.maskView = [[UIView alloc]initWithFrame:self.view.frame];
//            self.maskView.backgroundColor = [UIColor blackColor];
//        }
//        float tx = self.contentVC.view.transform.tx;
//        if (tx < 50) {
//            [self.maskView removeFromSuperview];
//            self.maskView.alpha = 0;
//            self.contentVC.view.alpha = 1.0;
//        }else{
//            [self.contentVC.view addSubview:self.maskView];
//            self.maskView.frame = self.view.frame;
//            self.maskView.alpha = (tx-50)*1.0/(self.view.frame.size.width-50)*0.2;
//        }
        
        
        //添加maskView，来禁掉contentView中控件的tap事件
        if (!self.maskView) {
            self.maskView = [[UIView alloc]initWithFrame:self.view.frame];
            //self.maskView.backgroundColor = [UIColor clearColor];
            self.maskView.backgroundColor = [UIColor clearColor];
        }
        float tx = self.contentVC.view.transform.tx;
        if (tx < 50) {
            [self.maskView removeFromSuperview];
        }else{
            [self.contentVC.view addSubview:self.maskView];
        }
    }
    //RLog(@"keyvalue:%@,transform:%@",NSStringFromCGRect(self.contentVC.view.frame),NSStringFromCGAffineTransform(self.contentVC.view.transform));
}


- (void)showMenuNotify:(NSNotification *)notify{
    [self showMenuAnimated:YES];
}
- (void)hideMenuNotify:(NSNotification *)notify{
    [self hideMenuAnimated:YES];
}

#pragma mark - Interface
+ (void)showMenu{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowMenu object:nil];
}
+ (void)hideMenu{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationHideMenu object:nil];
}

- (void)setMenuVC:(UIViewController *)menuVC{
    _menuVC = menuVC;
    [self addChildViewControllers];
}

- (void)setContentVC:(UIViewController <LCSlideContentVCDelegate>*)contentVC{
    _contentVC = contentVC;
    [self addChildViewControllers];
    
    //添加阴影
    self.contentVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentVC.view.layer.shadowOffset = CGSizeMake(-5, 5);
    self.contentVC.view.layer.shadowOpacity = 0.4;
    self.contentVC.view.layer.shadowRadius = 5;
    self.contentVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    [self.contentVC.view addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionOld context:nil];
}

- (void)setBackgroundImage:(UIImage *)image{
    self.bgImageView.image = image;
}

- (void)showMenuAnimated:(BOOL)animated{
    if (!self.menuVC || !self.contentVC) {
        return;
    }
    
    [self showMenuAnimated:animated duration:LCSlideDefaultOpenAnimationTime initialVelocity:1.6];
}
- (void)hideMenuAnimated:(BOOL)animated{
    if (!self.menuVC || !self.contentVC) {
        return;
    }
    
    [self hideMenuAnimated:animated duration:LCSlideDefaultCloseAnimationTime initialVelocity:1.6];
}


#pragma mark - Gesture Action
- (void)tapAction:(UITapGestureRecognizer *)sender {
    RLog(@"tapAction");
    if ([self isMenuVisible] && [sender locationInView:self.contentVC.view].x>=0 ) {
        [self hideMenuAnimated:YES];
    }
}
- (void)panAction:(UIPanGestureRecognizer *)sender {
    if (!_panGestureEnabled) {
        return;
    }
    
    CGPoint translation = [sender translationInView:sender.view];
    CGPoint velocity = [sender velocityInView:sender.view];
    
    //RLog(@"panAction:trans:%@,state:%ld",NSStringFromCGPoint(translation),sender.state);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if (![self isMenuVisible] &&
                [sender locationInView:self.view].x > LCSlideMinimumPanGestureLeftScreenEdgeToOpen) {
                sender.enabled = NO;
                sender.enabled = YES;
                RLog(@">30  %f",[sender locationInView:self.view].x);
            }else{
                RLog(@"<30  %f",[sender locationInView:self.view].x);
            }
            
            self.contentViewTranslationX = self.contentVC.view.transform.tx;
            self.contentViewTranslationY = self.contentVC.view.transform.ty;
            [sender setTranslation:CGPointMake(0, 0) inView:sender.view];
            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat translateToX = translation.x+self.contentViewTranslationX;
            translateToX = MAX(0, translateToX);
            translateToX = MIN(self.view.frame.size.width, translateToX);
            //CGFloat translateToY = self.contentVC.view.frame.origin.x/self.contentVC.view.frame.size.width * 20;
            CGFloat translateToY = 0;
            
            [self.contentVC.view setTransform:CGAffineTransformMakeTranslation(translateToX, translateToY)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            CGFloat transformedVelocity = velocity.x/ABS(self.contentVC.view.transform.tx==0?50:self.contentVC.view.transform.tx);
            CGFloat duration = LCSlideDefaultOpenAnimationTime * 0.66;
            if (velocity.x > 50.0 && self.contentVC.view.transform.tx>=LCSlideMinimumPanGestureLeftScreenEdgeToOpen) {
                [self showMenuAnimated:YES duration:duration initialVelocity:transformedVelocity];
            }else if(velocity.x < -50.0) {
                [self hideMenuAnimated:YES duration:duration initialVelocity:transformedVelocity];
            }else if(self.contentVC.view.transform.tx >= LCSlideMenuMinimumRelativePanDistanceToOpen*self.menuWidth){
                [self showMenuAnimated:YES duration:duration initialVelocity:transformedVelocity];
            }else if(self.contentVC.view.transform.tx < LCSlideMenuMinimumRelativePanDistanceToOpen*self.menuWidth){
                [self hideMenuAnimated:YES duration:duration initialVelocity:transformedVelocity];
            }
        }
            
            break;
            
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (gestureRecognizer==self.panRecognizer &&
        ![self isMenuVisible] &&
        ![self.contentVC canSlideToShowMenu]) {
        //如果contentViewController当前不允许滑动显示菜单，则不显示
        return NO;
    }
    if ([touch.view isKindOfClass:[UIControl class]]) {
        //如果在UIControl的控件上进行操作，则不显示
        return NO;
    }
    return YES;
}

#pragma mark - Inner Function
- (void)addChildViewControllers{
    if (self.view) {
        if (_menuVC) {
            [self addChildViewController:_menuVC];
            [self.bgImageView addSubview:_menuVC.view];
            self.menuVC.view.frame = self.bgImageView.bounds;
            [_menuVC didMoveToParentViewController:self];
        }
        if (_contentVC) {
            [self addChildViewController:_contentVC];
            [self.bgImageView addSubview:_contentVC.view];
            self.contentVC.view.frame = self.bgImageView.bounds;
            [_contentVC didMoveToParentViewController:self];
        }
    }
}

- (void)showMenuAnimated:(BOOL)animated
                duration:(CGFloat)duration
         initialVelocity:(CGFloat)velocity{
    
    if (!self.menuVC || !self.contentVC) {
        return;
    }
    
    //RLog(@"ShowMenu:frame:%@,transform:%@",NSStringFromCGRect(self.contentVC.view.frame),NSStringFromCGAffineTransform(self.contentVC.view.transform));
    
    //call view will appear mannually
    [self.menuVC viewWillAppear:NO];
    
    [self correctContentVCFrame];
    
    //animate
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:animated ? duration : 0.0
                          delay:0
         usingSpringWithDamping:LCSlideDefaultDamping
          initialSpringVelocity:velocity
                        options:0
                     animations:^{
             //blockSelf.contentVC.view.transform = CGAffineTransformMakeTranslation(self.menuWidth, 20);
                         blockSelf.contentVC.view.transform = CGAffineTransformMakeTranslation(self.menuWidth, 0);
                         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                         
                         //添加阴影
                         //self.contentVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
         }
                     completion:^(BOOL completion){
                         //RLog(@"DidShowMenu:frame:%@,transform:%@",NSStringFromCGRect(self.contentVC.view.frame),NSStringFromCGAffineTransform(self.contentVC.view.transform));
                         [self correctContentVCFrame];
                     }];
    
    
}

- (void)hideMenuAnimated:(BOOL)animated
                duration:(CGFloat)duration
         initialVelocity:(CGFloat)velocity{
    
    if (!self.menuVC || !self.contentVC) {
        return;
    }
    
    //RLog(@"HideMenu:%@,transform:%@",NSStringFromCGRect(self.contentVC.view.frame),NSStringFromCGAffineTransform(self.contentVC.view.transform));
    
    //call this mannually
    [self.menuVC viewWillDisappear:NO];
    
    [self correctContentVCFrame];
    
    //animate
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:animated ? duration : 0.0
                          delay:0
         usingSpringWithDamping:LCSlideDefaultDamping
          initialSpringVelocity:velocity
                        options:0
                     animations:^{
                         blockSelf.contentVC.view.transform = CGAffineTransformIdentity;
                         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                         
                         //取消阴影
                         //self.contentVC.view.layer.shadowColor = [UIColor clearColor].CGColor;
                    }
                     completion:^(BOOL finished){
                         //RLog(@"DidHideMenu:%@,transform:%@",NSStringFromCGRect(self.contentVC.view.frame),NSStringFromCGAffineTransform(self.contentVC.view.transform));
                         [self correctContentVCFrame];
                     }];
}

- (BOOL)isMenuVisible;
{
    return !CGAffineTransformEqualToTransform(self.contentVC.view.transform, CGAffineTransformIdentity);
}

- (void)correctContentVCFrame{
    if (self.contentVC.view.frame.origin.x == self.contentVC.view.transform.tx) {
        //
    }else{
        self.contentVC.view.frame = CGRectMake(self.contentVC.view.transform.tx, 0, self.contentVC.view.frame.size.width, self.contentVC.view.frame.size.height);
    }
}
@end
