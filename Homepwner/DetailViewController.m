//
//  DetailViewController.m
//  Homepwner
//
//  Created by zhengna on 15/7/19.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "DatePickerViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *SerialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@end

@implementation DetailViewController

- (instancetype)init{
    
    self = [super init];

    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Change Date" style:UIBarButtonItemStylePlain target:self action:@selector(navToDatePicker)];
        
        navItem.rightBarButtonItem = bbi;
    }
    
    return self;
}

- (void)navToDatePicker{
    
    DatePickerViewController *datePickerVC = [[DatePickerViewController alloc] init];
    
    datePickerVC.item = self.item;
    
    [self.navigationController pushViewController:datePickerVC animated:YES];
    
}

- (IBAction)pressDone:(UITextField *)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)namePressDone:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)closeKeyBoard:(UIControl *)sender {
    [self.nameField resignFirstResponder];
    [self.SerialNumberField resignFirstResponder];
    [self.valueField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    Item *item = self.item;
    
    self.nameField.text = item.itemName;
    self.SerialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    }
    
    self.dateLable.text = [dateFormatter stringFromDate:item.dateCreated];
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    //'save' changes to item
    Item *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.SerialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)setItem:(Item *)item{

    _item = item;
    self.navigationItem.title = _item.itemName;
}

@end
