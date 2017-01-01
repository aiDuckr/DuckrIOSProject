//
//  LCImageUnit.m
//  LinkCity
//
//  Created by roy on 6/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCImageUnit.h"

@implementation LCImageUnit

- (instancetype)initWithUrl:(NSString *)url thumbUrl:(NSString *)thumbUrl image:(UIImage *)image{
    self = [super init];
    if (self) {
        self.url = url;
        self.thumbUrl = thumbUrl;
        self.image = image;
    }
    return self;
}


@end
