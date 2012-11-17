//
//  AJNewItemTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJNewItemTableViewCell.h"

@implementation AJNewItemTableViewCell

@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont fontWithName:@"Thonburi-Bold" size:30.0];
        _textField.textColor = [UIColor darkGrayColor];
        _textField.textAlignment = UITextAlignmentCenter;
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        [_textField release];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height, cellWidth = self.contentView.bounds.size.width;
    CGFloat tfY = ceil((cellHeight - 31.0) / 2.0);
    _textField.frame = CGRectMake(0.0, tfY, cellWidth, 31.0);
}

@end
