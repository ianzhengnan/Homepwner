//
//  DatePickerViewController.m
//  Homepwner
//
//  Created by zhengna on 15/7/20.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Item.h"

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.datePicker.date = self.item.dateCreated;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    //'save' change to item
    Item *item = self.item;
    item.dateCreated = self.datePicker.date;
}

@end
