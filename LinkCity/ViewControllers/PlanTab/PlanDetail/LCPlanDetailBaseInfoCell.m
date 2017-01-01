//
//  LCPlanDetailBaseInfoCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailBaseInfoCell.h"
#import "LCPlanDetailAThemeCell.h"
#import "LCPlanDetailThemeCollectionLayout.h"
#import "LCRouteThemeModel.h"
#import "LCPlanDetailADestCell.h"

@interface LCPlanDetailBaseInfoCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *memberAvatarButtons;

@property (nonatomic, strong) NSArray *destArray;   // array of nsstring
@end


static NSString *const reuseID_PlanDetailAThemeCell = @"PlanDetailAThemeCell";
@implementation LCPlanDetailBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *topBgImage = [UIImage imageNamed:LCCellTopBg];
    topBgImage = [topBgImage resizableImageWithCapInsets:LCCellTopBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.topBg.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:LCCellBottomBg];
    bottomImage = [bottomImage resizableImageWithCapInsets:LCCellBottomBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.bottomBg.image = bottomImage;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.createrAvatarImageView addGestureRecognizer:tapGesture];
    
    [self.imageButtonOne addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageButtonTwo addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageButtonThree addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat memberViewWidth = DEVICE_WIDTH - 10*2 - 12 - 64 - 12;
    CGFloat memberAvatarButtonNum = 6;
    CGFloat memberAvatarWidth = 32;
    CGFloat memberAvatarGap = (memberViewWidth - memberAvatarButtonNum * memberAvatarWidth) / (memberAvatarButtonNum-1);
    self.memberAvatarButtons = [[NSMutableArray alloc] init];
    for (int i=0; i<memberAvatarButtonNum; i++){
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.layer.cornerRadius = memberAvatarWidth/2.0f;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(memberAvatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.memberView addSubview:btn];
        
        [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:memberAvatarWidth]];
        [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:memberAvatarWidth]];
        [self.memberView addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.memberView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1
                                                                     constant:0]];
        [self.memberView addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.memberView
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1
                                                                     constant:(i*memberAvatarWidth+i*memberAvatarGap)]];
        
        [self.memberAvatarButtons addObject:btn];
    }
    
    self.themeCollectionView.delegate = self;
    self.themeCollectionView.dataSource = self;
    self.themeCollectionView.scrollEnabled = NO;
    self.themeCollectionView.collectionViewLayout = [[LCPlanDetailThemeCollectionLayout alloc] init];
    
    self.destinationCollectionView.delegate = self;
    self.destinationCollectionView.dataSource = self;
    self.destinationCollectionView.scrollEnabled = NO;
    self.destinationCollectionView.collectionViewLayout = [[LCPlanDetailThemeCollectionLayout alloc] init];
}


- (void)setPlan:(LCPlanModel *)plan{
    [super setPlan:plan];
    self.destArray = [LCPlanDetailBaseInfoCell getDestStringArrayOfPlan:plan];
    
    
    [self updateShow];
}


- (void)didTap:(UITapGestureRecognizer *)sender{
    if (sender.view == self.createrAvatarImageView) {
        // tap the creater avatar
        if ([self.delegate respondsToSelector:@selector(planDetailBaseInfoCellDidRequestToViewCreaterDetail:)]) {
            [self.delegate planDetailBaseInfoCellDidRequestToViewCreaterDetail:self];
        }
    }
}
- (void)imageButtonAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(planDetailBaseInfoCell:didClickImageIndex:)]) {
        if (sender == self.imageButtonOne) {
            [self.delegate planDetailBaseInfoCell:self didClickImageIndex:0];
        }else if(sender == self.imageButtonTwo){
            [self.delegate planDetailBaseInfoCell:self didClickImageIndex:1];
        }else if(sender == self.imageButtonThree){
            [self.delegate planDetailBaseInfoCell:self didClickImageIndex:2];
        }
    }
}

- (void)memberAvatarButtonAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(planDetailBaseInfoCell:didClickMemberIndex:)]) {
        [self.delegate planDetailBaseInfoCell:self didClickMemberIndex:sender.tag];
    }
}

- (IBAction)memberDetailButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(planDetailBaseInfoCellDidRequestToViewMemberDetail:)]) {
        [self.delegate planDetailBaseInfoCellDidRequestToViewMemberDetail:self];
    }
}



