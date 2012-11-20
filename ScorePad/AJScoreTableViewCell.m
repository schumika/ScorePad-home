//
//  AJScoreTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 11/20/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoreTableViewCell.h"

@interface AJScoreTableViewCell() {
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
    
    _roundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _roundLabel.font = [UIFont fontWithName:@"Thonburi" size:17.0];
    _roundLabel.backgroundColor = [UIColor clearColor];
    _roundLabel.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:_roundLabel];
    [_roundLabel release];
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _scoreLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:22.0];
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:_scoreLabel];
    [_scoreLabel release];
    
    _intermediateTotalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _intermediateTotalLabel.font = [UIFont fontWithName:@"Thonburi" size:17.0];
    _intermediateTotalLabel.backgroundColor = [UIColor clearColor];
    _intermediateTotalLabel.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:_intermediateTotalLabel];
    [_intermediateTotalLabel release];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelHeight = self.contentView.bounds.size.height;
    _roundLabel.frame = CGRectMake(10.0, 0.0, 40.0, labelHeight);
    _scoreLabel.frame = CGRectMake(140.0, 0.0, 40.0, labelHeight);
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
