//
//  ImageViewController.m
//  Homepwner
//
//  Created by zhengna on 15/8/2.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    UIImageView *imageView = (UIImageView *)self.view;
    
    imageView.image = self.image;
}

@end
