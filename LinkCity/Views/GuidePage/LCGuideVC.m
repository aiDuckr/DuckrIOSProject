//
//  LCGuideVC.m
//  LinkCity
//
//  Created by roy on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCGuideVC.h"
#import "LCStoryboardManager.h"
#import "LCDataManager.h"

@interface LCGuideVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;


//第一页

@property (weak, nonatomic) IBOutlet UIView *pOneView;
@property (weak, nonatomic) IBOutlet UIImageView *pOneMain;
@property (weak, nonatomic) IBOutlet UIImageView *pOneRT;
@property (weak, nonatomic) IBOutlet UIImageView *pOneLB;
@property (weak, nonatomic) IBOutlet UIImageView *pOneRB;
@property (weak, nonatomic) IBOutlet UILabel *pOneTitle;
@property (weak, nonatomic) IBOutlet UILabel *pOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pOneLabelB;


//第二页
@property (weak, nonatomic) IBOutlet UIView *pTwoView;
@property (weak, nonatomic) IBOutlet UIImageView *pTwoMain;
@property (weak, nonatomic) IBOutlet UIImageView *pTwoLT;
@property (weak, nonatomic) IBOutlet UIImageView *pTwoRT;
@property (weak, nonatomic) IBOutlet UIImageView *pTwoRB;

//第三页
@property (weak, nonatomic) IBOutlet UIView *pThreeView;
@property (weak, nonatomic) IBOutlet UIImageView *pThreeMain;
@property (weak, nonatomic) IBOutlet UIImageView *pThreeRB;
@property (weak, nonatomic) IBOutlet UIImageView *pThreeLT;
@property (weak, nonatomic) IBOutlet UIImageView *pThreeRT;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@property (nonatomic, assign) float offsetYForSecondAnimation;
@property (nonatomic, assign) float offsetYForThirdAnimation;


////
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneTitleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneMainTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneMainWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneMainHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneBWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPoneAWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneAHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneCWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cPOneCHeight;
////
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoTitleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoMainTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoMainHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoMainWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoAHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoAWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoBWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoCHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpTwoCWidth;
////
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeTitleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeMainTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeMainHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeMainWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeAHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeAWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeBWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeCWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeCHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpThreeButtonBottom;



////
@property (nonatomic, assign) CGPoint pOneRTCenter;
@property (nonatomic, assign) CGPoint pOneLBCenter;
@property (nonatomic, assign) CGPoint pOneRBCenter;

@property (nonatomic, assign) CGPoint pTwoLTCenter;
@property (nonatomic, assign) CGPoint pTwoRTCenter;
@property (nonatomic, assign) CGPoint pTwoRBCenter;

@property (nonatomic, assign) CGPoint pThreeRBCenter;
@property (nonatomic, assign) CGPoint pThreeLTCenter;
@property (nonatomic, assign) CGPoint pThreeRTCenter;

@property (nonatomic, assign) BOOL didAppear;
@end

@implementation LCGuideVC