- (void)updateShow{
    [self.destinationCollectionView reloadData];
    [self.themeCollectionView reloadData];
    
    if (self.plan.memberList && self.plan.memberList.count>0) {
        LCUserModel *creater = [self.plan.memberList firstObject];
        [self.createrAvatarImageView setImageWithURL:[NSURL URLWithString:creater.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.createrNameLabel.text = creater.nick;
        self.createrAgeLabel.text = [creater getUserAgeString];
        
        if (creater.isIdentify == LCIdentityStatus_Done) {
            self.createrIdentifiedIcon.hidden = NO;
        }else{
            self.createrIdentifiedIcon.hidden = YES;
        }
        
        if ([creater getUserSex] == UserSex_Male) {
            self.createrSexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
        }else{
            self.createrSexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
        }
    }
    
    NSString *destinationString = [LCPlanDetailBaseInfoCell getDestinationStringOfPlan:self.plan];
    [self.destinationLabel setText:destinationString withLineSpace:LCTextFieldLineSpace];
    CGRect frame = self.destinationLabel.frame;
    CGSize rightSize = [self.destinationLabel sizeThatFits:CGSizeMake((DEVICE_WIDTH-20-100-12), 0)];
    frame.size = rightSize;
    self.destinationLabel.frame = frame;
    
    self.destinationCollectionViewHeight.constant = [LCPlanDetailBaseInfoCell getDestinationCollectionViewHeightForPlan:self.plan];
    
    
    self.topBgHeight.constant = [LCPlanDetailBaseInfoCell getTopBgHeightOfPlan:self.plan];
    
    self.timeLabel.text = [[self.plan getPlanTimeString] stringByAppendingString:@"天"];
    
    if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
        
        self.priceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@/人",self.plan.costPrice];
    }else{
        self.priceLabel.hidden = YES;
    }
    
    if (self.plan.isProvideCar) {
        self.serviceIcon.hidden = NO;
        self.serviceIcon.image = [UIImage imageNamed:@"ServiceCarIcon"];
    }else if(self.plan.isProvideTourGuide){
        self.serviceIcon.hidden = NO;
        self.serviceIcon.image = [UIImage imageNamed:@"ServiceLeadIcon"];
    }else{
        self.serviceIcon.hidden = YES;
    }
    
    if (self.plan.tourThemes && self.plan.tourThemes.count>0) {
        self.themeTitleLabel.hidden = NO;
        self.themeCollectionView.hidden = NO;
        self.themeBottomLine.hidden = NO;
        
        [self.themeCollectionView reloadData];
        self.themeCollectionViewHeight.constant = [LCPlanDetailBaseInfoCell getThemeCollectionViewHeightForPlan:self.plan];
        self.themeBottomLineTop.constant = 0;
    }else{
        self.themeTitleLabel.hidden = YES;
        self.themeCollectionView.hidden = YES;
        self.themeBottomLine.hidden = YES;
        
        self.themeCollectionViewHeight.constant = 0;
        self.themeBottomLineTop.constant = -10;
    }
    
    if (self.plan.isNeedIdentity) {
        self.joinNeedIdentifiyIcon.hidden = NO;
        self.planDescriptionTop.constant = 35;
    }else{
        self.joinNeedIdentifiyIcon.hidden = YES;
        self.planDescriptionTop.constant = 10;
    }
    
    [self.planDescriptionLabel setText:self.plan.descriptionStr withLineSpace:LCTextFieldLineSpace];
    
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoThumbUrl]) {
        self.imageButtonOne.hidden = NO;
        [self.imageButtonOne setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        self.imageButtonOne.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoThumbUrl]) {
        self.imageButtonTwo.hidden = NO;
        [self.imageButtonTwo setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.plan.secondPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        self.imageButtonTwo.hidden = YES;
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoThumbUrl]) {
        self.imageButtonThree.hidden = NO;
        [self.imageButtonThree setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.plan.thirdPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }else{
        self.imageButtonThree.hidden = YES;
    }
    
    for (int i=0; i<self.memberAvatarButtons.count; i++){
        UIButton *btn = (UIButton *)[self.memberAvatarButtons objectAtIndex:i];
        
        if (self.plan.memberList.count > i) {
            btn.hidden = NO;
            LCUserModel *member = [self.plan.memberList objectAtIndex:i];
            [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:member.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        }else{
            btn.hidden = YES;
        }
    }
    
    self.memberCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[self.plan getCurPlanTotalOrderNumber],(long)self.plan.scaleMax];
    
    if ([LCStringUtil isNotNullString:self.plan.publishPlace]) {
        self.locationImageView.hidden = NO;
        self.locationLabel.hidden = NO;
        self.locationLabel.text = [NSString stringWithFormat:@"我在 %@",self.plan.publishPlace];
    }else{
        self.locationImageView.hidden = YES;
        self.locationLabel.hidden = YES;;
    }
    
    NSString *str = @"";
    if (self.plan.browseNumber > 9999) {
        str = @"9999+";
    }else{
        str = [NSString stringWithFormat:@"%ld",(long)self.plan.browseNumber];
    }
    self.scanNumLabel.text = str;
    
    if (self.plan.commentNumber > 9999) {
        str = @"9999+";
    }else{
        str = [NSString stringWithFormat:@"%ld",(long)self.plan.commentNumber];
    }
    self.commentNumLabel.text = str;
    
    /*
     Roy 2015.9.17
     为了适配IOS9，在collectionView layoutIfNeeded之后，再更新每一个cell的布局
     */
    [self setNeedsLayout];
    [self layoutIfNeeded];
    for (UICollectionViewCell *c in [self.destinationCollectionView visibleCells]){
        [c setNeedsLayout];
        [c layoutIfNeeded];
    }
    for (UICollectionViewCell *c in [self.themeCollectionView visibleCells]){
        [c setNeedsLayout];
        [c layoutIfNeeded];
    }
}


