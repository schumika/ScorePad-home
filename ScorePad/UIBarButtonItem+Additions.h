//
//  UIBarButtonItem+Additions.h
//  ScoreTracker
//
//  Created by Anca Julean on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface UIBarButtonItem (Additions)

+ (UIBarButtonItem *)simpleBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)simpleBackButtonItemWithTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)clearBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backButtonItemWithTarget:(id)target action:(SEL)action;

@end
