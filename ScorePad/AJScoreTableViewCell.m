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

@interface AJScoreTableViewCell() {
    AJBrownUnderlinedView *_backView;
    
    UILabel *_roundLabel;
    UILabel *_scoreLabel;
    UILabel *_intermediateTotalLabel;
}

@end


@implementation AJScoreTableViewCell

@synthesize round = _round;
@synthesize score = _score;
@synthesize intermediateTotal = _intermediateTotal;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) return nil;
    
    _backView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_backView];
    [_backView release];
    
    _roundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _roundLabel.font = [UIFont LDBrushFontWithSize:30.0];
    _roundLabel.backgroundColor = [UIColor clearColor];
    _roundLabel.textAlignment = UITextAlignmentCenter;
    [_backView addSubview:_roundLabel];
    [_roundLabel release];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _scoreLabel.font = [UIFont LDBrushFontWithSize:40.0];
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textAlignment = UITextAlignmentCenter;
    [_backView addSubview:_scoreLabel];
    [_scoreLabel release];
    
    _intermediateTotalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _intermediateTotalLabel.font = [UIFont LDBrushFontWithSize:30.0];
    _intermediateTotalLabel.backgroundColor = [UIColor clearColor];
    _intermediateTotalLabel.textAlignment = UITextAlignmentCenter;
    [_backView addSubview:_intermediateTotalLabel];
    [_intermediateTotalLabel release];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelHeight = self.contentView.bounds.size.height;
    _backView.frame = self.contentView.bounds;
    _roundLabel.frame = CGRectMake(10.0, 0.0, 40.0, labelHeight);
    _scoreLabel.frame = CGRectMake(135.0, 0.0, 50.0, labelHeight);
    _intermediateTotalLabel.frame = CGRectMake(260.0, 0.0, 40.0, labelHeight);
}

- (void)setScore:(double)score {
    _score = score;
    _scoreLabel.text = [NSString stringWithFormat:@"%g", score];
    
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

@end
