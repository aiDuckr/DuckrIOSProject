//
//  LCPhoneContactorModel.h
//  LinkCity
//
//  Created by roy on 3/15/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

//手机通讯录
@interface LCPhoneContactorModel : LCBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, retain) NSString *uuid;

@property (nonatomic, assign) BOOL isSelected;  //标记一个通讯录项是否被选中

- (NSDictionary *)getDicOfModel;
@end