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

@import CoreData;

@interface ItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext  *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end


@implementation ItemStore

//单例模式
+ (instancetype)sharedStore{

    static ItemStore *sharedStore = nil;
    
    //Do I need to create a sharedStore?
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
    
    // for thread safe
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

-(void)loadAllItems{

    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
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
//        //_privateItems = [[NSMutableArray alloc] init];
//        
//        NSString *path = [self itemArchivePath];
//        
//        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        if (!_privateItems) {
//            _privateItems = [[NSMutableArray alloc] init];
//        }
        
        //Read in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        //Where does the SQLite file go?
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        //Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
        
    }
    
    return self;
}

- (void)removeItem:(Item *)item{

    NSString *key = item.itemKey;
    
    [[ImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (NSArray *)allItems{

    return self.privateItems;
}

- (Item *)createItem{
    
//    Item *item = [[Item alloc] init];
    
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    }else{
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
    
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.context];
   
    item.orderingValue = order;
    
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

- (NSString *)itemArchivePath{

    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges{

//    NSString *path = [self itemArchivePath];
//    
//    //Return YES on success
//    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];

    NSError *error;
    BOOL successful = [self.context save: &error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

@end
