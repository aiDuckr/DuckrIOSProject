//
//  LCBlandContentView.h
//  LinkCity
//
//  Created by roy on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBlankContentView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                        title:(NSString *)title
                    marginTop:(CGFloat)marginTop;

@end
