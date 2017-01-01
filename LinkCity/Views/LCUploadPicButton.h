//
//  LCUploadPicButton.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUploadPicButton : UIButton<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, assign) BOOL fromCamera;
@property (nonatomic, assign) BOOL fromAlbum;
@end
