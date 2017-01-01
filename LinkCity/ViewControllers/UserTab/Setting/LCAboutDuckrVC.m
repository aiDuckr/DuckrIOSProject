//
//  LCAboutDuckrVC.m
//  LinkCity
//
//  Created by roy on 3/24/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAboutDuckrVC.h"

@interface LCAboutDuckrVC ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation LCAboutDuckrVC

+ (instancetype)createInstance{
    return (LCAboutDuckrVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSetting identifier:VCIDAboutDuckrVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@",APP_LOCAL_SHOT_VERSION_STRING];
}

- (IBAction)duckrURLButtonAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DuckrWebSite]];
}



@end
