//
//  AJPlayerTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPanDeleteTableViewCell.h"

@protocol AJPlayerTableViewCellDelegate;

@interface AJPlayerTableViewCell : AJPanDeleteTableViewCell <UITextFieldDelegate> {
    NSString *_name;
    NSString *_color;
    UIImage *_picture;
    double _totalScores;
    int _numberOfRounds;
    
    BOOL _displaysLeftSide;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, assign) double totalScores;
@property (nonatomic, assign) int numberOfRounds;

@property (nonatomic, assign) BOOL displaysLeftSide;

@property (nonatomic, weak) id<AJPlayerTableViewCellDelegate> delegate;

@property (nonatomic, readonly) UITextField *scoreTextField;

- (void)showLeftView;

@end


@protocol AJPlayerTableViewCellDelegate <NSObject>

- (void)playerCellShouldStartEditingScore:(AJPlayerTableViewCell *)cell;
- (void)playerCellClickedPlusButton:(AJPlayerTableViewCell *)cell;
- (void)playerCellClickedMinusButton:(AJPlayerTableViewCell *)cell;

- (BOOL)playerCellShouldShowNewScoreView:(AJPlayerTableViewCell *)cell;
- (void)playerCellDidShowNewScoreView:(AJPlayerTableViewCell *)cell;
- (void)playerCellDidHideNewScoreView:(AJPlayerTableViewCell *)cell;

@end