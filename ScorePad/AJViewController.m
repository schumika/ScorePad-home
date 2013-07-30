//
//  AJViewController.m
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJViewController.h"

#import "UIBarButtonItem+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"


@interface AJViewController ()

@property (nonatomic, strong) UILabel *titleView;

- (void)updateNavigationBarWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end


@implementation AJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateNavigationBarWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [self updateToolbarWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setShadowImage:)]) {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    
    if ([self.navigationController.toolbar respondsToSelector:@selector(setShadowImage:forToolbarPosition:)]) {
        [self.navigationController.toolbar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    }
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem simpleBackButtonItemWithTarget:self action:@selector(backButtonClicked:)];
    
    self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    self.titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.lineBreakMode = UILineBreakModeTailTruncation;
    self.titleView.shadowColor = [UIColor whiteColor];
    self.titleView.shadowOffset = CGSizeMake(0, -1);
    self.titleView.textAlignment = UITextAlignmentCenter;
    self.titleView.font = [UIFont LDBrushFontWithSize:55.0];
    self.titleView.textColor = [UIColor AJPurpleColor];
    self.navigationItem.titleView = self.titleView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateNavigationBarWithOrientation:toInterfaceOrientation];
    [self updateToolbarWithOrientation:toInterfaceOrientation];
}

#pragma mark - UI related

- (void)setTitleViewText:(NSString *)titleViewText {
    if (titleViewText != _titleViewText) {
        _titleViewText = titleViewText;
        
        self.titleView.text = _titleViewText;
    }
}

- (void)setTitleViewColor:(UIColor *)titleViewColor {
    if (titleViewColor != _titleViewColor) {
        _titleViewColor = titleViewColor;
        
        self.titleView.textColor = titleViewColor;
    }
}

#pragma mark - Actions

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
}

- (void)keyboardWillHide:(NSNotification *)aNotif {
    
}

- (void)removeKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - Privates

- (void)updateNavigationBarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-clear3.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-clear3-landscape.png"] forBarMetrics:UIBarMetricsDefault];
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
