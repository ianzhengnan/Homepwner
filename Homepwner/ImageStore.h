//
//  ImageStore.h
//  Homepwner
//
//  Created by zhengna on 15/7/20.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
