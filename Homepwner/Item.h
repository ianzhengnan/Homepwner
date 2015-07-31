//
//  Item.h
//  RandomItems
//
//  Created by zhengnan on 15/6/27.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item : NSObject <NSCoding>

@property (nonatomic, copy)NSString *itemName;
@property (nonatomic, copy)NSString *serialNumber;
@property (nonatomic)int valueInDollars;
@property (nonatomic, strong)NSDate *dateCreated;

@property (nonatomic, copy) NSString *itemKey;

@property (nonatomic, strong)UIImage *thumbnail;

+ (instancetype)randomItem;

// Designated initializer for BNRItem
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

- (void)setThumbnailFromImage:(UIImage *)image;

@end