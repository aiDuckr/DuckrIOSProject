//
//  LCSendTourPicVCViewController.h
//  LinkCity
//
//  Created by lhr on 16/4/3.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseVC.h"
@interface LCSendTourPicVCViewController : LCBaseVC

@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,assign) LCTourpicType type;
@property (nonatomic, retain) NSString *filePath;
- (void)setVideoPath:(AVAsset *)url;
@end
