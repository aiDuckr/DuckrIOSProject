//
//  LCUserTagModel.h
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCUserTagModel : LCBaseModel
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) NSInteger type;   // 类型，1男生第一排，2男生第二排，3，男生第三排，4女生第一排，5女生第二排，6女生第三排
@end


