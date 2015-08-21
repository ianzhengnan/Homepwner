//
//  DetailViewController.h
//  Homepwner
//
//  Created by zhengna on 15/7/19.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;
@interface DetailViewController : UIViewController <UIViewControllerRestoration>

@property (nonatomic, strong) Item *item;

@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end
