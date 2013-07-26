//
//  AJScoreTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 11/20/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoreTableViewCell.h"
#import "AJBrownUnderlinedView.h"
#import "AJDefines.h"

#import "UIFont+Additions.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"

@interface AJScoreTableViewCell() 
@property (nonatomic, strong)    AJBrownUnderlinedView *backgroundView;
@property (nonatomic, strong)    AJBrownUnderlinedView *leftBackgroundView;
@property (nonatomic, strong)    UIButton *plusMinusButton;
    
@property (nonatomic, strong)    UILabel *roundLabel;
@property (nonatomic, strong)    UILabel *scoreLabel;
@property (nonatomic, strong)    UILabel *intermediateTotalLabel;
@property (nonatomic, readwrite) UITextField *scoreTextField;

@end


@implementation AJScoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) return nil;
    
    self.backgroundView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.backgroundView];
    
    self.roundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.roundLabel.font = [UIFont LDBrushFontWithSize:30.0];
    self.roundLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.roundLabel.backgroundColor = [UIColor clearColor];
    self.roundLabel.textAlignment = UITextAlignmentCenter;
    [self.backgroundView addSubview:self.roundLabel];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scoreLabel.font = [UIFont LDBrushFontWithSize:40.0];
    self.scoreLabel.backgroundColor = [UIColor clearColor];
    self.scoreLabel.textAlignment = UITextAlignmentCenter;
    [self.backgroundView addSubview:self.scoreLabel];
    
    self.intermediateTotalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.intermediateTotalLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    self.intermediateTotalLabel.font = [UIFont LDBrushFontWithSize:30.0];
    self.intermediateTotalLabel.backgroundColor = [UIColor clearColor];
    self.intermediateTotalLabel.textAlignment = UITextAlignmentCenter;
    [self.backgroundView addSubview:self.intermediateTotalLabel];
    
    self.leftBackgroundView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.leftBackgroundView];
    
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
    [self.leftBackgroundView addSubview:self.scoreTextField];
    
    self.plusMinusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.plusMinusButton setBackgroundImage:[UIImage roundTextFieldImage] forState:UIControlStateNormal];
    self.plusMinusButton.titleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:17.0];
    [self.plusMinusButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self.plusMinusButton setTitle:@"+/-" forState:UIControlStateNormal];
    [self.plusMinusButton addTarget:self action:@selector(plusMinusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBackgroundView addSubview:self.plusMinusButton];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height;
    CGFloat cellWidth = self.contentView.bounds.size.width;
    
    self.backgroundView.frame = self.contentView.bounds;
    CGFloat thirdWidth = ceil(cellWidth / 3.0);
    self.roundLabel.frame = CGRectMake(10.0, 0.0, 40.0, cellHeight);
    self.scoreLabel.frame = CGRectMake(thirdWidth * 1.3, 0.0, 50.0, cellHeight);
    self.intermediateTotalLabel.frame = CGRectMake(2.4*thirdWidth , 0.0, 40.0, cellHeight);
    
    self.leftBackgroundView.frame = CGRectMake(-cellWidth, 0.0, cellWidth, cellHeight);
    self.scoreTextField.frame = CGRectMake(cellWidth - 65.0, 1.0, 65.0, 31.0);
    self.plusMinusButton.frame = CGRectMake(cellWidth - 105.0, 1.0, 38.0, 31.0);
    
}

- (void)setScore:(double)score {
    self.scoreLabel.text = [NSString stringWithFormat:@"%g", score];
    self.scoreTextField.text = [NSString stringWithFormat:@"%g", score];
    
    if (score < 0) {
        self.scoreLabel.textColor = [UIColor brownColor];
    } else {
        self.scoreLabel.textColor = [UIColor blackColor];
    }
}

- (void)setScoreDictionary:(NSDictionary *)scoreDictionary {
    _scoreDictionary = scoreDictionary;
    
    [self setScore:[(NSNumber *)scoreDictionary[kAJScoreValueKey] doubleValue]];
    self.roundLabel.text = [NSString stringWithFormat:@"%d", [(NSNumber *)scoreDictionary[kAJScoreRoundKey] intValue]];
    self.intermediateTotalLabel.text = [NSString stringWithFormat:@"%g", [(NSNumber *)scoreDictionary[kAJScoreIntermediateTotal] doubleValue]];
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
    
    double score = [(NSNumber *)self.scoreDictionary[kAJScoreValueKey] doubleValue];
    if (![NSString isNilOrEmpty:textField.text] && (textField.text.doubleValue != score)) {
        if ([self.delegate respondsToSelector:@selector(scoreCell:didEndEditingScoreWithNewScoreValue:)]) {
            [self.delegate scoreCell:self didEndEditingScoreWithNewScoreValue:@(score)];
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
                [self.scoreTextField becomeFirstResponder];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(scoreCellDidHideLeftView:)]) {
                [self.delegate scoreCellDidHideLeftView:self];
                [self moveToOriginalFrameAnimated];
                [self.scoreTextField resignFirstResponder];
            }
        }
    }
}

- (void)hideLeftView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scoreCellDidHideLeftView:)]) {
        [self.delegate scoreCellDidHideLeftView:self];
        [self moveToOriginalFrameAnimated];
        [self.scoreTextField resignFirstResponder];
    }
}

#pragma mark - Buttons actions

- (IBAction)plusMinusButtonClicked:(id)sender {
    double newScore = -[(NSNumber *)self.scoreDictionary[kAJScoreValueKey] doubleValue];
    [self setScore:newScore];
    
    if ([self.delegate respondsToSelector:@selector(scoreCell:didEndEditingScoreWithNewScoreValue:)]) {
        [self.delegate scoreCell:self didEndEditingScoreWithNewScoreValue:@(newScore)];
    }

}

@end
