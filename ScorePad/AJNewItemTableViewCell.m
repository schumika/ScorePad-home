//
//  AJNewItemTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJNewItemTableViewCell.h"
#import "AJBrownUnderlinedView.h"

@interface AJNewItemTableViewCell ()

@property (nonatomic, strong, readwrite) UITextField *textField;
@property (nonatomic, strong)  AJBrownUnderlinedView *underlinedView;

@end

@implementation AJNewItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.underlinedView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.underlinedView];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.font = [UIFont fontWithName:@"Thonburi-Bold" size:30.0];
        self.textField.textColor = [UIColor darkGrayColor];
        self.textField.textAlignment = UITextAlignmentCenter;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.underlinedView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect textfieldFrame = self.contentView.bounds;
    textfieldFrame.origin.y = -10.0;
    
    self.textField.frame = textfieldFrame;
    
    CGFloat cellHeight = self.contentView.bounds.size.height, cellWidth = self.contentView.bounds.size.width;
    self.underlinedView.frame = CGRectMake(0.0, 0.0, cellWidth, cellHeight);
    CGFloat tfY = ceil((cellHeight - 31.0) / 2.0);
    self.underlinedView.frame = CGRectMake(10.0, tfY, cellWidth - 10.0, 31.0);
}

@end
