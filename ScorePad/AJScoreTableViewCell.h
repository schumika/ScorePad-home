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

@interface AJScoreTableViewCell : AJPanDeleteTableViewCell <UITextFieldDelegate> 

@property (nonatomic, strong) NSDictionary *scoreDictionary;

@property (nonatomic, readonly) UITextField *scoreTextField;
@property (nonatomic, assign) BOOL displaysLeftSide;

@property (nonatomic, weak) id<AJScoreTableViewCellDelegate> delegate;

- (void)showLeftView;
- (void)hideLeftView;

@end


@protocol AJScoreTableViewCellDelegate <NSObject>

- (void)scoreCellShouldStartEditingScore:(AJScoreTableViewCell *)cell;
- (void)scoreCell:(AJScoreTableViewCell *)cell didEndEditingScoreWithNewScoreValue:(NSNumber *)newScore;

- (BOOL)scoreCellShouldShowLeftView:(AJScoreTableViewCell *)cell;
- (void)scoreCellDidShowLeftView:(AJScoreTableViewCell *)cell;
- (void)scoreCellDidHideLeftView:(AJScoreTableViewCell *)cell;

@end
