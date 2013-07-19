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

@implementation UINavigationBar (UINavigationBarCustomDraw)

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"nav-bar-clear2.png"] drawInRect:rect];
}

@end


@interface AJViewController ()

@property (nonatomic, strong) UILabel *titleView;

@end


@implementation AJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-clear2.png"] forBarMetrics:UIBarMetricsDefault];
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

#pragma mark - UI related

- (void)setTitleViewText:(NSString *)titleViewText {
    if (titleViewText != _titleViewText) {
        _titleViewText = titleViewText;
        
        self.titleView.text = _titleViewText;
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

@end
