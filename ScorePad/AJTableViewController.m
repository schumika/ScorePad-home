//
//  AJTableViewController.m
//  ScorePad
//
//  Created by Anca Calugar on 10/4/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJTableViewController.h"
#import "UIColor+Additions.h"

@interface AJTableViewController () {
    UITableViewStyle _tableViewStyle;
}

@end


@implementation AJTableViewController


- (id)initWithStyle:(UITableViewStyle)tableViewStyle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tableViewStyle = tableViewStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:0.3];
    [self.view addSubview:self.tableView];
    
    [self addKeyboardNotifications];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-clear2.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)dealloc {
    [self.tableView setDelegate:nil];
    [self.tableView setDataSource:nil];
    
    [self removeKeyboardNotifications];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

#pragma mark - Keyboard State Management

- (void)keyboardStateChanged:(NSNotification*)notification;
{
    CGRect keyboardRect = CGRectZero;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    UIEdgeInsets newInsets = UIEdgeInsetsZero;
    if(notification.name == UIKeyboardDidShowNotification) {
        // thats only correct, if your view ends at the bottom of the screen
        // otherwise subtract the difference from the inset
        newInsets.bottom = keyboardRect.size.height;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentInset = newInsets;
        self.tableView.scrollIndicatorInsets = newInsets;
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotif {
    CGRect keyboardRect = CGRectZero;
    [[aNotif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    UIEdgeInsets newInsets = UIEdgeInsetsZero;
    newInsets.bottom = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) ? keyboardRect.size.height : keyboardRect.size.width;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentInset = newInsets;
        self.tableView.scrollIndicatorInsets = newInsets;
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotif {
    CGRect keyboardRect = CGRectZero;
    [[aNotif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    UIEdgeInsets newInsets = UIEdgeInsetsZero;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentInset = newInsets;
        self.tableView.scrollIndicatorInsets = newInsets;
    }];
}

@end
