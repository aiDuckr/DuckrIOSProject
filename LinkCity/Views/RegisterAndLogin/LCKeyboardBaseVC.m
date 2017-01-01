//
//  LCKeyboardBaseVC.m
//  LinkCity
//
//  Created by roy on 11/11/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCKeyboardBaseVC.h"

@interface LCKeyboardBaseVC ()
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation LCKeyboardBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)tapped:(id)sender{
    
}

@end
