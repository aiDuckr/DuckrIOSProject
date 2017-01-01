//
//  LCSendFreePlanImageTopCell.m
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendFreePlanImageAndDescCell.h"
#import "LCPickMultiImageHelper.h"
#import "LCImageUnit.h"

#define EMPTY_IMAGE [[UIImage alloc]init]
#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"ToupicAddPicIcon"]
static const int Max_Pick_Image_Count = 3;


@interface LCSendFreePlanImageAndDescCell()<UIActionSheetDelegate>
@property (nonatomic, strong) UIButton *justClickedButton;

@end


@implementation LCSendFreePlanImageAndDescCell

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCSendFreePlanImageAndDescCell class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCSendFreePlanImageAndDescCell class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCSendFreePlanImageAndDescCell *)v;
        }
    }
    
    return nil;
}

- (void)awakeFromNib {
    self.uploadingImageNum = 0;
    
    [self.imgBtnA addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtnB addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtnC addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.imgBtnB.hidden = YES;
    self.imgBtnC.hidden = YES;
    self.photoHeight.constant = (DEVICE_WIDTH - 30) / 3;
    //self.descTextView.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithPlan:(LCPlanModel *)plan{
    self.plan = plan;
    
    [self initImageUnits];
    [self updateImgBtnAppearance];
    
   
}


- (void)imageBtnAction:(UIButton *)sender{
    [MobClick event:Mob_PublishPlanB_AddImage];
    
    self.justClickedButton = sender;
    if (sender == self.imgBtnA) {
        if ([self haveImageAtIndex:0]) {
            // already have image, show delete action
            [self showDeletePicActionSheet];
        }else{
            // doesn't have image, show select photo view
            [self showImagePickerView];
        }
    }else if (sender == self.imgBtnB){
        if ([self haveImageAtIndex:1]) {
            // already have image, show delete action
            [self showDeletePicActionSheet];
        }else{
            // doesn't have image, show select photo view
            [self showImagePickerView];
        }
    }else if (sender == self.imgBtnC){
        if ([self haveImageAtIndex:2]) {
            // already have image, show delete action
            [self showDeletePicActionSheet];
        }else{
            // doesn't have image, show select photo view
            [self showImagePickerView];
        }
    }
}

- (void)initImageUnits{
    if (!self.plan.imageUnits) {
        self.plan.imageUnits = [[NSMutableArray alloc] init];
        
        if (self.plan && self.plan.photoUrls && self.plan.photoUrls.count > 0) {
            for (NSString *photoUrl in self.plan.photoUrls)
             [self.plan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:photoUrl thumbUrl:nil image:nil]];
        }
//        if (self.plan && [LCStringUtil isNotNullString:self.plan.firstPhotoUrl]) {
//            [self.plan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:self.plan.firstPhotoUrl thumbUrl:self.plan.firstPhotoThumbUrl image:nil]];
//        }
//        if (self.plan && [LCStringUtil isNotNullString:self.plan.secondPhotoUrl]) {
//            [self.plan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:self.plan.secondPhotoUrl thumbUrl:self.plan.secondPhotoThumbUrl image:nil]];
//        }
//        if (self.plan && [LCStringUtil isNotNullString:self.plan.thirdPhotoUrl]) {
//            [self.plan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:self.plan.thirdPhotoUrl thumbUrl:self.plan.thirdPhotoThumbUrl image:nil]];
//        }
    }
}

- (void)updateImgBtnAppearance{
    if ([self haveImageAtIndex:0]) {
        self.imgBtnA.hidden = NO;
        self.imgBtnA.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self setImageAtIndex:0 toButton:self.imgBtnA];
    }else{
        self.imgBtnA.hidden = NO;
        self.imgBtnA.imageView.contentMode = UIViewContentModeCenter;
        [self.imgBtnA setImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
    }
    
    if ([self haveImageAtIndex:1]) {
        self.imgBtnB.hidden = NO;
        self.imgBtnB.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self setImageAtIndex:1 toButton:self.imgBtnB];
    }else{
        self.imgBtnB.imageView.contentMode = UIViewContentModeCenter;
        if ([self haveImageAtIndex:0]) {
            self.imgBtnB.hidden = NO;
            [self.imgBtnB setImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
        }else{
            self.imgBtnB.hidden = YES;
        }
    }
    
    if ([self haveImageAtIndex:2]) {
        self.imgBtnC.hidden = NO;
        self.imgBtnC.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self setImageAtIndex:2 toButton:self.imgBtnC];
    }else{
        self.imgBtnC.imageView.contentMode = UIViewContentModeCenter;
        if ([self haveImageAtIndex:1]) {
            self.imgBtnC.hidden = NO;
            [self.imgBtnC setImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
        }else{
            self.imgBtnC.hidden = YES;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(sendFreePlanImageAndDescCellDidUpdateImage:)]) {
        [self.delegate sendFreePlanImageAndDescCellDidUpdateImage:self];
    }
}

