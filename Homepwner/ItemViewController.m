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
#import "DetailViewController.h"
#import "ItemCell.h"
#import "ImageStore.h"
#import "ImageViewController.h"

@interface ItemViewController () <UIPopoverControllerDelegate>

@property (nonatomic, strong)UIPopoverController *imagePopover;

@end

@implementation ItemViewController

- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        //create a new bar button item that will send addNewItem: to
        //ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
    }
    
    return self;
}

- (void)addNewItem:(id)sender{
    
    Item *newItem = [[ItemStore sharedStore] createItem];
    
//    NSInteger lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:newItem];
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //navController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{

    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    
//    if ([[[ItemStore sharedStore] allItems] count] == 0) {
//        return 1;
//    }else{
//        return [[[ItemStore sharedStore] allItems] count] + 1;
//    }
    
    return [[[ItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{

     //Get a new or recycled cell
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    NSArray *items = [[ItemStore sharedStore] allItems];

    Item *item = items[indexPath.row];
    
    cell.nameLable.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    
    if (item.valueInDollars >= 50) {
        cell.valueLabel.textColor = [UIColor greenColor];
    }else{
        cell.valueLabel.textColor = [UIColor redColor];
    }
    
    cell.thumbnailView.image = item.thumbnail;
    
    __weak ItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
    
        NSLog(@"Going to show image for %@", item);
        
        ItemCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            
            NSString *itemKey = item.itemKey;
            
            //If there is no image, we don't need to display anything
            UIImage *img = [[ImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds
                                        fromView:strongCell.thumbnailView];
            
            ImageViewController *ivc = [[ImageViewController alloc] init];
            ivc.image = img;
            
            //Present a 600*600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    };
    
    return cell;

}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{

    self.imagePopover = nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[ItemStore sharedStore] allItems];
        Item *item = items[indexPath.row];
        [[ItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    DetailViewController *detailViewController = [[DetailViewController alloc] init];

    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    
    Item *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
//    NSInteger des;
//    
//    NSArray *items = [[ItemStore sharedStore] allItems];
//    if (destinationIndexPath.row >= items.count) {
//        des = items.count;
//    }else{
//        des = destinationIndexPath.row;
//    }
    
    
    [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
    
}


@end
