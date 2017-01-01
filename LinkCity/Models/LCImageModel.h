//
//  LCImageModel.h
//  LinkCity
//
//  Created by roy on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCImageModel : LCBaseModel
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *imageUrlThumb;
@property (nonatomic, strong) NSString *imageUrlMD5;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSString *timestamp;

- (NSURL *)getImageNSURL;
- (NSURL *)getImageThumbNSURL;
@end
