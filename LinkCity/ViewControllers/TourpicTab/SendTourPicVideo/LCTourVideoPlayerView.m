//
//  TourVideopPayerView.m
//  LinkCity
//
//  Created by lhr on 16/4/2.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCTourVideoPlayerView.h"
#import "SCRecordSessionManager.h"
#import "SCRecorder.h"
//#import "UIView+Blockskit.h"
#import <AVFoundation/AVAssetImageGenerator.h>
@interface LCTourVideoPlayerView () <SCVideoPlayerViewDelegate>

@property (nonatomic,strong) SCPlayer *player;

@property (nonatomic, strong) SCVideoPlayerView * playerView;

@property (nonatomic, strong) NSURL * videoUrl;

@property (nonatomic, strong) AVAsset * asset;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *playIconImageView;
@end

@implementation LCTourVideoPlayerView

#define PLAY_ICON_WIDTH (50.0f)

- (instancetype)initWithFrame:(CGRect)frame url:(AVAsset *)url {
   self = [super initWithFrame:frame];
    if (self) {
        _player = [SCPlayer player];
        
        _playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];

        _playerView.delegate = self;
        //self.playerView.delegate = self;
        _asset = url;
        UIImage *thumbImage = [self thumbnailImageForVideo];
        UIImage *backGroundImage = [LCImageUtil blurWithCoreImage:thumbImage withRect:frame pixel:100];
        self.bgImageView = [[UIImageView alloc] initWithImage:backGroundImage];
        self.bgImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.bgImageView];
        self.bgImageView.alpha = 0.6;
        
//        self.playerView.backgroundColor = [UIColor greenColor];
//        self.backgroundColor = [UIColor redColor];
        [self initPlayerView];
        
        self.playIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.size.width - PLAY_ICON_WIDTH) / 2.0f, (self.size.height - PLAY_ICON_WIDTH) / 2.0f, PLAY_ICON_WIDTH, PLAY_ICON_WIDTH)];
        self.playIconImageView.image = [UIImage imageNamed:@"ToupicVideoPlayIcon"];
        self.playIconImageView.hidden = YES;
        [self addSubview:self.playIconImageView];
    }
    return self;
    
}

- (void)initPlayerView {
        //self.playerView.tag = 400;
    self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.playerView.center = CGPointMake(DEVICE_WIDTH / 2, self.frame.size.height / 2);
    [self addSubview:self.playerView];
    self.playerView.tapToPauseEnabled = YES;
    self.player.loopEnabled = YES;
    self.userInteractionEnabled = YES;
    [self.player setItemByAsset:self.asset];
//    [self bk_whenTapped:^() {
//        if ([self.player isPlaying]) {
//            [self.player pause];
//        } else {
//            [self.player play];
//        }
//            
//    }];
    
    
   // self.player
//            [_player setItemByAsset:_recorder.session.assetRepresentingSegments];
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}


- (void)didMoveToWindow {
    [self.player pause];
}

- (BOOL)isPlaying {
    return [self.player isPlaying];
}
#pragma mark - SCVideoPlayerViewDelegate

- (void)videoPlayerViewTappedToPlay:(SCVideoPlayerView *__nonnull)videoPlayerView {
    self.playIconImageView.hidden = YES;
    [self.player play];
}

- (void)videoPlayerViewTappedToPause:(SCVideoPlayerView *__nonnull)videoPlayerView {
    if ([self.player isPlaying]) {
        [self.player pause];
    }
    self.playIconImageView.hidden = NO;
}

- (UIImage*) thumbnailImageForVideo {
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    //CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
    
    return thumbnailImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
