//
//  AJGamesTableViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJTableViewController.h"
#import "AJPanDeleteTableViewCell.h"

@interface AJGamesTableViewController : AJTableViewController <UITextFieldDelegate, UIAlertViewDelegate,
                                                                AJPanDeleteTableViewCellDelegate>

@end
