//
//  LCDestinationInputter.h
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCDialogInputter : NSObject

+ (instancetype)sharedInstance;
- (void)showInputterWithDefaultText:(NSString *)text
                        placeHolder:(NSString *)placeHolder
                              title:(NSString *)title
                         completion:(void(^)(NSString *destination))comp;



@end
