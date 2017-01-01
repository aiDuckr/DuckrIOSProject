//
//  LCDuckrShareCodeHelper.h
//  LinkCity
//
//  Created by Roy on 12/24/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCDuckrShareCodeHelper : NSObject

+ (instancetype)sharedInstance;
- (void)detectDuckrShareCode;
@end
