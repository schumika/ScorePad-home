//
//  AJGamesTableViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJTableViewController.h"

@interface AJGamesTableViewController : AJTableViewController <UITextFieldDelegate> {
    NSArray *_gamesArray;
    
    UIBarButtonItem *_editBarButton;
    UIBarButtonItem *_doneBarButton;
}

@property (nonatomic, retain) NSArray *gamesArray;

@end
