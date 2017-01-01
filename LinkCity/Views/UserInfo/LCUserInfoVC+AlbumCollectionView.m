//
//  LCUserInfoVC+AlbumCollectionView.m
//  LinkCity
//
//  Created by roy on 11/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoVC.h"

#define ITEMNUM_PER_LINE 3

@implementation LCUserInfoVC (AlbumCollectionView)


- (float)getAlbumCollectionViewContentHeight{
    float lineHeight = self.userAlbumCollectionView.frame.size.width/ITEMNUM_PER_LINE;
    NSInteger lineNumber = [self getCellNumber]/ITEMNUM_PER_LINE;
    if ([self getCellNumber]%ITEMNUM_PER_LINE != 0) {
        lineNumber += 1;
    }
    return lineNumber*lineHeight;
}
- (NSInteger)getPhotoIndexFromCollectionIndexPath:(NSIndexPath *)indexPath{
    if (self.isShowingSelf) {
        return indexPath.section*ITEMNUM_PER_LINE+indexPath.item-1;
    }else{
        return indexPath.section*ITEMNUM_PER_LINE+indexPath.item;
    }
}
/**
 if show to self, cell number is photo.count+1, the 1 for "add photo" button
 if show to other users, cell number is photo.count
 */
- (NSInteger)getCellNumber{
    if (self.isShowingSelf) {
        return self.photos.count+1;
    }else{
        return self.photos.count;
    }
}
#pragma mark - UICollectionView Delegate & Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //有多少行
    NSInteger sectionNum = [self getCellNumber]/ITEMNUM_PER_LINE;
    if ([self getCellNumber]%ITEMNUM_PER_LINE!=0) {
        //如果不整除的话，有cell在下一行
        sectionNum+=1;
    }
    return sectionNum;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float cellSize = collectionView.frame.size.width/ITEMNUM_PER_LINE;
    return CGSizeMake(cellSize,cellSize);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numThisSection = [self getCellNumber]-section*ITEMNUM_PER_LINE;
    return MIN(numThisSection, ITEMNUM_PER_LINE);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCUserInfoPageAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserInfoPageAlbumCell" forIndexPath:indexPath];
    //cell.backgroundColor = UIColorFromR_G_B_A(255, (indexPath.item/20.0*255), 255, 1);
    cell.delegate = self;
    if (self.isShowingSelf && indexPath.section==0 && indexPath.item==0) {
        [cell showAddPhoto];
    }else{
        NSInteger photoIndex = [self getPhotoIndexFromCollectionIndexPath:indexPath];
        if (photoIndex < self.photos.count) {
            [cell showImage:[self.photos objectAtIndex:photoIndex]];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isShowingSelf && indexPath.section==0 && indexPath.item==0) {
        RLog(@"add photo");
        [self showAddPhotoActionSheet];
    }else{
        RLog(@"show photo");
        LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
        [photoScanner showImageModels:self.photos fromIndex:[self getPhotoIndexFromCollectionIndexPath:indexPath]];
        [self presentViewController:photoScanner animated:YES completion:nil];
    }
}

#pragma mark - LCUserInfoPageAlbumCell Delegate
- (void)userInfoPageAlbumCellDidLongPressed:(LCUserInfoPageAlbumCell *)cell{
    RLog(@"long pressed");
    self.selectedIndexPath = [self.userAlbumCollectionView indexPathForCell:cell];
    if (self.isShowingSelf &&
        !(self.selectedIndexPath.section==0 && self.selectedIndexPath.item==0))
    {
        //如果正在看自己的页面，并且点的不是第一个cell(添加照片)，则删除照片
        [self showDeletePhotoActionSheet];
    }else{
        
    }
}


- (void)showDeletePhotoActionSheet{
    if (!self.deletePhotoActionSheet) {
        self.deletePhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
    }
    [self.deletePhotoActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)showAddPhotoActionSheet{
    if (!self.addPhotoActionSheet) {
        self.addPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"拍照", @"从相册中选取", nil];
    }
    [self.addPhotoActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheet Delegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = 0;
    if (actionSheet == self.addPhotoActionSheet) {
        if (buttonIndex == index)
        {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.delegate = self;
            [[self viewController] presentViewController:controller
                                                animated:YES
                                              completion:nil];
        }else if (buttonIndex == index + 1){
            // 从相册中选取
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.delegate = self;
            [[self viewController] presentViewController:controller
                                                animated:YES
                                              completion:nil];
        }
    }else if(actionSheet == self.deletePhotoActionSheet){
        if (buttonIndex == index)
        {
            //删除选中图片
            LCImageModel *selectedImage = [self.photos objectAtIndex:[self getPhotoIndexFromCollectionIndexPath:self.selectedIndexPath]];
            [self deleteImageFromUserAlbum:selectedImage.imageUrlMD5];
        }
    }
}
#pragma mark - ImagePickerController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self viewController] dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([LCStringUtil isNotNullString:mediaType] && [mediaType isEqualToString:@"public.image"])
    {
        self.preprocessedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        /**
         Roy 2015.1.9
         不再压缩尺寸了，只压缩图片质量
         */
        //self.preprocessedImage = [LCImageUtil scaleImage:self.preprocessedImage toScale:SCALE_VALUE];
        //processedImage = [LCImageUtil getCenterImage:preprocessedImage withRect:self.frame];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.imageType = PIC_JPG_TYPE;
            // 将图片转换为JPG格式的二进制数据
            ZLog(@"come in PIC_QUALITY is %f", PIC_QUALITY);
            self.preprocessedData = [LCImageUtil getDataOfCompressImage:self.preprocessedImage toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
        
            [self uploadImageToQiniu];
        });
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showHudInView:self.view hint:nil];
}


#pragma mark - Inner Function
- (UIViewController *)viewController
{
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}
@end
