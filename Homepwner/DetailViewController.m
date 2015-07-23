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
#import "ImageStore.h"

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *SerialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation DetailViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    iv.contentMode = UIViewContentModeScaleAspectFill;
    
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    
    self.imageView = iv;
    
    //set the vertical priorities to be less than
    //those of the other subviews
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLable,
                              @"toolbar" : self.toolBar};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:nameMap];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:nameMap];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
}

- (IBAction)takePicture:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    //Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

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

- (IBAction)closeKeyBoard:(UIControl *)sender {
//    [self.nameField resignFirstResponder];
//    [self.SerialNumberField resignFirstResponder];
//    [self.valueField resignFirstResponder];
    [self.view endEditing:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //store the image in the ImageStore for this key
    [[ImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    NSString *imageKey = self.item.itemKey;
    
    UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:imageKey];
    
    self.imageView.image = imageToDisplay;
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
