//
//  AJVerticalPlayerView.m
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJVerticalPlayerView.h"

#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface AJVerticalPlayerHeaderView : UIView

@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UILabel *totalLabel;

@end


@interface AJVerticalPlayerView()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, strong) NSArray *scores;

@property (nonatomic, assign) double maxViewHeight;

@property (nonatomic, strong) UIImageView *rightSeparatorView;
@property (nonatomic, strong) UIImageView *leftSeparatorView;
@end


@implementation AJVerticalPlayerView

- (id)initWithFrame:(CGRect)frame andName:(NSString *)name andScores:(NSArray *)scores andColor:(NSString *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.name = name;
        self.scores = scores;
        self.color = color;
        
        AJVerticalPlayerHeaderView *headerView = [[AJVerticalPlayerHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 60.0)];
        [headerView.nameButton setTitle:self.name forState:UIControlStateNormal];
        [headerView.nameButton setTitleColor:[UIColor colorWithHexString:self.color] forState:UIControlStateNormal];
        [headerView.nameButton addTarget:self action:@selector(nameButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headerView];
        
        double sum = 0.0;
        for (int scoreIndex = 0; scoreIndex < [self.scores count]; scoreIndex++) {
            UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 60.0 + 30 * scoreIndex, frame.size.width, 30.0)];
            [scoreLabel setBackgroundColor:[UIColor clearColor]];
            [scoreLabel setTextAlignment:UITextAlignmentCenter];
            double value = [[scores objectAtIndex:scoreIndex] doubleValue];
            sum += value;
            [scoreLabel setText:[NSString stringWithFormat:@"%g", value]];
            [scoreLabel setFont:[UIFont LDBrushFontWithSize:30.0]];
            scoreLabel.textColor = (value >= 0.0) ? [UIColor blackColor] : [UIColor brownColor];
            [self addSubview:scoreLabel];
        }
        [headerView.totalLabel setText:[NSString stringWithFormat:@"%g", sum]];
        
        UIImage *sepImage = [[UIImage imageNamed:@"separator_vertical.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 1.0, 40.0, 3.0)];
        
        self.rightSeparatorView = [[UIImageView alloc] initWithImage:sepImage];
        CGFloat separatorX = CGRectGetWidth(frame) - sepImage.size.width;
        self.rightSeparatorView.frame = (CGRect){{separatorX, 0.0}, {sepImage.size.width, frame.size.height}};
        [self addSubview:self.rightSeparatorView];
        
        self.leftSeparatorView = [[UIImageView alloc] initWithImage:sepImage];
        self.leftSeparatorView.frame = (CGRect){CGPointZero, {sepImage.size.width, frame.size.height}};
        [self addSubview:self.leftSeparatorView];
        self.leftSeparatorView.hidden = YES;
    }
    return self;
}

- (void)setIsFirstColumn:(BOOL)isFirstColumn {
    self.leftSeparatorView.hidden = !isFirstColumn;
}

- (IBAction)nameButtonCliked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(verticalPlayerViewDidClickName:)]) {
        [self.delegate verticalPlayerViewDidClickName:self];
    }
}

@end



@implementation AJVerticalPlayerHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nameButton.frame = CGRectMake(0.0, 4.0, frame.size.width, 25.0);
    self.nameButton.backgroundColor = [UIColor clearColor];
    [self.nameButton.titleLabel setFont:[UIFont LDBrushFontWithSize:35.0]];
    [self.nameButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:self.nameButton];
    
    
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 33.0, frame.size.width, 37.0)];
    [self.totalLabel setBackgroundColor:[UIColor clearColor]];
    [self.totalLabel setTextColor:[UIColor AJPurpleColor]];
    [self.totalLabel setTextAlignment:UITextAlignmentCenter];
    [self.totalLabel setFont:[UIFont LDBrushFontWithSize:45.0]];
    [self addSubview:self.totalLabel];
    
    return self;
}

@end
