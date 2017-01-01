//
//  LCGuideVCTwo.m
//  LinkCity
//
//  Created by roy on 11/26/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//


/*
 view
 ---scrollView
 ------pagea
 ---------pageaTitle
 ---------pageaDetailA
 ---------pageaDetailB
 ---------pageamain
 ---------pageaa
 ---------pageab
 ---------pageac
 ------pageb
        *
        *
 ------pagec
        *
        *
 
 
 
 
 */
#import "LCGuideVCTwo.h"

@interface LCGuideVCTwo ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *pagea;
@property (nonatomic,strong) UILabel *pageaTitle;
@property (nonatomic,strong) UILabel *pageaDetailA;
@property (nonatomic,strong) UILabel *pageaDetailB;
@property (nonatomic,strong) UIImageView *pageamain;
@property (nonatomic,strong) UIImageView *pageaa;
@property (nonatomic,strong) UIImageView *pageab;
@property (nonatomic,strong) UIImageView *pageac;

@property (nonatomic,strong) UIView *pageb;
@property (nonatomic,strong) UILabel *pagebTitle;
@property (nonatomic,strong) UILabel *pagebDetailA;
@property (nonatomic,strong) UILabel *pagebDetailB;
@property (nonatomic,strong) UIImageView *pagebmain;
@property (nonatomic,strong) UIImageView *pageba;
@property (nonatomic,strong) UIImageView *pagebb;
@property (nonatomic,strong) UIImageView *pagebc;

@property (nonatomic,strong) UIView *pagec;
@property (nonatomic,strong) UILabel *pagecTitle;
@property (nonatomic,strong) UILabel *pagecDetailA;
@property (nonatomic,strong) UILabel *pagecDetailB;
@property (nonatomic,strong) UIImageView *pagecmain;
@property (nonatomic,strong) UIImageView *pageca;
@property (nonatomic,strong) UIImageView *pagecb;
@property (nonatomic,strong) UIImageView *pagecc;
@property (nonatomic,strong) UIButton *enterButton;

//每个view初始显示的位置
//各种动画最终结束时的位置
@property (nonatomic, assign) CGPoint pageaacenter;
@property (nonatomic, assign) CGPoint pageabcenter;
@property (nonatomic, assign) CGPoint pageaccenter;

@property (nonatomic, assign) CGPoint pagebacenter;
@property (nonatomic, assign) CGPoint pagebbcenter;
@property (nonatomic, assign) CGPoint pagebccenter;

@property (nonatomic, assign) CGPoint pagecacenter;
@property (nonatomic, assign) CGPoint pagecbcenter;
@property (nonatomic, assign) CGPoint pagecccenter;
@end


float titleTop = 65;
float mainTop = 280;
float detailaTop = 470;
float detailbTop = 496;
float enterbuttonTop = 570;

CGSize mainSize = {200,200};
CGSize smailSize = {45,45};

//每个小图的中心点，距大图中心点的位置
CGPoint pageaaOffset = {-130,63};
CGPoint pageabOffset = {105,-84};
CGPoint pageacOffset = {110,110};

CGPoint pagebaOffset = {-125,-63};
CGPoint pagebbOffset = {120,-90};
CGPoint pagebcOffset = {91,95};

CGPoint pagecaOffset = {-120,-64};
CGPoint pagecbOffset = {115,-94};
CGPoint pageccOffset = {105,88};


@implementation LCGuideVCTwo

