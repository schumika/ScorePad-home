//
//  AJPlayerTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayerTableViewCell.h"

#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"


@interface AJPlayerTableViewCell () {
    UIImageView *_pictureView;
    UILabel *_nameLabel;
    UILabel *_totalScoresLabel;
    UILabel *_roundsPlayedLabel;
    
    UITextField *_scoreTextField;
    UIButton *_plusButton;
    UIButton *_minusButton;
}

@end


@implementation AJPlayerTableViewCell

@synthesize name = _name;
@synthesize color = _color;
@synthesize picture = _picture;
@synthesize totalScores = _totalScores;
@synthesize numberOfRounds = _numberOfRounds;

@synthesize scoreTextField = _scoreTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_pictureView];
        [_pictureView release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor brownColor];
        _nameLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:22.0];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        _totalScoresLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalScoresLabel.backgroundColor = [UIColor clearColor];
        _totalScoresLabel.textColor = [UIColor brownColor];
        _totalScoresLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:40.0];
        _totalScoresLabel.adjustsFontSizeToFitWidth = YES;
        _totalScoresLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _totalScoresLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_totalScoresLabel];
        [_totalScoresLabel release];
        
        _roundsPlayedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roundsPlayedLabel.backgroundColor = [UIColor clearColor];
        _roundsPlayedLabel.textColor = [UIColor grayColor];
        _roundsPlayedLabel.font = [UIFont fontWithName:@"Thonburi" size:12.0];
        _roundsPlayedLabel.adjustsFontSizeToFitWidth = YES;
        _roundsPlayedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_roundsPlayedLabel];
        [_roundsPlayedLabel release];
        
       /* _scoreTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _scoreTextField.borderStyle = UITextBorderStyleNone;
        _scoreTextField.background = [UIImage roundTextFieldImage];
        _scoreTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _scoreTextField.placeholder = [NSString stringWithFormat:@"%g",0.0];
        _scoreTextField.font = [UIFont fontWithName:@"Thonburi" size:17.0];
        _scoreTextField.textColor = [UIColor brownColor];
        _scoreTextField.textAlignment = UITextAlignmentCenter;
        _scoreTextField.delegate = self;
        _scoreTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_scoreTextField];
        [_scoreTextField release];
        
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
        _plusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
        [_plusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [_plusButton setTitle:@"+" forState:UIControlStateNormal];
        [_plusButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_plusButton];
        
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
        _minusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
        [_minusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [_minusButton setTitle:@"-" forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(minusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_minusButton];*/
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellWidth = self.contentView.bounds.size.width;

    CGSize nameSize = [_nameLabel sizeThatFits:CGSizeMake(0.0, 30.0)];
    _nameLabel.frame = CGRectMake(37.0, 0.0, nameSize.width, 30.0);
    _pictureView.frame = CGRectMake(10.0, 3.0, 25.0, 25.0);
    _totalScoresLabel.frame = CGRectMake(10.0, 27.0, CGRectGetMaxX(_nameLabel.frame) - 10.0, 40.0);
    _roundsPlayedLabel.frame = CGRectMake(20.0, 69.0, CGRectGetMaxX(_nameLabel.frame) - 10.0, 10.0);
    
   /* CGFloat pictureMaxX = CGRectGetMaxX(_pictureView.frame) + 10.0;
    _totalScoresLabel.frame = CGRectMake(pictureMaxX + 10.0, 28.0, cellWidth - pictureMaxX - 10.0, 40.0;
    _roundsPlayedLabel.frame = CGRectMake(25.0, cellHeight - 11.0, cellWidth - pictureMaxX, 10.0);*/
    
    _scoreTextField.frame = CGRectMake(cellWidth - 90.0, 5.0, 85.0, 31.0);
    _plusButton.frame = CGRectMake(cellWidth - 90.0, 40.0, 40.0, 31.0);
    _minusButton.frame = CGRectMake(cellWidth - 45.0, 40.0, 40.0, 31.0);
}

- (void)dealloc {
    [_name release];
    [_color release];
    [_picture release];
    
    [super dealloc];
}

- (void)setName:(NSString *)name {
    if (name != _name) {
        [_name release];
        _name = [name retain];
        
        _nameLabel.text = _name;
    }
}

- (void)setColor:(NSString *)color {
    if (color != _color) {
        [_color release];
        _color = [color retain];
        
        _nameLabel.textColor = [UIColor colorWithHexString:_color];
    }
}

- (void)setPicture:(UIImage *)picture {
    if (picture != _picture) {
        [_picture release];
        _picture = [picture retain];
        
        [_pictureView setImage:[_picture applyMask:[UIImage imageNamed:@"mask.png"]]];
    }
}

- (void)setTotalScores:(double)totalScores {
    _totalScores = totalScores;
    
    _totalScoresLabel.text = [NSString stringWithFormat:@"%g", _totalScores];
}

- (void)setNumberOfRounds:(int)numberOfRounds {
    _numberOfRounds = numberOfRounds;
    
    _roundsPlayedLabel.text = [NSString stringWithFormat:@"%d %@ played", _numberOfRounds, (_numberOfRounds == 1) ? @"round" : @"rounds"];
}

#pragma mark - Buttons actions

- (IBAction)plusButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(playerCellClickedPlusButton:)]) {
        [self.delegate playerCellClickedPlusButton:self];
    }
}

- (IBAction)minusButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(playerCellClickedMinusButton:)]) {
        [self.delegate playerCellClickedMinusButton:self];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(playerCellShouldStartEditingScore:)]) {
        [self.delegate playerCellShouldStartEditingScore:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (![NSString isNilOrEmpty:textField.text]) {
        [self.delegate playerCellClickedPlusButton:self];
    }
    
    return YES;
}

@end
