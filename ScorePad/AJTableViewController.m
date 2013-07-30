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

- (void)updateNavigationBarWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation;

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
    
    [self updateNavigationBarWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [self updateToolbarWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setShadowImage:)]) {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    
    if ([self.navigationController.toolbar respondsToSelector:@selector(setShadowImage:forToolbarPosition:)]) {
        [self.navigationController.toolbar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:0.3];
    [self.view addSubview:self.tableView];
    
    [self addKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
     [self removeKeyboardNotifications];
}

- (void)dealloc {
    [self.tableView setDelegate:nil];
    [self.tableView setDataSource:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateNavigationBarWithOrientation:toInterfaceOrientation];
    [self updateToolbarWithOrientation:toInterfaceOrientation];
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

#pragma mark - Privates

- (void)updateNavigationBarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nav-bar-clear3.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 20.0, 2.0, 20.0)] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nav-bar-clear3-landscape.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 20.0, 2.0, 20.0)] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-clear3.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-clear3-landscape.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    }
}

@end