+ (instancetype)createInstance{
    return [[LCGuideVCTwo alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配不同屏幕的大小
    if (IS_IPHONE_4_4S || IS_IPHONE_5_5S) {
        float scale = 0.85;
        
        titleTop *= scale;
        mainTop *= scale;
        detailaTop *= scale;
        detailbTop *= scale;
        enterbuttonTop *= scale;
        
        mainSize = [self scaleSize:mainSize scale:scale];
        smailSize = [self scaleSize:smailSize scale:scale];
        
        pageaaOffset = [self scalePoint:pageaaOffset scale:scale];
        pageabOffset = [self scalePoint:pageabOffset scale:scale];
        pageacOffset = [self scalePoint:pageacOffset scale:scale];
        
        pagebaOffset = [self scalePoint:pagebaOffset scale:scale];
        pagebbOffset = [self scalePoint:pagebbOffset scale:scale];
        pagebcOffset = [self scalePoint:pagebcOffset scale:scale];
        
        pagecaOffset = [self scalePoint:pagecaOffset scale:scale];
        pagecbOffset = [self scalePoint:pagecbOffset scale:scale];
        pageccOffset = [self scalePoint:pageccOffset scale:scale];
        
        if (IS_IPHONE_4_4S) {
            mainTop -= 40;
            detailaTop -= 40;
            detailbTop -= 40;
            enterbuttonTop -= 40;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //会触发两次viewWillAppear，所以dispatch once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor whiteColor];
        
        RLog(@"self.view:%@",self.view);
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self.view addSubview:self.scrollView];
        
        CGRect frame;
        frame = self.view.bounds;
        self.pagea = [[UIView alloc]initWithFrame:frame];
        [self.scrollView addSubview:self.pagea];
        
        frame.origin.y = frame.size.height;
        self.pageb = [[UIView alloc]initWithFrame:frame];
        [self.scrollView addSubview:self.pageb];
        
        frame.origin.y = frame.size.height*2;
        self.pagec = [[UIView alloc]initWithFrame:frame];
        [self.scrollView addSubview:self.pagec];
        
        self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height*3);
        
        [self addPageA];
        [self addPageB];
        [self addPageC];
        
        [self addPoints];
        
        [self updatePageA:0];
        [self updatePageB:0];
        [self updatePageC:0];
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self showPageOneAnimation];
}

- (CGSize)scaleSize:(CGSize)s scale:(float)multi{
    return CGSizeMake(s.width*multi, s.height*multi);
}
- (CGPoint)scalePoint:(CGPoint)s scale:(float)multi{
    return CGPointMake(s.x*multi, s.y*multi);
}
#pragma mark - AddViews
- (void)addPoints{
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
            [self.scrollView addSubview:iv];
            iv.center = CGPointMake(vWidth/2, y);
        }
        
        [self.scrollView bringSubviewToFront:self.pagea];
        [self.scrollView bringSubviewToFront:self.pageb];
        [self.scrollView bringSubviewToFront:self.pagec];
    });
}
- (void)addPageA{
    //NSLog(@"**************");
    self.pageamain = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, mainSize.height)];
    self.pageamain.contentMode = UIViewContentModeScaleAspectFill;
    self.pageamain.image = [UIImage imageNamed:@"POneMain"];
    self.pageamain.center = CGPointMake(self.pagea.frame.size.width/2, mainTop);
    [self.pagea addSubview:self.pageamain];
    
    self.pageaa = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pageaa.contentMode = UIViewContentModeScaleAspectFill;
    self.pageaa.image = [UIImage imageNamed:@"POneB"];
    self.pageaa.center = self.pageaacenter = CGPointMake(self.pageamain.center.x+pageaaOffset.x, self.pageamain.center.y+pageaaOffset.y);
    [self.pagea addSubview:self.pageaa];
    
    self.pageab = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pageab.contentMode = UIViewContentModeScaleAspectFill;
    self.pageab.image = [UIImage imageNamed:@"POneA"];
    self.pageab.center = self.pageabcenter = CGPointMake(self.pageamain.center.x+pageabOffset.x, self.pageamain.center.y+pageabOffset.y);
    [self.pagea addSubview:self.pageab];
    
    self.pageac = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pageac.contentMode = UIViewContentModeScaleAspectFill;
    self.pageac.image = [UIImage imageNamed:@"POneC"];
    self.pageac.center = self.pageaccenter = CGPointMake(self.pageamain.center.x+pageacOffset.x, self.pageamain.center.y+pageacOffset.y);
    [self.pagea addSubview:self.pageac];
    
    self.pageaTitle = [[UILabel alloc]init];
    self.pageaTitle.text = @"爱旅行，更爱结伴!";
    self.pageaTitle.font = [UIFont fontWithName:FONT_LANTINGBLACK size:19];
    self.pageaTitle.textColor = UIColorFromR_G_B_A(72, 67, 63, 1);
    [self.pageaTitle sizeToFit];
    self.pageaTitle.backgroundColor = [UIColor whiteColor];
    self.pageaTitle.center = CGPointMake(self.pageamain.center.x, titleTop);
    [self.pagea addSubview:self.pageaTitle];
    
    self.pageaDetailA = [[UILabel alloc]init];
    self.pageaDetailA.text = @"总有人和你走过同样的路，看着同样的风景。";
    self.pageaDetailA.font = [UIFont fontWithName:FONT_LANTINGBLACK size:13];
    self.pageaDetailA.textColor = UIColorFromR_G_B_A(155, 152, 148, 1);
    [self.pageaDetailA sizeToFit];
    self.pageaDetailA.backgroundColor = [UIColor whiteColor];
    self.pageaDetailA.center = CGPointMake(self.pageamain.center.x, detailaTop);
    [self.pagea addSubview:self.pageaDetailA];
    
    self.pageaDetailB = [[UILabel alloc]init];
    self.pageaDetailB.text = @"相约达客，旅途不孤单！";
    self.pageaDetailB.font = [UIFont fontWithName:FONT_LANTINGBLACK size:13];
    self.pageaDetailB.textColor = UIColorFromR_G_B_A(155, 152, 148, 1);
    [self.pageaDetailB sizeToFit];
    self.pageaDetailB.backgroundColor = [UIColor whiteColor];
    self.pageaDetailB.center = CGPointMake(self.pageamain.center.x, detailbTop);
    [self.pagea addSubview:self.pageaDetailB];
}
- (void)addPageB{
    self.pagebmain = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, mainSize.height)];
    self.pagebmain.contentMode = UIViewContentModeScaleAspectFill;
    self.pagebmain.image = [UIImage imageNamed:@"PTwoMain"];
    self.pagebmain.center = CGPointMake(self.pageb.frame.size.width/2, mainTop);
    [self.pageb addSubview:self.pagebmain];
    
    self.pageba = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pageba.contentMode = UIViewContentModeScaleAspectFill;
    self.pageba.image = [UIImage imageNamed:@"PTwoB"];
    self.pageba.center = self.pagebacenter = CGPointMake(self.pagebmain.center.x+pagebaOffset.x, self.pagebmain.center.y+pagebaOffset.y);
    [self.pageb addSubview:self.pageba];
    
    self.pagebb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pagebb.contentMode = UIViewContentModeScaleAspectFill;
    self.pagebb.image = [UIImage imageNamed:@"PTwoC"];
    self.pagebb.center = self.pagebbcenter = CGPointMake(self.pagebmain.center.x+pagebbOffset.x, self.pagebmain.center.y+pagebbOffset.y);
    [self.pageb addSubview:self.pagebb];
    
    self.pagebc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pagebc.contentMode = UIViewContentModeScaleAspectFill;
    self.pagebc.image = [UIImage imageNamed:@"PTwoA"];
    self.pagebc.center = self.pagebccenter = CGPointMake(self.pagebmain.center.x+pagebcOffset.x, self.pagebmain.center.y+pagebcOffset.y);
    [self.pageb addSubview:self.pagebc];
    
    self.pagebTitle = [[UILabel alloc]init];
    self.pagebTitle.text = @"发布约伴计划，聚有缘人!";
    self.pagebTitle.font = [UIFont fontWithName:FONT_LANTINGBLACK size:19];
    self.pagebTitle.textColor = UIColorFromR_G_B_A(72, 67, 63, 1);
    [self.pagebTitle sizeToFit];
    self.pagebTitle.backgroundColor = [UIColor whiteColor];
    self.pagebTitle.center = CGPointMake(self.pagebmain.center.x, titleTop);
    [self.pageb addSubview:self.pagebTitle];
    
    self.pagebDetailA = [[UILabel alloc]init];
    self.pagebDetailA.text = @"发布约伴计划同时生成群组";
    self.pagebDetailA.font = [UIFont fontWithName:FONT_LANTINGBLACK size:13];
    self.pagebDetailA.textColor = UIColorFromR_G_B_A(155, 152, 148, 1);
    [self.pagebDetailA sizeToFit];
    self.pagebDetailA.backgroundColor = [UIColor whiteColor];
    self.pagebDetailA.center = CGPointMake(self.pagebmain.center.x, detailaTop);
    [self.pageb addSubview:self.pagebDetailA];
    
    self.pagebDetailB = [[UILabel alloc]init];
    self.pagebDetailB.text = @"开始一场随缘的结伴旅行！";
    self.pagebDetailB.font = [UIFont fontWithName:FONT_LANTINGBLACK size:13];
    self.pagebDetailB.textColor = UIColorFromR_G_B_A(155, 152, 148, 1);
    [self.pagebDetailB sizeToFit];
    self.pagebDetailB.backgroundColor = [UIColor whiteColor];
    self.pagebDetailB.center = CGPointMake(self.pagebmain.center.x, detailbTop);
    [self.pageb addSubview:self.pagebDetailB];
}
- (void)addPageC{
    self.pagecmain = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, mainSize.height)];
    self.pagecmain.contentMode = UIViewContentModeScaleAspectFill;
    self.pagecmain.image = [UIImage imageNamed:@"PThreeMain"];
    self.pagecmain.center = CGPointMake(self.pagec.frame.size.width/2, mainTop);
    [self.pagec addSubview:self.pagecmain];
    
    self.pageca = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pageca.contentMode = UIViewContentModeScaleAspectFill;
    self.pageca.image = [UIImage imageNamed:@"PThreeC"];
    self.pageca.center = self.pagecacenter = CGPointMake(self.pagecmain.center.x+pagecaOffset.x, self.pagecmain.center.y+pagecaOffset.y);
    [self.pagec addSubview:self.pageca];
    
    self.pagecb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pagecb.contentMode = UIViewContentModeScaleAspectFill;
    self.pagecb.image = [UIImage imageNamed:@"PThreeA"];
    self.pagecb.center = self.pagecbcenter = CGPointMake(self.pagecmain.center.x+pagecbOffset.x, self.pagecmain.center.y+pagecbOffset.y);
    [self.pagec addSubview:self.pagecb];
    
    self.pagecc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, smailSize.width, smailSize.height)];
    self.pagecc.contentMode = UIViewContentModeScaleAspectFill;
    self.pagecc.image = [UIImage imageNamed:@"PThreeB"];
    self.pagecc.center = self.pagecccenter = CGPointMake(self.pagecmain.center.x+pageccOffset.x, self.pagecmain.center.y+pageccOffset.y);
    [self.pagec addSubview:self.pagecc];
    
    self.pagecTitle = [[UILabel alloc]init];
    self.pagecTitle.text = @"有朋自远方来，达客招待!";
    self.pagecTitle.font = [UIFont fontWithName:FONT_LANTINGBLACK size:19];
    self.pagecTitle.textColor = UIColorFromR_G_B_A(72, 67, 63, 1);
    [self.pagecTitle sizeToFit];
    self.pagecTitle.backgroundColor = [UIColor whiteColor];
    self.pagecTitle.center = CGPointMake(self.pagecmain.center.x, titleTop);
    [self.pagec addSubview:self.pagecTitle];
    
    self.pagecDetailA = [[UILabel alloc]init];
    self.pagecDetailA.text = @"发布招待计划同时生成群组";
    self.pagecDetailA.font = [UIFont fontWithName:FONT_LANTINGBLACK size:13];
    self.pagecDetailA.textColor = UIColorFromR_G_B_A(155, 152, 148, 1);
    [self.pagecDetailA sizeToFit];
    self.pagecDetailA.backgroundColor = [UIColor whiteColor];
    self.pagecDetailA.center = CGPointMake(self.pagecmain.center.x, detailaTop);
    [self.pagec addSubview:self.pagecDetailA];
    
    self.pagecDetailB = [[UILabel alloc]init];
    self.pagecDetailB.text = @"尽地主之谊，礼尚往来！";
    self.pagecDetailB.font = [UIFont fontWithName:FONT_LANTINGBLACK size:13];
    self.pagecDetailB.textColor = UIColorFromR_G_B_A(155, 152, 148, 1);
    [self.pagecDetailB sizeToFit];
    self.pagecDetailB.backgroundColor = [UIColor whiteColor];
    self.pagecDetailB.center = CGPointMake(self.pagecmain.center.x, detailbTop);
    [self.pagec addSubview:self.pagecDetailB];
    
    self.enterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 117, 40)];
    [self.enterButton setTitle:@"加入达客!" forState:UIControlStateNormal];
    [self.enterButton setTitleColor:UIColorFromR_G_B_A(72, 67, 63, 1) forState:UIControlStateNormal];
    self.enterButton.titleLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:17];
    self.enterButton.layer.cornerRadius = 20;
    self.enterButton.layer.masksToBounds = YES;
    self.enterButton.backgroundColor = UIColorFromRGBA(DUCKER_YELLOW, 1);
    self.enterButton.center = CGPointMake(self.pagecmain.center.x, enterbuttonTop);
    [self.pagec addSubview:self.enterButton];
    [self.enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)enterButtonAction:(id)sender{
    [LCDataManager sharedInstance].haveShownGuidePage = YES;
    [[LCSharedFuncUtil getAppContentVC] hideCurrentPageWithAnimation:YES];
}
#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float curOffsetY = scrollView.contentOffset.y;
    float vHeight = scrollView.frame.size.height;
    //RLog(@"didScroll curOffsetY:%f, vHeight:%f",curOffsetY,vHeight);
    
    if (curOffsetY > vHeight/2 && curOffsetY <= vHeight) {
        float p = (curOffsetY-vHeight/2)/(vHeight/2);
        //RLog(@"didScroll curOffsetY:%f, vHeight:%f, percent:%f",curOffsetY,vHeight,p);
        [self updatePageB:p];
    }
    else if(curOffsetY > vHeight/2*3 && curOffsetY <= vHeight*2){
        [self updatePageC:(curOffsetY-vHeight/2*3)/(vHeight/2)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float curOffsetY = scrollView.contentOffset.y;
    float vHeight = scrollView.frame.size.height;
    
    if (curOffsetY<10) {
        //page one
        [self updatePageA:1];
        [self updatePageB:0];
        [self updatePageC:0];
    }else if(curOffsetY>10 && curOffsetY<vHeight+10){
        //page two
        [self updatePageA:1];
        [self updatePageB:1];
        [self updatePageC:0];
    }else if(curOffsetY>vHeight+10 && curOffsetY<vHeight*2+10){
        //page three
        [self updatePageA:1];
        [self updatePageB:1];
        [self updatePageC:1];
    }
}

#pragma mark - For Animation
- (void)showPageOneAnimation{
    float mainImgScaleMax = 1.1;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        self.pageamain.transform = CGAffineTransformMakeScale(mainImgScaleMax, mainImgScaleMax);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
            self.pageamain.transform = CGAffineTransformMakeScale(1, 1);
            self.pageaa.center = CGPointMake(self.pageaacenter.x, self.pageaacenter.y);
            self.pageab.center = CGPointMake(self.pageabcenter.x, self.pageabcenter.y);
            self.pageac.center = CGPointMake(self.pageaccenter.x, self.pageaccenter.y);
        } completion:nil];
    }];
}

