//
//  AJScoreTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 11/20/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPanDeleteTableViewCell.h"

@protocol AJScoreTableViewCellDelegate;

@interface AJScoreTableViewCell : AJPanDeleteTableViewCell <UITextFieldDelegate> {
    UITextField *_scoreTextField;
    UIButton *_plusMinusButton;
    
    BOOL _displaysLeftSide;
}

@property (nonatomic, readonly) UITextField *scoreTextField;

@property (nonatomic, assign) int round;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double intermediateTotal;

@property (nonatomic, assign) BOOL displaysLeftSide;

@property (nonatomic, weak) id<AJScoreTableViewCellDelegate> delegate;

- (void)showLeftView;
- (void)hideLeftView;

@end


@protocol AJScoreTableViewCellDelegate <NSObject>

- (void)scoreCellShouldStartEditingScore:(AJScoreTableViewCell *)cell;
- (void)scoreCellDidEndEditingScore:(AJScoreTableViewCell *)cell;
//- (void)scoreCellClickedPlusButton:(AJScoreTableViewCell *)cell;
//- (void)scoreCellClickedMinusButton:(AJScoreTableViewCell *)cell;

- (BOOL)scoreCellShouldShowLeftView:(AJScoreTableViewCell *)cell;
- (void)scoreCellDidShowLeftView:(AJScoreTableViewCell *)cell;
- (void)scoreCellDidHideLeftView:(AJScoreTableViewCell *)cell;

@end
