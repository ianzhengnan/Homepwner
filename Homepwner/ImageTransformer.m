//
//  ImageTransformer.m
//  Homepwner
//
//  Created by zhengna on 15/8/14.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "ImageTransformer.h"

@implementation ImageTransformer

+ (Class)transformedValueClass{

    return [NSData class];
}

- (id)transformedValue:(id)value{

    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value{

    return [UIImage imageWithData:value];
}

@end
