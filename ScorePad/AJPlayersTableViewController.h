//
//  AJPlayersTableViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"
#import "AJScrollView.h"
#import "AJVerticalPlayerView.h"
#import "AJPlayerTableViewCell.h"

#import "AJSettingsViewController.h"

typedef enum {
    AJPlayersSortingNone = 0,
    AJPlayersSortingByTotalASC,
    AJPlayersSortingByTotalDESC,
    AJPlayersSortingByNameASC,
    AJPlayersSortingByNameDESC
} AJPlayersSortingType;

@interface AJPlayersTableViewController : AJTableViewController <UITextFieldDelegate, AJSettingsViewControllerDelegate, UIAlertViewDelegate,
                                            AJVerticalPlayerViewDelegate, AJPlayerTableViewCellDelegate, AJPanDeleteTableViewCellDelegate> {
    AJGame *_game;
    
    NSArray *_playersArray;
    AJScrollView *_scrollView;
}

@property (nonatomic, retain) AJGame *game;
@property (nonatomic, retain) NSArray *playersArray;

@property (nonatomic, assign) AJPlayersSortingType playersSortingType;

@end
