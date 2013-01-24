//
//  AJPanDeleteTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 11/17/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPanDeleteTableViewCell.h"
#import "AJUnderlinedView.h"
#import "AJBrownUnderlinedView.h"

@interface AJPanDeleteTableViewCell() {
    CGPoint _originalCenter;
    BOOL _shouldDelete;
    UILabel *_crossLabel;
    UILabel *_dragToDeleteLabel;
    
    AJBrownUnderlinedView *_underlinedView;
}

@end

@implementation AJPanDeleteTableViewCell

@synthesize panGestureDelegate = _panGestureDelegate;

const float LABEL_LEFT_MARGIN = 15.0f;
const float UI_CUES_MARGIN = 5.0f;
const float UI_CUES_WIDTH = 30.0f;
const float DRAG_LABEL_WIDTH = 150.0;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _underlinedView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        [self addSubview:_underlinedView];
        [_underlinedView release];
        
        _crossLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _crossLabel.textColor = [UIColor clearColor];
        _crossLabel.text = @"\u2717";
        _crossLabel.font = [UIFont boldSystemFontOfSize:32.0];
        _crossLabel.backgroundColor = [UIColor clearColor];
        [_underlinedView addSubview:_crossLabel];
        [_crossLabel release];
        
        _dragToDeleteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dragToDeleteLabel.textColor = [UIColor lightGrayColor];
        _dragToDeleteLabel.font = [UIFont systemFontOfSize:15.0];
        _dragToDeleteLabel.backgroundColor = [UIColor clearColor];
        [_underlinedView addSubview:_dragToDeleteLabel];
        [_dragToDeleteLabel release];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _underlinedView.frame = CGRectMake(self.bounds.size.width, 0.0, 320.0, self.bounds.size.height);
    
    _crossLabel.frame = CGRectMake(UI_CUES_MARGIN, 0.0, UI_CUES_WIDTH, self.bounds.size.height);
    _dragToDeleteLabel.frame = CGRectMake(CGRectGetMaxX(_crossLabel.frame) + 5.0, 0.0,
                                          DRAG_LABEL_WIDTH, self.bounds.size.height);
}

#pragma mark - horizontal pan gesture methods
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] == NO) {
        return NO;
    }
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // check if is a horizontal gesture
    if (fabs(translation.x) > fabs(translation.y) && (translation.x < 0)) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] == NO) {
        return NO;
    }
    
    return YES;
}

#pragma mark - pan gesture handler

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.center;
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _shouldDelete = self.frame.origin.x < -self.frame.size.width / 2.0;

        if (_shouldDelete) {
            _crossLabel.text = @"\u2717";
            _crossLabel.textColor = [UIColor redColor];
            _dragToDeleteLabel.text = @"release to delete...";
        } else {
            _crossLabel.text = @"\u2190";
            _crossLabel.textColor = [UIColor lightGrayColor];
            _dragToDeleteLabel.text = @"drag to delete...";
        }
       
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        CGRect originalFrame = CGRectMake(0.0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.frame = originalFrame;
                         }];
        
        if (_shouldDelete) {
            if ([self.panGestureDelegate respondsToSelector:@selector(panDeleteCellDraggedToDelete:)]) {
                [self.panGestureDelegate panDeleteCellDraggedToDelete:self];
            }
        }
    }
}

@end
