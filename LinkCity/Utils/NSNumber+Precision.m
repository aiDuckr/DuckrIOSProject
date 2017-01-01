//
//  NSNumber+Precision.m
//  LinkCity
//
//  Created by Roy on 6/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "NSNumber+Precision.h"

@implementation NSNumber (Precision)


+ (double)twoDigitDouble:(double)aDouble{
    return round(aDouble*100)/100;
}
+ (double)threeDigitDouble:(double)aDouble{
    return round(aDouble*1000)/1000;
}

@end
