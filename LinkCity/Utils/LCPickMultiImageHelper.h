//
//  LCPickMultiImageHelper.h
//  LinkCity
//
//  Created by Roy on 8/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>

@interface LCPickMultiImageHelper : NSObject

+ (instancetype)sharedInstance;
- (void)pickImageWithMaxNum:(NSInteger)num completion:(void(^)(NSArray *pickedImageArray))comp;


@end
