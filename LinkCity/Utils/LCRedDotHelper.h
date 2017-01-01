//
//  LCRedDotHelper.h
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRedDotHelper : NSObject

+ (instancetype)sharedInstance;
- (void)startUpdateRedDot;
- (void)stopUpdateRedDot;
@end
