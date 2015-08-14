//
//  Item.h
//  Homepwner
//
//  Created by zhengna on 15/8/14.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * itemKey;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic) double  orderingValue;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic) int valueInDollars;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
