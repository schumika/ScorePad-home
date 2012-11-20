//
//  AJScoresTableViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPlayer+Additions.h"
#import "AJSettingsViewController.h"
#import "AJScoreTableViewCell.h"

@interface AJScoresTableViewController : AJTableViewController <UITextFieldDelegate, AJSettingsViewControllerDelegate, AJPanDeleteTableViewCellDelegate> {
    NSArray *_scoresArray;
    
    UITextField *_newScoreTextField;
}

@property (nonatomic, retain) AJPlayer *player;
@property (nonatomic, retain) NSArray *scoresArray;

@end
