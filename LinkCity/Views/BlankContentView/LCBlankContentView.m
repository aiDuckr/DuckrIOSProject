//
//  LCBlandContentView.m
//  LinkCity
//
//  Created by roy on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBlankContentView.h"


@implementation LCBlankContentView

- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                        title:(NSString *)title
                    marginTop:(CGFloat)marginTop{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //add image view
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.imageView];

        //add title view
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.titleLabel];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = title;
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.titleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:15]];
        self.titleLabel.textColor = UIColorFromR_G_B_A(199, 195, 191, 1);
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(self.frame.size.width/2.0,
                                             self.imageView.frame.origin.y+self.imageView.frame.size.height+20+self.titleLabel.frame.size.height/2.0);
        
        
        // add constraints
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.imageView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_imageView]-10-[_titleLabel]",marginTop] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView,_titleLabel)]];
    }
    return self;
}

@end