- (void)viewDidLoad {
    RLog(@"A view did load");
    [super viewDidLoad];
    
    self.didAppear = NO;
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLayoutSubviews{
    RLog(@"A view did layout subviews");
    if (self.didAppear) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            self.pOneRTCenter = self.pOneRT.center;
            self.pOneLBCenter = self.pOneLB.center;
            self.pOneRBCenter = self.pOneRB.center;
            
            self.pTwoLTCenter = self.pTwoLT.center;
            self.pTwoRTCenter = self.pTwoRT.center;
            self.pTwoRBCenter = self.pTwoRB.center;
            
            self.pThreeRBCenter = self.pThreeRB.center;
            self.pThreeLTCenter = self.pThreeLT.center;
            self.pThreeRTCenter = self.pThreeRT.center;
            
            [self updatePageOne:0];
            [self updatePageTwo:0];
            [self updatePageThree:0];
            
            //self.view.hidden = NO;
            
            [self showPageOneAnimation];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.didAppear = YES;
    
    self.offsetYForSecondAnimation = self.view.frame.size.height/2;
    self.offsetYForThirdAnimation = self.view.frame.size.height/2*3;
    
    //self.view.hidden = YES;
    //如果是小屏，将所有图片、距离，按比例缩小
    if (IS_IPHONE_4_4S || IS_IPHONE_5_5S) {
        [self updateConstraints:@[
                                  //self.cPOneTitleTop,
                                  //self.cPOneMainTop,
                                  //self.cPOneLabelTop,
                                  self.cPOneMainWidth,
                                  self.cPOneMainHeight,
                                  self.cPOneAHeight,
                                  self.cPoneAWidth,
                                  self.cPOneBHeight,
                                  self.cPOneBWidth,
                                  self.cPOneCHeight,
                                  self.cPOneCWidth] toScale:0.85];
        [self updateConstraints:@[
                                  //self.cpTwoTitleTop,
                                  //self.cpTwoMainTop,
                                  //self.cpTwoLabelTop,
                                  self.cpTwoMainWidth,
                                  self.cpTwoMainHeight,
                                  self.cpTwoAHeight,
                                  self.cpTwoAWidth,
                                  self.cpTwoBHeight,
                                  self.cpTwoBWidth,
                                  self.cpTwoCHeight,
                                  self.cpTwoCWidth] toScale:0.85];
        [self updateConstraints:@[
                                  //self.cpThreeTitleTop,
                                  //self.cpThreeMainTop,
                                  //self.cpThreeLabelTop,
                                  self.cpThreeMainWidth,
                                  self.cpThreeMainHeight,
                                  self.cpThreeAHeight,
                                  self.cpThreeAWidth,
                                  self.cpThreeBHeight,
                                  self.cpThreeBWidth,
                                  self.cpThreeCHeight,
                                  self.cpThreeCWidth,
                                  self.cpThreeButtonBottom] toScale:0.85];
        
        if (IS_IPHONE_4_4S) {
            self.cPOneMainTop.constant = 40;
            self.cPOneLabelTop.constant = 40;
            self.cpTwoMainTop.constant = 40;
            self.cpTwoLabelTop.constant = 40;
            self.cpThreeMainTop.constant = 40;
            self.cpThreeLabelTop.constant = 40;
        }
        
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //add circle once
        float pWidth = 5;
        float pHeight = 5;
        float vWidth = self.view.frame.size.width;
        float vHeight = self.view.frame.size.height;
        
        for (int y=5; y<vHeight*3; y+=21) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pWidth, pHeight)];
            iv.image = [UIImage imageNamed:@"GuidePagePoint"];
            [self.scrollContentView addSubview:iv];
            iv.center = CGPointMake(vWidth/2, y);
        }
        
        [self.scrollContentView bringSubviewToFront:self.pOneView];
        [self.scrollContentView bringSubviewToFront:self.pTwoView];
        [self.scrollContentView bringSubviewToFront:self.pThreeView];
        
        
    });
    //self.view.hidden = NO;
}

+ (LCGuideVC *)createInstance{
    return (LCGuideVC *)[LCStoryboardManager viewControllerWithFileName:SBNameGuidePage identifier:VCIDGuideVC];
}

- (IBAction)enterButtonClick:(id)sender {
    [LCDataManager sharedInstance].haveShownGuidePage = YES;
    [[LCSharedFuncUtil getAppContentVC] hideCurrentPageWithAnimation:YES];
}


