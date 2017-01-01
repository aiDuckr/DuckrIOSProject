//
//  LCImageUnit.h
//  LinkCity
//
//  Created by roy on 6/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCImageUnit : NSObject
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *thumbUrl;
@property (nonatomic, retain) UIImage *image;

- (instancetype)initWithUrl:(NSString *)url thumbUrl:(NSString *)thumbUrl image:(UIImage *)image;
@end
