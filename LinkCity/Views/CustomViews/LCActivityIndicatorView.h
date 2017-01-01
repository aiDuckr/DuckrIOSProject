//
//  LCActivityIndicatorView.h
//  LinkCity
//
//  Created by roy on 12/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCActivityIndicatorView : UIView
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
