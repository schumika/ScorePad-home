//
//  AJPlayerTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayerTableViewCell.h"
#import "AJUnderlinedView.h"

#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"



@interface AJPlayerTableViewCell () {
    UIImageView *_pictureView;
    UILabel *_nameLabel;
    UILabel *_totalScoresLabel;
    UILabel *_roundsPlayedLabel;
    AJUnderlinedView *_underlinedView;
    
    UITextField *_scoreTextField;
    UIButton *_plusButton;
    UIButton *_minusButton;
    
    UIButton *butt;
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
        _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_pictureView];
        [_pictureView release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor brownColor];
        _nameLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:30.0];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        _totalScoresLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalScoresLabel.backgroundColor = [UIColor clearColor];
        _totalScoresLabel.textColor = [UIColor brownColor];
        _totalScoresLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:40.0];
        _totalScoresLabel.adjustsFontSizeToFitWidth = YES;
        _totalScoresLabel.textAlignment = UITextAlignmentCenter;
        _totalScoresLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _totalScoresLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_totalScoresLabel];
        [_totalScoresLabel release];
        
        _roundsPlayedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roundsPlayedLabel.backgroundColor = [UIColor clearColor];
        _roundsPlayedLabel.textColor = [UIColor grayColor];
        _roundsPlayedLabel.textAlignment = UITextAlignmentCenter;
        _roundsPlayedLabel.font = [UIFont fontWithName:@"Thonburi" size:12.0];
        _roundsPlayedLabel.adjustsFontSizeToFitWidth = YES;
        _roundsPlayedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_roundsPlayedLabel];
        [_roundsPlayedLabel release];
        
        _underlinedView = [[AJUnderlinedView alloc] initWithFrame:CGRectZero];
        _underlinedView.underlineColor = [UIColor lightGrayColor];
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
    
    _pictureView.frame = CGRectMake(12.0, 15.0, 50.0, 50.0);
    _nameLabel.frame = CGRectMake(80.0, 13.0, 140.0, 53.0);
    _totalScoresLabel.frame = CGRectMake(192.0, 15.0, 91.0, 40.0);
    _roundsPlayedLabel.frame = CGRectMake(192.0, 63.0, 91.0, 10.0);
    
    CGFloat width = ceil(self.frame.size.width / 3.0);
    _underlinedView.frame = CGRectMake(-width, 0, width, self.frame.size.height);
    _scoreTextField.frame = CGRectMake(5.0, 5.0, 85.0, 31.0);
    _plusButton.frame = CGRectMake(5.0, 40.0, 40.0, 31.0);
    _minusButton.frame = CGRectMake(50.0, 40.0, 40.0, 31.0);
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
    
    if (![NSString isNilOrEmpty:textField.text]) {
        [self.delegate playerCellClickedPlusButton:self];
    }
    
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
        if (self.displaysLeftSide) {
            [butt setTitle:@"release" forState:UIControlStateNormal];
        } else {
            [butt setTitle:@"drag" forState:UIControlStateNormal];
        }
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        if (self.displaysLeftSide == NO) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerCellDidHideNewScoreView:)]) {
                [self.delegate playerCellDidHideNewScoreView:self];
                [self moveToOriginalFrameAnimated];
                [_scoreTextField resignFirstResponder];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerCellShouldShowNewScoreView:)]) {
                if ([self.delegate playerCellShouldShowNewScoreView:self]) {
                    if ([self.delegate respondsToSelector:@selector(playerCellDidShowNewScoreView:)]) {
                        [self.delegate playerCellDidShowNewScoreView:self];
                        self.frame = CGRectMake(self.bounds.size.width / 3.0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
                        [_scoreTextField becomeFirstResponder];
                    }
                } else {
                    /*if ([self.delegate respondsToSelector:@selector(playerCellDidHideNewScoreView:)]) {
                        [self.delegate playerCellDidHideNewScoreView:self];*/
                        [self moveToOriginalFrameAnimated];
                        [_scoreTextField resignFirstResponder];
                    //}
                }
            }
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.displaysLeftSide && point.x < 0) {
        return YES;
    }
    
    return [super pointInside:point withEvent:event];
}

@end
