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

@interface AJTableViewController : AJViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

- (id)initWithStyle:(UITableViewStyle)style;

@end


