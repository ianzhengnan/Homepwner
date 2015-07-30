//
//  ImageStore.m
//  Homepwner
//
//  Created by zhengna on 15/7/20.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dict;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation ImageStore

- (NSString *)imagePathForKey:(NSString *)key{

    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

+ (instancetype)sharedStore{

    static ImageStore *sharedStore = nil;
    
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


- (instancetype)init{

    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate{

    self = [super init];
    
    if (self) {
        _dict = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(clearCaches:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)clearCaches:(NSNotification *)note{

    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dict count]);
    [self.dict removeAllObjects];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key{

    //[self.dict setObject:image forKey:key];
    self.dict[key] = image;
    
    NSString *imagePath = [self imagePathForKey:key];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [data writeToFile:imagePath atomically:YES];
    
}

- (UIImage *)imageForKey:(NSString *)key{

    //return self.dict[key];
    
    UIImage *result = self.dict[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            self.dict[key] = result;
        }else{
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key{

    if(!key){
        return;
    }
    [self.dict removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}


@end
