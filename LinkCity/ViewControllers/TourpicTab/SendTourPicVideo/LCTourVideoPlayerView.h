//
//  TourVideopPayerView.h
//  LinkCity
//
//  Created by lhr on 16/4/2.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTourVideoPlayerView : UIView
- (BOOL)isPlaying;

-(instancetype) initWithFrame:(CGRect)frame url:(AVAsset *)url;
- (void)play;
- (void)pause;
@end
