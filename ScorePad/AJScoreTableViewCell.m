//
//  AJScoreTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 11/20/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoreTableViewCell.h"
#import "AJBrownUnderlinedView.h"

#import "UIFont+Additions.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"

@interface AJScoreTableViewCell() {
    AJBrownUnderlinedView *_backgroundView;
    AJBrownUnderlinedView *_leftBackgroundView;
    
    UILabel *_roundLabel;
    UILabel *_scoreLabel;
    UILabel *_intermediateTotalLabel;
}

@end


@implementation AJScoreTableViewCell

@synthesize scoreTextField = _scoreTextField;

@synthesize round = _round;
@synthesize score = _score;
@synthesize intermediateTotal = _intermediateTotal;

@synthesize displaysLeftSide = _displaysLeftSide;

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) return nil;
    
    _backgroundView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_backgroundView];
    [_backgroundView release];
    
    _roundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _roundLabel.font = [UIFont LDBrushFontWithSize:30.0];
    _roundLabel.backgroundColor = [UIColor clearColor];
    _roundLabel.textAlignment = UITextAlignmentCenter;
    [_backgroundView addSubview:_roundLabel];
    [_roundLabel release];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _scoreLabel.font = [UIFont LDBrushFontWithSize:40.0];
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textAlignment = UITextAlignmentCenter;
    [_backgroundView addSubview:_scoreLabel];
    [_scoreLabel release];
    
    _intermediateTotalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _intermediateTotalLabel.font = [UIFont LDBrushFontWithSize:30.0];
    _intermediateTotalLabel.backgroundColor = [UIColor clearColor];
    _intermediateTotalLabel.textAlignment = UITextAlignmentCenter;
    [_backgroundView addSubview:_intermediateTotalLabel];
    [_intermediateTotalLabel release];
    
    _leftBackgroundView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
    [self addSubview:_leftBackgroundView];
    [_leftBackgroundView release];
    
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
    [_leftBackgroundView addSubview:_scoreTextField];
    [_scoreTextField release];
    
    _plusMinusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_plusMinusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
    _plusMinusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
    [_plusMinusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [_plusMinusButton setTitle:@"+/-" forState:UIControlStateNormal];
    [_plusMinusButton addTarget:self action:@selector(plusMinusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBackgroundView addSubview:_plusMinusButton];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height;
    CGFloat cellWidth = self.contentView.bounds.size.width;
    
    _backgroundView.frame = self.contentView.bounds;
    _roundLabel.frame = CGRectMake(10.0, 0.0, 40.0, cellHeight);
    _scoreLabel.frame = CGRectMake(135.0, 0.0, 50.0, cellHeight);
    _intermediateTotalLabel.frame = CGRectMake(260.0, 0.0, 40.0, cellHeight);
    
    _leftBackgroundView.frame = CGRectMake(-cellWidth, 0.0, cellWidth, cellHeight);
    _scoreTextField.frame = CGRectMake(cellWidth - 65.0, 1.0, 65.0, 31.0);
    _plusMinusButton.frame = CGRectMake(cellWidth - 105.0, 1.0, 38.0, 31.0);
    
}

- (void)setScore:(double)score {
    _score = score;
    _scoreLabel.text = [NSString stringWithFormat:@"%g", score];
    _scoreTextField.text = [NSString stringWithFormat:@"%g", score];
    
    if (score < 0) {
        _scoreLabel.textColor = [UIColor brownColor];
    } else {
        _scoreLabel.textColor = [UIColor blackColor];
    }
}

- (void)setRound:(int)round {
    _round = round;
    _roundLabel.text = [NSString stringWithFormat:@"%d", round];
}

- (void)setIntermediateTotal:(double)intermediateTotal {
    _intermediateTotal = intermediateTotal;
    _intermediateTotalLabel.text = [NSString stringWithFormat:@"%g", intermediateTotal];
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

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture {
    [super panGestureHandler:panGesture];
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        self.displaysLeftSide = self.frame.origin.x > self.frame.size.width / 3.0;
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        if (self.displaysLeftSide == NO) {
            [self hideLeftView];
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

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(scoreCellShouldStartEditingScore:)]) {
        [self.delegate scoreCellShouldStartEditingScore:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self moveToOriginalFrameAnimated];
    
    if (![NSString isNilOrEmpty:textField.text] && (textField.text.doubleValue != self.score)) {
        if ([self.delegate respondsToSelector:@selector(scoreCellDidEndEditingScore:)]) {
            [self.delegate scoreCellDidEndEditingScore:self];
        }
    }
    
    [self.delegate scoreCellDidHideLeftView:self];
    
    return YES;
}

#pragma mark - helpers

- (void)moveToOriginalFrameAnimated {
    CGRect originalFrame = CGRectMake(0.0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.frame = originalFrame;
                     }];
}

- (void)showLeftView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scoreCellShouldShowLeftView:)]) {
        if ([self.delegate scoreCellShouldShowLeftView:self]) {
            if ([self.delegate respondsToSelector:@selector(scoreCellDidShowLeftView:)]) {
                [self.delegate scoreCellDidShowLeftView:self];
                self.frame = CGRectMake(self.bounds.size.width / 3.0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
                [_scoreTextField becomeFirstResponder];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(scoreCellDidHideLeftView:)]) {
                [self.delegate scoreCellDidHideLeftView:self];
                [self moveToOriginalFrameAnimated];
                [_scoreTextField resignFirstResponder];
            }
        }
    }
}

- (void)hideLeftView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scoreCellDidHideLeftView:)]) {
        [self.delegate scoreCellDidHideLeftView:self];
        [self moveToOriginalFrameAnimated];
        [_scoreTextField resignFirstResponder];
    }
}

#pragma mark - Buttons actions

- (IBAction)plusMinusButtonClicked:(id)sender {
    [self setScore:-self.score];
}

@end
