//
//  LCSchoolPickerVC.h
//  LinkCity
//
//  Created by roy on 5/31/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

@protocol LCSchoolPickerVCDelegate;
@interface LCSchoolPickerVC : LCBaseVC
@property (nonatomic, assign) id<LCSchoolPickerVCDelegate> delegate;

@property (nonatomic, strong) NSString *defaultSearchStr;
@end


@protocol LCSchoolPickerVCDelegate <NSObject>
@optional
- (void)schoolPickerVC:(LCSchoolPickerVC *)schoolPickerVC didPickSchool:(NSString *)school;
- (void)schoolPickerVCDidCancel:(LCSchoolPickerVC *)schoolPickerVC;

@end