- (void)updateConstraints:(NSArray *)constraints toScale:(float)scale{
    for (NSLayoutConstraint *c in constraints){
        c.constant *= scale;
    }
}
#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float curOffsetY = scrollView.contentOffset.y;
    float vHeight = self.view.frame.size.height;
    
    if (curOffsetY > vHeight/2 && curOffsetY <= vHeight) {
        [self updatePageTwo:(curOffsetY-vHeight/2)/(vHeight/2)];
    }
    else if(curOffsetY > vHeight/2*3 && curOffsetY <= vHeight*2){
        [self updatePageThree:(curOffsetY-vHeight/2*3)/(vHeight/2)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float curOffsetY = scrollView.contentOffset.y;
    float vHeight = self.view.frame.size.height;
    
    if (curOffsetY<10) {
        //page one
        [self updatePageOne:1];
        [self updatePageTwo:0];
        [self updatePageThree:0];
    }else if(curOffsetY>10 && curOffsetY<vHeight+10){
        //page two
        [self updatePageOne:1];
        [self updatePageTwo:1];
        [self updatePageThree:0];
    }else if(curOffsetY>vHeight+10 && curOffsetY<vHeight*2+10){
        //page three
        [self updatePageOne:1];
        [self updatePageTwo:1];
        [self updatePageThree:1];
    }
}

- (void)showPageOneAnimation{
    float mainImgScaleMax = 1.1;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        self.pOneMain.transform = CGAffineTransformMakeScale(mainImgScaleMax, mainImgScaleMax);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
            self.pOneMain.transform = CGAffineTransformMakeScale(1, 1);
            self.pOneRT.center = CGPointMake(self.pOneRTCenter.x, self.pOneRTCenter.y);
            self.pOneLB.center = CGPointMake(self.pOneLBCenter.x, self.pOneLBCenter.y);
            self.pOneRB.center = CGPointMake(self.pOneRBCenter.x, self.pOneRBCenter.y);
        } completion:nil];
    }];
}
- (void)updatePageOne:(float)animationPercent{
    float phaseOne = 0.8;
    float mainImgScaleMax = 1.1;
    float imgOffsetMax = 200;
    
    float mainImgScale = 1;
    float imgOffset = 0;
    if (animationPercent<phaseOne) {
        mainImgScale = animationPercent/phaseOne*mainImgScaleMax;
        imgOffset = imgOffsetMax;
    }else{
        mainImgScale = mainImgScaleMax-(animationPercent-phaseOne)/(1-phaseOne)*(mainImgScaleMax-1);
        imgOffset = imgOffsetMax-(animationPercent-phaseOne)/(1-phaseOne)*imgOffsetMax;
    }
    //RLog(@"percent:%f,scale:%f,offset:%f",animationPercent,mainImgScale,imgOffset);
    self.pOneMain.transform = CGAffineTransformMakeScale(mainImgScale, mainImgScale);
    self.pOneRT.center = CGPointMake(self.pOneRTCenter.x+imgOffset, self.pOneRTCenter.y);
    self.pOneLB.center = CGPointMake(self.pOneLBCenter.x-imgOffset, self.pOneLBCenter.y);
    self.pOneRB.center = CGPointMake(self.pOneRBCenter.x+imgOffset, self.pOneRBCenter.y);
}
- (void)updatePageTwo:(float)animationPercent{
    float phaseOne = 0.8;
    float mainImgScaleMax = 1.1;
    float imgOffsetMax = 200;
    
    float mainImgScale = 1;
    float imgOffset = 0;
    if (animationPercent<phaseOne) {
        mainImgScale = animationPercent/phaseOne*mainImgScaleMax;
        imgOffset = imgOffsetMax;
    }else{
        mainImgScale = mainImgScaleMax-(animationPercent-phaseOne)/(1-phaseOne)*(mainImgScaleMax-1);
        imgOffset = imgOffsetMax-(animationPercent-phaseOne)/(1-phaseOne)*imgOffsetMax;
    }
    //RLog(@"percent:%f,scale:%f,offset:%f",animationPercent,mainImgScale,imgOffset);
    self.pTwoMain.transform = CGAffineTransformMakeScale(mainImgScale, mainImgScale);
    self.pTwoLT.center = CGPointMake(self.pTwoLTCenter.x-imgOffset, self.pTwoLTCenter.y);
    self.pTwoRB.center = CGPointMake(self.pTwoRBCenter.x+imgOffset, self.pTwoRBCenter.y);
    self.pTwoRT.center = CGPointMake(self.pTwoRTCenter.x+imgOffset, self.pTwoRTCenter.y);
}
- (void)updatePageThree:(float)animationPercent{
    float phaseOne = 0.8;
    float mainImgScaleMax = 1.1;
    float imgOffsetMax = 200;
    
    float mainImgScale = 1;
    float imgOffset = 0;
    if (animationPercent<phaseOne) {
        mainImgScale = animationPercent/phaseOne*mainImgScaleMax;
        imgOffset = imgOffsetMax;
    }else{
        mainImgScale = mainImgScaleMax-(animationPercent-phaseOne)/(1-phaseOne)*(mainImgScaleMax-1);
        imgOffset = imgOffsetMax-(animationPercent-phaseOne)/(1-phaseOne)*imgOffsetMax;
    }
    //RLog(@"percent:%f,scale:%f,offset:%f",animationPercent,mainImgScale,imgOffset);
    self.pThreeMain.transform = CGAffineTransformMakeScale(mainImgScale, mainImgScale);
    self.pThreeRB.center = CGPointMake(self.pThreeRBCenter.x+imgOffset, self.pThreeRBCenter.y);
    self.pThreeLT.center = CGPointMake(self.pThreeLTCenter.x-imgOffset, self.pThreeLTCenter.y);
    self.pThreeRT.center = CGPointMake(self.pThreeRTCenter.x+imgOffset, self.pThreeRTCenter.y);
}
@end