- (void)updatePageA:(float)animationPercent{
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
    self.pageamain.transform = CGAffineTransformMakeScale(mainImgScale, mainImgScale);
    self.pageaa.center = CGPointMake(self.pageaacenter.x-imgOffset, self.pageaacenter.y);
    self.pageab.center = CGPointMake(self.pageabcenter.x+imgOffset, self.pageabcenter.y);
    self.pageac.center = CGPointMake(self.pageaccenter.x+imgOffset, self.pageaccenter.y);
}
- (void)updatePageB:(float)animationPercent{
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
    //RLog(@"pageB - percent:%f,scale:%f,offset:%f",animationPercent,mainImgScale,imgOffset);
    self.pagebmain.transform = CGAffineTransformMakeScale(mainImgScale, mainImgScale);
    self.pageba.center = CGPointMake(self.pagebacenter.x-imgOffset, self.pagebacenter.y);
    self.pagebb.center = CGPointMake(self.pagebbcenter.x+imgOffset, self.pagebbcenter.y);
    self.pagebc.center = CGPointMake(self.pagebccenter.x+imgOffset, self.pagebccenter.y);
}
- (void)updatePageC:(float)animationPercent{
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
    self.pagecmain.transform = CGAffineTransformMakeScale(mainImgScale, mainImgScale);
    self.pageca.center = CGPointMake(self.pagecacenter.x-imgOffset, self.pagecacenter.y);
    self.pagecb.center = CGPointMake(self.pagecbcenter.x+imgOffset, self.pagecbcenter.y);
    self.pagecc.center = CGPointMake(self.pagecccenter.x+imgOffset, self.pagecccenter.y);
}
@end