#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger num = 0;
    
    if (collectionView == self.destinationCollectionView) {
        num = self.destArray.count;
    }else if(collectionView == self.themeCollectionView) {
        if (self.plan.tourThemes) {
            num = self.plan.tourThemes.count;
        }else{
            num = 0;
        }
    }
    
    return num;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    
    if (collectionView == self.destinationCollectionView) {
        LCPlanDetailADestCell *destCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCPlanDetailADestCell class]) forIndexPath:indexPath];
        [destCell updateShowWithDes:[self.destArray objectAtIndex:indexPath.item] isArrow:(indexPath.item == 1) isDash:(indexPath.item%2 == 1)];
        cell = destCell;
    }else if(collectionView == self.themeCollectionView) {
        LCRouteThemeModel *aTheme = [self.plan.tourThemes objectAtIndex:indexPath.item];
        LCPlanDetailAThemeCell *themeCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID_PlanDetailAThemeCell forIndexPath:indexPath];
        themeCell.themeLabel.text = aTheme.title;
        cell = themeCell;
    }
    
    return cell;
}
#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.destinationCollectionView) {
        if (indexPath.item % 2 == 0) {
            NSString *destStr = [self.destArray objectAtIndex:indexPath.item];
            if ([self.delegate respondsToSelector:@selector(planDetailBaseInfoCell:didClickDest:isDepart:)]) {
                [self.delegate planDetailBaseInfoCell:self didClickDest:destStr isDepart:(indexPath.item == 0)];
            }
        }
    }else if(collectionView == self.themeCollectionView) {
        if (self.plan.tourThemes.count > indexPath.row) {
            LCRouteThemeModel *theme = [self.plan.tourThemes objectAtIndex:indexPath.row];
            if ([self.delegate respondsToSelector:@selector(planDetailBaseInfoCell:didClickTheme:)]) {
                [self.delegate planDetailBaseInfoCell:self didClickTheme:theme];
            }
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = CGSizeMake(0, 0);
    
    if (collectionView == self.destinationCollectionView) {
        //不然目的地过长时，会导致一个Cell就超过整个collectionView的宽度
        CGFloat maxWidth = collectionView.frame.size.width - 10;
        
        cellSize = [LCPlanDetailADestCell sizeOfADestCell:[self.destArray objectAtIndex:indexPath.item] isArrow:(indexPath.item == 1) isDash:(indexPath.item%2 == 1)];
        cellSize.width = MIN(cellSize.width, maxWidth);
    }else if(collectionView == self.themeCollectionView) {
        LCRouteThemeModel *aTheme = [self.plan.tourThemes objectAtIndex:indexPath.item];
        cellSize = [LCPlanDetailAThemeCell sizeOfAThemeCell:aTheme];
    }
    
    LCLogInfo(@"sizeForItemAtIndexPath size is : %@",NSStringFromCGSize(cellSize));
    
    return cellSize;
}

+ (CGFloat)getCellHeightOfPlan:(LCPlanModel *)plan{
    CGFloat height = 0;   //top
    height += 40 + [LCPlanDetailBaseInfoCell getDestinationCollectionViewHeightForPlan:plan] + 40;
    
//    LCLogInfo(@"getTopBgHeightOfPlan:%f",height);
    if (plan.tourThemes && plan.tourThemes.count>0) {
        height += [LCPlanDetailBaseInfoCell getThemeCollectionViewHeightForPlan:plan];
    }else{
        height += 0;
    }
    height += 10;   // top margin
    
//    LCLogInfo(@"heightWithTheme:%f",height);
    if (plan.isNeedIdentity) {
        height += 35;
    }else{
        height += 10;
    }
    
    CGFloat planDescriptionHeight = [LCStringUtil getHeightOfString:plan.descriptionStr
                                                           withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                                          lineSpace:LCTextFieldLineSpace
                                                         labelWidth:DEVICE_WIDTH-10-12-12-10];
    height += planDescriptionHeight+10;    //邀约描述
    
//    LCLogInfo(@"planDescriptionHeight:%f",planDescriptionHeight);
    height += ((DEVICE_WIDTH-20)*0.33-10) / 216 * 172;   //图片高
    
//    LCLogInfo(@"picHeight:%f",((DEVICE_WIDTH-20)*0.33-10) / 216 * 172);
    height += 10;   // pic top margin
    
    height += 120;  //  below part
    
    height += 5;    // cell below margin
    
//    LCLogInfo(@"height:%f",height);
    
    return height;
}

#pragma mark Inner Func
+ (NSString *)getDestinationStringOfPlan:(LCPlanModel *)plan{
    NSString *destinationString = @"";
    
    if ([LCStringUtil isNullString:plan.departName]) {
        destinationString = [destinationString stringByAppendingString:@"目的地: "];
    }else{
        destinationString = [destinationString stringByAppendingString:plan.departName];
        destinationString = [destinationString stringByAppendingString:@"出发——"];
    }
    destinationString = [destinationString stringByAppendingString:[plan getDestinationsStringWithSeparator:@"-"]];
    return destinationString;
}
+ (CGFloat)getTopBgHeightOfPlan:(LCPlanModel *)plan{
    NSString *destinationString = [LCPlanDetailBaseInfoCell getDestinationStringOfPlan:plan];
    CGFloat height = 84 + [LCStringUtil getHeightOfString:destinationString withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:16] lineSpace:LCTextFieldLineSpace labelWidth:(DEVICE_WIDTH-20-100-12)];
    
    LCLogInfo(@"getTopBgHeightOfPlan %f",height);
    return height;
}

