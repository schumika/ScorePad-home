//
//  AJViewController.h
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJViewController : UIViewController

@property (nonatomic, strong) NSString      *titleViewText;
@property (nonatomic, strong) UIColor       *titleViewColor;

- (IBAction)backButtonClicked:(id)sender;

- (void)addKeyboardNotifications;
- (void)removeKeyboardNotifications;
- (void)keyboardWillShow:(NSNotification *)aNotif;
- (void)keyboardWillHide:(NSNotification *)aNotif;

@end
