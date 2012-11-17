//
//  AJTableViewController.m
//  ScorePad
//
//  Created by Anca Calugar on 10/4/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJTableViewController.h"
#import "UIColor+Additions.h"

@interface AJTableViewController ()

- (void)addKeyboardNotifications;
- (void)removeKeyboardNotifications;

@end


@implementation AJTableViewController

@synthesize tableView = _tableView;

@synthesize titleView = _titleView;
@dynamic backButtonItem;
@dynamic backButton;

- (id)initWithStyle:(UITableViewStyle)tableViewStyle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor brownColor];
        _tableView = [[UITableView alloc] initWithFrame:/*CGRectInset(*/self.view.bounds/*, 10.0, 0.0)*/ style:tableViewStyle];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:0.3];
        [self.view addSubview:_tableView];
        [_tableView release];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self titleView];
    
    if (self.navigationItem.hidesBackButton == NO && self.backButtonItem) {
        self.navigationItem.leftBarButtonItem = self.backButtonItem;
    }
    
    [self addKeyboardNotifications];
}

- (void)dealloc {
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
    
    [_titleView release];
    [_backButtonItem release];
    [_backButton release];
    
    [self removeKeyboardNotifications];
    
    [super dealloc];
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

- (void)addKeyboardNotifications {
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}


- (void)keyboardWillShow:(NSNotification *)aNotif {
    NSDictionary *userInfo = [aNotif userInfo];
	NSTimeInterval keyboardAnimDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve keyboardAnimCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
	CGRect keyboardFrameBegin = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:nil];
	CGRect keyboardFrameEnd = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    
	// If the keyboard will slide horizontally then we don't want any animation to be done.
	// We only want animation when the keyboard will slide to/from bottom
	BOOL keyboardSlidesVeritcally = (keyboardFrameBegin.origin.y != keyboardFrameEnd.origin.y);
	
	if (keyboardSlidesVeritcally) {
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:keyboardAnimCurve];
		[UIView setAnimationDuration:keyboardAnimDuration];
		[UIView setAnimationBeginsFromCurrentState:YES];
        
	}
    
    CGRect tableViewBounds = self.tableView.frame;
	tableViewBounds.size.height = self.view.bounds.size.height - keyboardFrameEnd.size.height;
    self.tableView.frame = tableViewBounds;
    
    if (keyboardSlidesVeritcally) {
		[UIView commitAnimations];
	}
}

- (void)keyboardWillHide:(NSNotification *)aNotif {
    NSDictionary *userInfo = [aNotif userInfo];
	NSTimeInterval keyboardAnimDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve keyboardAnimCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
	CGRect keyboardFrameBegin = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:nil];
	CGRect keyboardFrameEnd = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
	
	// If the keyboard will slide horizontally then we don't want any animation to be done.
	// We only want animation when the keyboard will slide to/from bottom
	BOOL keyboardSlidesVeritcally = (keyboardFrameBegin.origin.y != keyboardFrameEnd.origin.y);
	
	if (keyboardSlidesVeritcally) {
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:keyboardAnimCurve];
		[UIView setAnimationDuration:keyboardAnimDuration];
    }
    
    CGRect tableViewBounds = self.tableView.frame;
	tableViewBounds.size.height = self.view.bounds.size.height;
    self.tableView.frame = tableViewBounds;
    
    [UIView commitAnimations];
}

- (void)removeKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - UI related

- (NSString *)titleViewText {
    return @"";
}

- (UILabel *)titleView {
    if (_titleView == nil) {
        _titleView = [[UILabel alloc] initWithFrame:/*self.navigationController.navigationBar.bounds]*/ CGRectMake(0.0, 20.0, 320.0, 44.0)];
        _titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.lineBreakMode = UILineBreakModeTailTruncation;
        _titleView.shadowColor = [UIColor blackColor];
        _titleView.shadowOffset = CGSizeMake(0, -1);
        _titleView.textAlignment = UITextAlignmentCenter;
        _titleView.textColor = [UIColor whiteColor];
        _titleView.font = [UIFont fontWithName:@"Thonburi-Bold" size:25.0];
        _titleView.text = [self titleViewText];
    }
    
    return _titleView;
}

- (void)reloadTitleView {
    _titleView.text = [self titleViewText];
}

- (UIButton *)backButton {
    if (!_backButton) {
        UIImage *backImage = [[UIImage imageNamed:@"back-button"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        
        _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_backButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [_backButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
        [_backButton setTitle:[self backButtonTitle] forState:UIControlStateNormal];
        [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0)];
        [_backButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [_backButton.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:17.0]];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        CGSize buttonSize = [[self backButtonTitle] sizeWithFont:_backButton.titleLabel.font];
        CGFloat marginSpace = 20.0f;
        _backButton.frame = CGRectMake(0, 0, buttonSize.width + marginSpace, 30);
    }
    
    return _backButton;
}

- (UIBarButtonItem *)backButtonItem {
    if (!_backButtonItem) {
        _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self backButton]];
    }
    
    return _backButtonItem;
}

- (NSString *)backButtonTitle {
    return @"back";
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