+ (NSArray *)getDestStringArrayOfPlan:(LCPlanModel *)plan{
    NSMutableArray *destArray = [NSMutableArray arrayWithArray:plan.destinationNames];
    if ([LCStringUtil isNotNullString:plan.departName]) {
        [destArray insertObject:plan.departName atIndex:0];
    }
    
    NSMutableArray *destArrayWithArrow = [NSMutableArray new];
    for (NSString *dest in destArray){
        [destArrayWithArrow addObject:dest];
        [destArrayWithArrow addObject:@"-"];
    }
    [destArrayWithArrow removeLastObject];
    
    return destArrayWithArrow;
}

+ (CGFloat)getThemeCollectionViewHeightForPlan:(LCPlanModel *)plan{
    CGFloat themeCollectionViewWidth = DEVICE_WIDTH - 20 - 75 - 12;
    CGFloat tempWidth = 0;
    CGFloat rowNum = 0;
    if (plan.tourThemes && plan.tourThemes.count>0) {
        rowNum = 1;
        for (LCRouteThemeModel *aTheme in plan.tourThemes){
            CGSize cellSize = [LCPlanDetailAThemeCell sizeOfAThemeCell:aTheme];
            tempWidth += cellSize.width;
            if (tempWidth > themeCollectionViewWidth) {
                //换行
                tempWidth = cellSize.width;
                rowNum ++;
            }
        }
    }
    CGFloat themeCollectionViewHeight = rowNum * [LCPlanDetailAThemeCell heightOfAThemeCell];
    
    if (plan.tourThemes && plan.tourThemes.count>0) {
        themeCollectionViewHeight += 10;    //collection view 比内容高出10，用于bottomline和collectionview中间的边界
    }
    
    return themeCollectionViewHeight;
}

+ (CGFloat)getDestinationCollectionViewHeightForPlan:(LCPlanModel *)plan{
    NSArray *destArray = [LCPlanDetailBaseInfoCell getDestStringArrayOfPlan:plan];
    
    CGFloat destCollectionViewWidth = DEVICE_WIDTH - 20 - 90 - 0;
    CGFloat tempWidth = 0;
    CGFloat rowNum = 0;
    NSInteger destIndex = 0;
    if (destArray.count>0) {
        rowNum = 1;
        for (NSString *aDest in destArray){
            CGSize cellSize = [LCPlanDetailADestCell sizeOfADestCell:aDest isArrow:(destIndex == 1) isDash:(destIndex%2 == 1)];
            tempWidth += cellSize.width;
            if (tempWidth > destCollectionViewWidth) {
                //换行
                tempWidth = cellSize.width;
                rowNum ++;
            }
            
            destIndex++;
        }
    }
    CGFloat destCollectionViewHeight = rowNum * [LCPlanDetailADestCell heightOfADestCell];
    
    return destCollectionViewHeight;
}

@end
