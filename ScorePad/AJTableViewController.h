//
//  AJTableViewController.h
//  ScorePad
//
//  Created by Anca Calugar on 10/4/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBarButtonItem+Additions.h"
#import "AJViewController.h"

@interface AJTableViewController : AJViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    
    // UI customizations
    UILabel *_titleView;
    UIButton *_backButton;
    UIBarButtonItem *_backButtonItem;
}

@property (nonatomic, readonly) UITableView *tableView;

// UI customizations
@property (nonatomic, readonly) UILabel *titleView;
@property (nonatomic, readonly) UIBarButtonItem *backButtonItem;

// Private
@property (nonatomic, readonly) UIButton *backButton;

- (id)initWithStyle:(UITableViewStyle)style;
- (void)keyboardWillShow:(NSNotification *)aNotif;

// UI customizations
- (NSString *)titleViewText;
- (UIView *)titleView;
- (void)reloadTitleView;
- (NSString *)backButtonTitle;
- (IBAction)backButtonClicked:(id)sender;

@end


