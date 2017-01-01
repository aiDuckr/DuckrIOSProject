//
//  LCAFNBlurredImageView.h
//  LinkCity
//
//  Created by roy on 1/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"


typedef enum : NSUInteger {
    AFNImageTypeNormal = 0,
    AFNImageTypeBlurredShowNormal,
    AFNImageTypeBlurredShowBlured,
} AFNImageType;

@interface LCAFNBlurredImageView : UIImageView
@property (nonatomic, assign) AFNImageType imageType;
@property (nonatomic, strong) NSURL *imageURL;
@end
