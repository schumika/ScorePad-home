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

@interface AJPlayersTableViewController : AJTableViewController <UITextFieldDelegate, AJSettingsViewControllerDelegate, UIAlertViewDelegate,
                                            AJVerticalPlayerViewDelegate, AJPlayerTableViewCellDelegate, AJPanDeleteTableViewCellDelegate>

@property (nonatomic, strong) AJGame *game;

@end
