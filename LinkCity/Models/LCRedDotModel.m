//
//  LCRedDotModel.m
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRedDotModel.h"

@implementation LCRedDotModel
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.msgNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"MsgNum"]];
        self.myselfNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"MyselfNum"]];
        self.tourpicNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"TourpicNum"]];
        self.evalNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"EvalNum"]];
        self.payNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"PayNum"]];
        self.focusNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"FocusNum"]];
        self.notifyNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifyNum"]];
        self.focusTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"FocusTime"]];
        self.focusContent = [LCStringUtil getNotNullStr:[dic objectForKey:@"FocusContent"]];
        self.notifyTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"NotifyTime"]];
        self.notifyContent = [LCStringUtil getNotNullStr:[dic objectForKey:@"NotifyContent"]];
        self.unRefundNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"UnRefundNum"]];
        self.localLeisureNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"LocalLeisureNum"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeInteger:self.msgNum forKey:@"MsgNum"];
    [coder encodeInteger:self.myselfNum forKey:@"MyselfNum"];
    [coder encodeInteger:self.tourpicNum forKey:@"TourpicNum"];
    [coder encodeInteger:self.payNum forKey:@"PayNum"];
    [coder encodeInteger:self.evalNum forKey:@"EvalNum"];
    [coder encodeInteger:self.focusNum forKey:@"FocusNum"];
    [coder encodeInteger:self.notifyNum forKey:@"NotifyNum"];
    [coder encodeObject:self.focusTime forKey:@"FocusTime"];
    [coder encodeObject:self.focusContent forKey:@"FocusContent"];
    [coder encodeObject:self.notifyTime forKey:@"NotifyTime"];
    [coder encodeObject:self.notifyContent forKey:@"NotifyContent"];
    [coder encodeInteger:self.unRefundNum forKey:@"UnRefundNum"];
    [coder encodeInteger:self.localLeisureNum forKey:NSStringFromSelector(@selector(localLeisureNum))];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.msgNum = [coder decodeIntegerForKey:@"MsgNum"];
        self.myselfNum = [coder decodeIntegerForKey:@"MyselfNum"];
        self.tourpicNum = [coder decodeIntegerForKey:@"TourpicNum"];
        self.payNum = [coder decodeIntegerForKey:@"PayNum"];
        self.evalNum = [coder decodeIntegerForKey:@"EvalNum"];
        self.focusNum = [coder decodeIntegerForKey:@"FocusNum"];
        self.notifyNum = [coder decodeIntegerForKey:@"NotifyNum"];
        self.focusTime = [coder decodeObjectForKey:@"FocusTime"];
        self.focusContent = [coder decodeObjectForKey:@"FocusContent"];
        self.notifyTime = [coder decodeObjectForKey:@"NotifyTime"];
        self.notifyContent = [coder decodeObjectForKey:@"NotifyContent"];
        self.unRefundNum = [coder decodeIntegerForKey:@"UnRefundNum"];
        self.localLeisureNum = [coder decodeIntegerForKey:NSStringFromSelector(@selector(localLeisureNum))];
    }
    return self;
}

@end
