//
//  LCTextThreePhotosCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCTextThreePhotosCell.h"
#import "LCSendPlanTagView.h"

static const CGFloat leftMargin = 12.0f;
static const CGFloat topMargin = 10.0f;
static const CGFloat leftMarginInset = 15.0f;
static const CGFloat topMarginInset = 12.0f;
static const CGFloat tagHeight = 28.0f;
@interface LCTextThreePhotosCell()
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@end

@implementation LCTextThreePhotosCell

- (void)awakeFromNib {
    self.textDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.textDescLabel.numberOfLines = 0;
    _tagViewArray = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initTagView {
    for (LCRouteThemeModel *item in self.tagItemArray) {
        LCSendPlanTagView * view = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 0, tagHeight) isFixedFrame:NO titleString:item.title];
        [self.tagViewArray addObject:view];
    }
}

- (void)layoutTagViewArray {
    CGFloat offsetX = leftMargin;
    CGFloat offsetY = topMargin;
    
    NSInteger itemCount = 0;
    
    for (LCSendPlanTagView * view in self.tagViewArray) {
        itemCount += 1;
        
        if ((offsetX + view.frame.size.width) >  (DEVICE_WIDTH - leftMargin)) {
            offsetX = leftMargin;
            offsetY += topMarginInset;
            offsetY += tagHeight;
        }
        if (itemCount == self.tagViewArray.count) {
            self.tagViewHeight.constant = (offsetY + topMargin + tagHeight);
        }
        view.frame = CGRectMake(offsetX, offsetY, view.frame.size.width, view.frame.size.height);
        offsetX += view.frame.size.width;
        offsetX += leftMarginInset;
        [self.tagView addSubview:view];
    }

}

- (void)updateShowTextThreePhotos:(LCPlanModel *)plan {
    self.plan = plan;
    if ([LCStringUtil isNotNullString:plan.firstPhotoThumbUrl]) {
        self.firstImageView.hidden = NO;
        self.firstImageButton.hidden = NO;
        [self.firstImageView setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.firstImageView.hidden = YES;
        self.firstImageButton.hidden = YES;
    }

    if ([LCStringUtil isNotNullString:plan.secondPhotoThumbUrl]) {
        self.secondImageButton.hidden = NO;
        self.secondImageView.hidden = NO;
        [self.secondImageView setImageWithURL:[NSURL URLWithString:self.plan.secondPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.secondImageButton.hidden = YES;
        self.secondImageView.hidden = YES;
    }
    
    if ([LCStringUtil isNotNullString:plan.thirdPhotoThumbUrl]) {
        self.thirdImageButton.hidden = NO;
        self.thirdImageView.hidden = NO;
        [self.thirdImageView setImageWithURL:[NSURL URLWithString:self.plan.thirdPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    } else {
        self.thirdImageButton.hidden = YES;
        self.thirdImageView.hidden = NO;
    }
    
    self.textDescLabel.text = plan.descriptionStr;
    if (nil == self.tagViewArray || 0 == self.tagViewArray.count) {
        self.tagItemArray = plan.showThemeArr;
        [self initTagView];
    }
    if (plan.showThemeArr && plan.showThemeArr.count > 0) {
        [self layoutTagViewArray];
        self.tagViewHeight.constant = 43;
        self.tagView.hidden = NO;
    } else {
        self.tagViewHeight.constant = 5;
        self.tagView.hidden = YES;
    }
    
    if (plan.publishPlace && plan.publishPlace.length > 0) {
        self.locationCityLabel.text = plan.publishPlace;
        self.locationCityLabel.hidden = NO;
        self.toupicLocationIcon.hidden = NO;
        self.bottomViewHeight.constant = 30.0f;
    } else {
        self.locationCityLabel.hidden = YES;
        self.toupicLocationIcon.hidden = YES;
        self.bottomViewHeight.constant = 10;
    }
    
}

- (IBAction)imageBtnAction:(id)sender {
    [MobClick event:Mob_PlanList_Image];
    
    NSInteger btnIndex = 0;
    if (sender == self.firstImageButton) {
        btnIndex = 0;
    } else if(sender == self.secondImageButton) {
        btnIndex = 1;
    } else if(sender == self.thirdImageButton) {
        btnIndex = 2;
    }
    
    NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
    if ([LCStringUtil isNotNullString:self.plan.firstPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.firstPhotoUrl;
        imageModel.imageUrlThumb = self.plan.firstPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    if ([LCStringUtil isNotNullString:self.plan.secondPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.secondPhotoUrl;
        imageModel.imageUrlThumb = self.plan.secondPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    if ([LCStringUtil isNotNullString:self.plan.thirdPhotoUrl]) {
        LCImageModel *imageModel = [[LCImageModel alloc] init];
        imageModel.imageUrl = self.plan.thirdPhotoUrl;
        imageModel.imageUrlThumb = self.plan.thirdPhotoThumbUrl;
        [imageModels addObject:imageModel];
    }
    
    if (imageModels.count > btnIndex) {
        LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
        [photoScanner showImageModels:imageModels fromIndex:btnIndex];
        [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
    }
    
}

@end
