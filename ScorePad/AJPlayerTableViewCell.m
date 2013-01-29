//
//  AJPlayerTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayerTableViewCell.h"
#import "AJBrownUnderlinedView.h"
#import "AJUnderlinedView.h"

#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"
#import "UIFont+Additions.h"


@interface AJPlayerTableViewCell () {
    UIImageView *_pictureView;
    UILabel *_nameLabel;
    UIButton *_totalScoresButton;
    UILabel *_roundsPlayedLabel;
    AJBrownUnderlinedView *_underlinedView;
    UIImageView *_grabImageView;
    UIImageView *_separatorView;
    UIImageView *_disclosureView;
    
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

@synthesize displaysLeftSide = _displaysLeftSide;

@synthesize scoreTextField = _scoreTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _grabImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rip.png"]];
        _grabImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_grabImageView];
        [_grabImageView release];
        
        _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_pictureView];
        [_pictureView release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor brownColor];
        //_nameLabel.font = [UIFont fontWithName:@"Zapfino" size:20.0];
        //_nameLabel.font = [UIFont handwritingBoldFontWithSize:45.0];
        _nameLabel.font = [UIFont LDBrushFontWithSize:55.0];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        _totalScoresButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _totalScoresButton.backgroundColor = [UIColor clearColor];
        [_totalScoresButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        //_totalScoresLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:40.0];
        //_totalScoresLabel.font = [UIFont handwritingFontWithSize:45.0];
        _totalScoresButton.titleLabel.font = [UIFont LDBrushFontWithSize:65.0];
        _totalScoresButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _totalScoresButton.titleLabel.textAlignment = UITextAlignmentCenter;
        _totalScoresButton.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_totalScoresButton addTarget:self action:@selector(totalScoresButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_totalScoresButton];
        [_totalScoresButton release];
        
        _roundsPlayedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roundsPlayedLabel.backgroundColor = [UIColor clearColor];
        _roundsPlayedLabel.textColor = [UIColor grayColor];
        _roundsPlayedLabel.textAlignment = UITextAlignmentCenter;
        _roundsPlayedLabel.font = [UIFont fontWithName:@"Thonburi" size:12.0];
        _roundsPlayedLabel.adjustsFontSizeToFitWidth = YES;
        _roundsPlayedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_roundsPlayedLabel];
        [_roundsPlayedLabel release];
        
        _separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_new2.png"]];
        [self.contentView addSubview:_separatorView];
        [_separatorView release];
        
        _disclosureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure.png"]];
        [self.contentView addSubview:_disclosureView];
        [_disclosureView release];
        
        _underlinedView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        [self addSubview:_underlinedView];
        [_underlinedView release];
        
        _scoreTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _scoreTextField.borderStyle = UITextBorderStyleNone;
        _scoreTextField.background = [UIImage roundTextFieldImage];
        _scoreTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _scoreTextField.placeholder = [NSString stringWithFormat:@"%g",0.0];
        _scoreTextField.font = [UIFont fontWithName:@"Thonburi" size:17.0];
        _scoreTextField.textColor = [UIColor brownColor];
        _scoreTextField.textAlignment = UITextAlignmentCenter;
        _scoreTextField.delegate = self;
        _scoreTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_underlinedView addSubview:_scoreTextField];
        [_scoreTextField release];
        
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
        _plusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
        [_plusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [_plusButton setTitle:@"+" forState:UIControlStateNormal];
        [_plusButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_underlinedView addSubview:_plusButton];
        
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
        _minusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
        [_minusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [_minusButton setTitle:@"-" forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(minusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_underlinedView addSubview:_minusButton];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height, cellWidth = self.contentView.bounds.size.width;
    
    //_grabImageView.frame = CGRectMake(3.0, 25.0, 18.0, 19.0);
    _grabImageView.frame = CGRectMake(3.0, 0.0, 12.0, 70.0);
    //_pictureView.frame = CGRectMake(22.0, 10.0, 50.0, 50.0);
    _pictureView.frame = CGRectMake(30.0, 17.0, 35.0, 35.0);
    //_nameLabel.frame = CGRectMake(80.0, 13.0, 130.0, 65.0);
    _nameLabel.frame = CGRectMake(70.0, 5.0, 130.0, 65.0);
    //_totalScoresLabel.frame = CGRectMake(212.0, 10.0, 91.0, 40.0);
    _totalScoresButton.frame = CGRectMake(212.0, 10.0, 91.0, 50.0);
    _roundsPlayedLabel.frame = CGRectMake(212.0, 55.0, 91.0, 10.0);
    
    _separatorView.frame = CGRectMake(0.0, cellHeight - 2.0, cellWidth, 2.0);
    _disclosureView.frame = CGRectMake(cellWidth - 22.0, ceil((cellHeight - 20.0) / 2.0), 20.0, 20.0);
    
    _underlinedView.frame = CGRectMake(-cellWidth, 0, cellWidth, self.frame.size.height);
    _scoreTextField.frame = CGRectMake(cellWidth - 100.0, 2.0, 85.0, 31.0);
    _plusButton.frame = CGRectMake(cellWidth - 100.0, 35.0, 40.0, 31.0);
    _minusButton.frame = CGRectMake(cellWidth - 55.0, 35.0, 40.0, 31.0);
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
    
    [_totalScoresButton setTitle:[NSString stringWithFormat:@"%g", _totalScores] forState:UIControlStateNormal];
}

- (void)setNumberOfRounds:(int)numberOfRounds {
    _numberOfRounds = numberOfRounds;
    
    _roundsPlayedLabel.text = [NSString stringWithFormat:@"%d %@ played", _numberOfRounds, (_numberOfRounds == 1) ? @"round" : @"rounds"];
}

#pragma mark - Buttons actions

- (IBAction)plusButtonClicked:(id)sender {
    [self moveToOriginalFrameAnimated];
    
    if ([self.delegate respondsToSelector:@selector(playerCellClickedPlusButton:)]) {
        [self.delegate playerCellClickedPlusButton:self];
        [self.delegate playerCellDidHideNewScoreView:self];
    }
}

- (IBAction)minusButtonClicked:(id)sender {
    [self moveToOriginalFrameAnimated];
    
    if ([self.delegate respondsToSelector:@selector(playerCellClickedMinusButton:)]) {
        [self.delegate playerCellClickedMinusButton:self];
        [self.delegate playerCellDidHideNewScoreView:self];
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
    
    [self moveToOriginalFrameAnimated];
    
    if (![NSString isNilOrEmpty:textField.text]) {
        if ([self.delegate respondsToSelector:@selector(playerCellClickedPlusButton:)]) {
            [self.delegate playerCellClickedPlusButton:self];
        }
    }
    
    [self.delegate playerCellDidHideNewScoreView:self];
    
    return YES;
}

#pragma mark - horizontal pan gesture methods
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) return NO;
    
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // check if is a horizontal gesture
    if (fabs(translation.x) > fabs(translation.y)) {
        return YES;
    }
    return NO;
}

#pragma mark - pan gesture handler overriden from base class

- (void)moveToOriginalFrameAnimated {
    CGRect originalFrame = CGRectMake(0.0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.frame = originalFrame;
                     }];
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture {
    [super panGestureHandler:panGesture];
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        self.displaysLeftSide = self.frame.origin.x > self.frame.size.width / 3.0;
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        if (self.displaysLeftSide == NO) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerCellDidHideNewScoreView:)]) {
                [self.delegate playerCellDidHideNewScoreView:self];
                [self moveToOriginalFrameAnimated];
                [_scoreTextField resignFirstResponder];
            }
        } else {
            [self showLeftView];
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.displaysLeftSide && point.x < 0) {
        return YES;
    }
    
    return [super pointInside:point withEvent:event];
}

- (void)showLeftView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerCellShouldShowNewScoreView:)]) {
        if ([self.delegate playerCellShouldShowNewScoreView:self]) {
            if ([self.delegate respondsToSelector:@selector(playerCellDidShowNewScoreView:)]) {
                [self.delegate playerCellDidShowNewScoreView:self];
                self.frame = CGRectMake(self.bounds.size.width / 3.0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
                [_scoreTextField becomeFirstResponder];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(playerCellDidHideNewScoreView:)]) {
                [self.delegate playerCellDidHideNewScoreView:self];
                [self moveToOriginalFrameAnimated];
                [_scoreTextField resignFirstResponder];
            }
        }
    }
}

- (IBAction)totalScoresButtonClicked:(id)sender {
    [self showLeftView];
}

@end
