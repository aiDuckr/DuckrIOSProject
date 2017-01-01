//
//  LCCopyableLabel.h
//  LinkCity
//
//  Created by roy on 1/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCCopyableLabel;

@protocol HTCopyableLabelDelegate <NSObject>
@optional
- (NSString *)stringToCopyForCopyableLabel:(LCCopyableLabel *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(LCCopyableLabel *)copyableLabel;
@end


@interface LCCopyableLabel : UILabel
@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, weak) id<HTCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end

