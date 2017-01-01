//
//  LCTourpicBaseView.m
//  LinkCity
//
//  Created by 张宗硕 on 4/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTourpicBaseView.h"
#import "LCOnePicView.h"
#import "LCTwoPicView.h"
#import "LCThreePicView.h"
#import "LCFourPicView.h"
#import "LCFivePicView.h"
#import "LCSixPicView.h"
#import "LCNinePicView.h"
#import "LCOneVideoView.h"

@implementation LCTourpicBaseView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)createInstance:(LCTourpic *)tourpic {
    LCTourpicBaseView *view = [[LCTourpicBaseView alloc] init];
    if (LCTourpicType_Photo == tourpic.type) {
        switch (tourpic.photoNum) {
            case LCTourpicViewType_PicOne:
                view = [LCTourpicBaseView getViewByClassName:[LCOnePicView class]];
                break;
            case LCTourpicViewType_PicTwo:
                view = [LCTourpicBaseView getViewByClassName:[LCTwoPicView class]];
                break;
            case LCTourpicViewType_PicThree:
                view = [LCTourpicBaseView getViewByClassName:[LCThreePicView class]];
                break;
            case LCTourpicViewType_PicFour:
                view = [LCTourpicBaseView getViewByClassName:[LCFourPicView class]];
                break;
            case LCTourpicViewType_PicFive:
                view = [LCTourpicBaseView getViewByClassName:[LCFivePicView class]];
                break;
            case LCTourpicViewType_PicSix:
                view = [LCTourpicBaseView getViewByClassName:[LCSixPicView class]];
                break;
            case LCTourpicViewType_PicSeven:
            case LCTourpicViewType_PicEight:
            case LCTourpicViewType_PicNine:
                view = [LCTourpicBaseView getViewByClassName:[LCNinePicView class]];
                break;
            default:
                view = [[LCTourpicBaseView alloc] init];
                break;
        }
    } else if (LCTourpicType_Video == tourpic.type) {
        if (LCTourpicViewType_PicOne == tourpic.photoNum) {
            view = [LCTourpicBaseView getViewByClassName:[LCOneVideoView class]];
        }
    }
    return view;
}

+ (LCTourpicBaseView *)getViewByClassName:(Class)className {
    UINib *nib = [UINib nibWithNibName:@"TourpicViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    LCTourpicBaseView *view = nil;
    
    for (UIView *v in views) {
        if ([v isKindOfClass:className]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            view = (LCTourpicBaseView *)v;
        }
    }
    return view;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, 186);
}

- (void)updateTourpicView:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type {
    self.tourpic = tourpic;
}

- (void)viewTourpicPhoto:(id)sender {
    UITapGestureRecognizer *tap = sender;
    UIImageView *imageView = (UIImageView*)tap.view;
    NSInteger btnIndex = imageView.tag;
    [MobClick event:Mob_TourPicDetail_Image];
    
    NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < self.tourpic.thumbPhotoUrls.count; ++i) {
        if (i < self.tourpic.photoUrls.count) {
            LCImageModel *imageModel = [[LCImageModel alloc] init];
            imageModel.imageUrl = self.tourpic.photoUrls[i];
            imageModel.imageUrlThumb = self.tourpic.thumbPhotoUrls[i];
            [imageModels addObject:imageModel];
        }
    }
    
    if (imageModels.count > btnIndex) {
        LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
        [photoScanner showImageModels:imageModels fromIndex:btnIndex];
        [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
    }
}

- (void)addImageViewToArray:(NSMutableArray *)mutArr {
    for (int i = 0; i < mutArr.count; i++) {
        UIImageView *imageView = (UIImageView *)[mutArr objectAtIndex:i];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTourpicPhoto:)];
        singleTap.delegate = self;
        [imageView addGestureRecognizer:singleTap];
        
        if (i < self.tourpic.thumbPhotoUrls.count) {
            imageView.hidden = NO;
            NSString *thumbPhotoUrl = [self.tourpic.thumbPhotoUrls objectAtIndex:i];
            [imageView setImageWithURL:[NSURL URLWithString:thumbPhotoUrl] placeholderImage:[UIImage imageNamed:LCDefaultTourpicImageName]];
        } else {
            imageView.hidden = YES;
        }
    }
}

#pragma mark - GestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIImageView class]])
    {
        return YES;
    } else {
        return NO;
        
    }
}
@end
