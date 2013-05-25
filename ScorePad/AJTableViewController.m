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

@synthesize tableView = _tableView;


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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.separatorColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:0.3];
    [self.view addSubview:_tableView];
    
    [self addKeyboardNotifications];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-clear2.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)dealloc {
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
    
    [self removeKeyboardNotifications];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark Keyboard State Management

//- (void)keyboardWillShow:(NSNotification *)aNotif {
//    NSDictionary *userInfo = [aNotif userInfo];
//	NSTimeInterval keyboardAnimDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//	UIViewAnimationCurve keyboardAnimCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
//	CGRect keyboardFrameBegin = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:nil];
//	CGRect keyboardFrameEnd = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
//    
//	// If the keyboard will slide horizontally then we don't want any animation to be done.
//	// We only want animation when the keyboard will slide to/from bottom
//	BOOL keyboardSlidesVeritcally = (keyboardFrameBegin.origin.y != keyboardFrameEnd.origin.y);
//	
//	if (keyboardSlidesVeritcally) {
//        
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationCurve:keyboardAnimCurve];
//		[UIView setAnimationDuration:keyboardAnimDuration];
//		[UIView setAnimationBeginsFromCurrentState:YES];
//        
//	}
//    
//    CGRect tableViewBounds = self.tableView.frame;
//    NSLog(@"table view bounds %@", NSStringFromCGRect(tableViewBounds));
//    NSLog(@"view controller bounds %@", NSStringFromCGRect(self.view.bounds));
//    NSLog(@"keyboard frameEnd: %@", NSStringFromCGRect(keyboardFrameEnd));
//    CGFloat keyboardSizeHeight = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? keyboardFrameEnd.size.height : keyboardFrameEnd.size.width;
//	tableViewBounds.size.height = self.view.bounds.size.height - keyboardSizeHeight;
//    NSLog(@"new table bounds %@", NSStringFromCGRect(tableViewBounds));
//    self.tableView.frame = tableViewBounds;
//    
//    if (keyboardSlidesVeritcally) {
//		[UIView commitAnimations];
//	}
//}
//
//- (void)keyboardWillHide:(NSNotification *)aNotif {
//    NSDictionary *userInfo = [aNotif userInfo];
//	NSTimeInterval keyboardAnimDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//	UIViewAnimationCurve keyboardAnimCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
//	CGRect keyboardFrameBegin = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:nil];
//	CGRect keyboardFrameEnd = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
//	
//	// If the keyboard will slide horizontally then we don't want any animation to be done.
//	// We only want animation when the keyboard will slide to/from bottom
//	BOOL keyboardSlidesVeritcally = (keyboardFrameBegin.origin.y != keyboardFrameEnd.origin.y);
//	
//	if (keyboardSlidesVeritcally) {
//        
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationCurve:keyboardAnimCurve];
//		[UIView setAnimationDuration:keyboardAnimDuration];
//    }
//    
//    CGRect tableViewBounds = self.tableView.frame;
//    NSLog(@"table view bounds %@", NSStringFromCGRect(tableViewBounds));
//    NSLog(@"view controller bounds %@", NSStringFromCGRect(self.view.bounds));
//	tableViewBounds.size.height = self.view.bounds.size.height;
//    self.tableView.frame = tableViewBounds;
//    
//    [UIView commitAnimations];
//}

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
