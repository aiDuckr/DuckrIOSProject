//
//  LCAboutUsVC.m
//  LinkCity
//
//  Created by 张宗硕 on 1/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAboutUsVC.h"

@interface LCAboutUsVC ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LCAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化版本显示.
    [self initVersionLabel];
}

/// 初始化版本显示.
- (void)initVersionLabel {
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", APP_LOCAL_VERSION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
