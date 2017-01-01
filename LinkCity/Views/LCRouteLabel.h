//
//  LCRouteLabel.h
//  LinkCity
//
//  Created by roy on 2/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRouteLabel : UIView
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

+ (instancetype)createInstance;
- (void)addIntoViewAndSetToSameSize:(UIView *)viewContainer;

- (void)setStartPlace:(NSString *)startPlace;
- (void)setDestinationStr:(NSString *)destination;
@end
