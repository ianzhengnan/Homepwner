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

- (NSArray *)allAssetTypes{
    
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"AssetType"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@",[error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    //Is this the first time the program is being run?
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
    }
    return _allAssetTypes;
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{

    if (fromIndex == toIndex) {
        return;
    }
    
    Item *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    double lowerBound = 0.0;
    
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    }else{
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    }else{
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) /2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
    
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
