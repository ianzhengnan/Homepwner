//
//  ItemStore.h
//  Homepwner
//
//  Created by 郑楠 on 15/7/9.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;
@interface ItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (Item *)createItem;
- (void)removeItem:(Item *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (BOOL)saveChanges;

@end
