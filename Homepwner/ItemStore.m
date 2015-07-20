//
//  ItemStore.m
//  Homepwner
//
//  Created by 郑楠 on 15/7/9.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"
#import "ImageStore.h"

@interface ItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end


@implementation ItemStore

//单例模式
+ (instancetype)sharedStore{

    static ItemStore *sharedStore = nil;
    
    //Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

//If a programmer calls [[ItemStore alloc] init], let hime
//know the error of his ways
- (instancetype)init{

    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [ItemStore sharedItem]" userInfo:nil];
    
    return nil;
            
}

- (instancetype)initPrivate{

    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)removeItem:(Item *)item{

    NSString *key = item.itemKey;
    
    [[ImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (NSArray *)allItems{

    return self.privateItems;
}

- (Item *)createItem{

    Item *item = [Item randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{

    if (fromIndex == toIndex) {
        return;
    }
    
    Item *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
}

@end
