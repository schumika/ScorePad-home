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

@property (nonatomic, readonly) UILabel *titleView;

@end


@implementation AJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleView;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-clear2.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem simpleBackButtonItemWithTarget:self action:@selector(backButtonClicked:)];
}

#pragma mark - UI related

- (void)setTitleViewText:(NSString *)titleViewText {
    if (titleViewText != _titleViewText) {
        _titleViewText = titleViewText;
        
        self.titleView.text = _titleViewText;
    }
}

- (UILabel *)titleView {
    static UILabel *view = nil;
    
    if (view == nil) {
        view = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        view.backgroundColor = [UIColor clearColor];
        view.lineBreakMode = UILineBreakModeTailTruncation;
        view.shadowColor = [UIColor whiteColor];
        view.shadowOffset = CGSizeMake(0, -1);
        view.textAlignment = UITextAlignmentCenter;
        view.font = [UIFont LDBrushFontWithSize:55.0];
        view.textColor = [UIColor AJPurpleColor];
        view.text = [self titleViewText];
    }
    
    return view;
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
