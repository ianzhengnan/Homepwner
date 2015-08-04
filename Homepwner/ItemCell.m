//
//  ItemCell.m
//  Homepwner
//
//  Created by zhengna on 15/7/30.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

@end

@implementation ItemCell

- (void)updateInterfaceForDynamicTypeSize{

    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFont *font_small = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.nameLable.font = font;
    self.serialNumberLabel.font = font_small;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{ UIContentSizeCategoryExtraSmall: @40,
                                 UIContentSizeCategorySmall: @40,
                                 UIContentSizeCategoryMedium: @40,
                                 UIContentSizeCategoryLarge: @40,
                                 UIContentSizeCategoryExtraLarge: @45,
                                 UIContentSizeCategoryExtraExtraLarge: @55,
                                 UIContentSizeCategoryExtraExtraExtraLarge: @65};
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
    //self.imageViewWidthConstraint.constant = imageSize.floatValue;
}

- (void)awakeFromNib {
    // Initialization code
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateInterfaceForDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    [self.thumbnailView addConstraint:constraint];
}

- (void)dealloc{

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender{
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