- (void)setImageAtIndex:(NSInteger)index toButton:(UIButton *)btn{
    if (self.plan.imageUnits.count > index) {
        LCImageUnit *unit = [self.plan.imageUnits objectAtIndex:index];
        if (unit.image) {
            [btn setImage:unit.image forState:UIControlStateNormal];
        }else{
            [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:unit.url] placeholderImage:EMPTY_IMAGE];
        }
    }
}

- (BOOL)haveImageAtIndex:(NSInteger)index{
    return self.plan.imageUnits.count > index;
}

- (NSInteger)remainingImageCount{
    return Max_Pick_Image_Count - self.plan.imageUnits.count;
}

#pragma mark UITextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.plan.descriptionStr = [LCStringUtil trimSpaceAndEnter:textView.text];
    
    if ([self.delegate respondsToSelector:@selector(sendFreePlanImageAndDescCellDidEndInputDescription:)]) {
        [self.delegate sendFreePlanImageAndDescCellDidEndInputDescription:self];
    }
}

#pragma mark - ActionSheet
- (void)showDeletePicActionSheet{
    UIActionSheet *pickImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
    [pickImageSheet showInView:[UIApplication sharedApplication].delegate.window];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
        }
    }
}

- (UIViewController *)viewController {
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // delete pic
        if (self.justClickedButton == self.imgBtnA) {
            [self.plan.imageUnits removeObjectAtIndex:0];
        }else if (self.justClickedButton == self.imgBtnB) {
            [self.plan.imageUnits removeObjectAtIndex:1];
        }else if (self.justClickedButton == self.imgBtnC) {
            [self.plan.imageUnits removeObjectAtIndex:2];
        }
    }else{
        // cancel
    }
    
    [self updateImgBtnAppearance];
}


#pragma mark - Assets Picker
- (void)showImagePickerView{
    if (!self.plan.imageUnits) {
        self.plan.imageUnits = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:[self remainingImageCount] completion:^(NSArray *pickedImageArray) {
        for (UIImage *img in pickedImageArray){
            [self.plan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:nil thumbUrl:nil image:img]];
        }
        [self updateImgBtnAppearance];
        [self startUploadImage];
    }];
}

#pragma mark - Deal with upload Pic
- (void)startUploadImage{
    //异步上传图片
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       //对每个有Asset，但没有URL的图片，进行上传
                       [self.plan.imageUnits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                           LCImageUnit *unit = (LCImageUnit *)obj;
                           if ([LCStringUtil isNullString:unit.url] && unit.image) {
                               
                               weakSelf.uploadingImageNum ++;
                               [LCImageUtil compressImagesWithData:@[unit.image] complete:^(NSArray *compressArray){
                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                                       NSData *imgData = [compressArray objectAtIndex:0];
                                        [LCImageUtil uploadImageDataToQinu:imgData imageType:ImageCategoryPlan completion:^(NSString *imgUrl) {
                                            weakSelf.uploadingImageNum --;
                                                                          LCLogInfo(@"DiduploadImg uploadingNum:%ld url:%@",(long)weakSelf.uploadingImageNum,imgUrl);
                                       
                                                                          if ([LCStringUtil isNullString:imgUrl]) {
                                                                              //上传图片失败
                                                                              [YSAlertUtil tipOneMessage:@"上传图片失败" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                                                                          }else{
                                                                              unit.url = imgUrl;
                                                                              unit.thumbUrl = [LCImageUtil getThumbImageUrlFromOrigionalImageUrl:imgUrl];
                                                                          }
                                                                          
                                                                          if (weakSelf.uploadingImageNum <= 0) {
                                                                              [weakSelf didFinishUploadImages];
                                                                          }
                                                                      }];
                                   });
                                   
                               }];

//                               // url为空，asset不空， 需要上传图片
//                               self.uploadingImageNum ++;
//                               NSData *imgData = [LCImageUtil getDataOfCompressImage:unit.image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
//                               LCLogInfo(@"UploadImg uploadingNum:%ld, imgSize:%ld",(long)self.uploadingImageNum,(long)[imgData length]);

                           }
                       }];
                   });
}

- (void)didFinishUploadImages{
    if ([self.delegate respondsToSelector:@selector(sendFreePlanImageAndDescCellDidEndUploadImage:)]) {
        [self.delegate sendFreePlanImageAndDescCellDidEndUploadImage:self];
    }
}

@end
