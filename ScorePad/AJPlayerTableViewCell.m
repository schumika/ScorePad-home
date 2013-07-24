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


@interface AJPlayerTableViewCell ()
@property (nonatomic, strong)    UIImageView *pictureView;
@property (nonatomic, strong)    UILabel *nameLabel;
@property (nonatomic, strong)    UIButton *totalScoresButton;
@property (nonatomic, strong)    UILabel *roundsPlayedLabel;
@property (nonatomic, strong)    AJBrownUnderlinedView *underlinedView;
@property (nonatomic, strong)    UIImageView *grabImageView;
@property (nonatomic, strong)    UIImageView *lineSeparatorView;
@property (nonatomic, strong)    UIImageView *disclosureView;

@property (nonatomic, strong)    UIButton *plusButton;
@property (nonatomic, strong)    UIButton *minusButton;

@property (nonatomic, strong, readwrite)    UITextField *scoreTextField;

@end


@implementation AJPlayerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _grabImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rip.png"]];
        _grabImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_grabImageView];
        
        self.pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:self.pictureView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor brownColor];
        //self.nameLabel.font = [UIFont fontWithName:@"Zapfino" size:20.0];
        //self.nameLabel.font = [UIFont handwritingBoldFontWithSize:45.0];
        self.nameLabel.font = [UIFont LDBrushFontWithSize:55.0];
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.minimumFontSize = 25.0;
        self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.nameLabel];
        
        self.totalScoresButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.totalScoresButton.backgroundColor = [UIColor clearColor];
        [self.totalScoresButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        //_totalScoresLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:40.0];
        //_totalScoresLabel.font = [UIFont handwritingFontWithSize:45.0];
        self.totalScoresButton.titleLabel.font = [UIFont LDBrushFontWithSize:65.0];
        self.totalScoresButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.totalScoresButton.titleLabel.textAlignment = UITextAlignmentCenter;
        self.totalScoresButton.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.totalScoresButton addTarget:self action:@selector(totalScoresButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.totalScoresButton];
        
        self.roundsPlayedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.roundsPlayedLabel.backgroundColor = [UIColor clearColor];
        self.roundsPlayedLabel.textColor = [UIColor grayColor];
        self.roundsPlayedLabel.textAlignment = UITextAlignmentCenter;
        self.roundsPlayedLabel.font = [UIFont fontWithName:@"Thonburi" size:12.0];
        self.roundsPlayedLabel.adjustsFontSizeToFitWidth = YES;
        self.roundsPlayedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.roundsPlayedLabel];
        
        self.lineSeparatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_new2.png"]];
        [self.contentView addSubview:self.lineSeparatorView];
        
        self.disclosureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure.png"]];
        [self.contentView addSubview:self.disclosureView];
        
        self.underlinedView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.underlinedView];
        
        self.scoreTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.scoreTextField.borderStyle = UITextBorderStyleNone;
        self.scoreTextField.background = [UIImage roundTextFieldImage];
        self.scoreTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.scoreTextField.placeholder = [NSString stringWithFormat:@"%g",0.0];
        self.scoreTextField.font = [UIFont fontWithName:@"Thonburi" size:17.0];
        self.scoreTextField.textColor = [UIColor brownColor];
        self.scoreTextField.textAlignment = UITextAlignmentCenter;
        self.scoreTextField.delegate = self;
        self.scoreTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.underlinedView addSubview:self.scoreTextField];
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.plusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
        self.plusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
        [self.plusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [self.plusButton setTitle:@"+" forState:UIControlStateNormal];
        [self.plusButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.underlinedView addSubview:self.plusButton];
        
        self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.minusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
        self.minusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
        [self.minusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [self.minusButton setTitle:@"-" forState:UIControlStateNormal];
        [self.minusButton addTarget:self action:@selector(minusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.underlinedView addSubview:self.minusButton];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height, cellWidth = self.contentView.bounds.size.width;
    
    _grabImageView.frame = CGRectMake(3.0, 0.0, 12.0, 70.0);
    self.pictureView.frame = CGRectMake(30.0, 17.0, 35.0, 35.0);
    self.nameLabel.frame = CGRectMake(70.0, 5.0, 130.0, 65.0);
    self.totalScoresButton.frame = CGRectMake(cellWidth - 118.0, 10.0, 91.0, 50.0);
    self.roundsPlayedLabel.frame = CGRectMake(cellWidth - 118.0, 55.0, 91.0, 10.0);
    
    self.lineSeparatorView.frame = CGRectMake(0.0, cellHeight - 2.0, cellWidth, 2.0);
    self.disclosureView.frame = CGRectMake(cellWidth - 22.0, ceil((cellHeight - 20.0) / 2.0), 20.0, 20.0);
    
    self.underlinedView.frame = CGRectMake(-cellWidth, 0, cellWidth, self.frame.size.height);
    self.scoreTextField.frame = CGRectMake(cellWidth - 100.0, 2.0, 85.0, 31.0);
    self.plusButton.frame = CGRectMake(cellWidth - 100.0, 35.0, 40.0, 31.0);
    self.minusButton.frame = CGRectMake(cellWidth - 55.0, 35.0, 40.0, 31.0);
}


- (void)setName:(NSString *)name {
    if (name != _name) {
        _name = name;
        
        self.nameLabel.text = _name;
    }
}

- (void)setColor:(NSString *)color {
    if (color != _color) {
        _color = color;
        
        self.nameLabel.textColor = [UIColor colorWithHexString:_color];
    }
}

- (void)setPicture:(UIImage *)picture {
    if (picture != _picture) {
        _picture = picture;
        
        [self.pictureView setImage:[_picture applyMask:[UIImage imageNamed:@"mask.png"]]];
    }
}

- (void)setTotalScores:(double)totalScores {
    _totalScores = totalScores;
    
    [self.totalScoresButton setTitle:[NSString stringWithFormat:@"%g", _totalScores] forState:UIControlStateNormal];
}

- (void)setNumberOfRounds:(int)numberOfRounds {
    _numberOfRounds = numberOfRounds;
    
    self.roundsPlayedLabel.text = [NSString stringWithFormat:@"%d %@ played", _numberOfRounds, (_numberOfRounds == 1) ? @"round" : @"rounds"];
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

- (IBAction)totalScoresButtonClicked:(id)sender {
    self.displaysLeftSide = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self showLeftView];
    }];
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
                [self.scoreTextField resignFirstResponder];
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
                [self.scoreTextField becomeFirstResponder];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(playerCellDidHideNewScoreView:)]) {
                [self.delegate playerCellDidHideNewScoreView:self];
                [self moveToOriginalFrameAnimated];
                [self.scoreTextField resignFirstResponder];
            }
        }
    }
}

@end
