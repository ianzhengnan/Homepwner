//
//  ItemViewController.m
//  Homepwner
//
//  Created by 郑楠 on 15/7/9.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "ItemViewController.h"
#import "Item.h"
#import "ItemStore.h"

@implementation ItemViewController

- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[ItemStore sharedStore] createItem];
        }
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style{

    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{


    return [[[ItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    //Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    
    Item *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    return cell;

}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}


@end
