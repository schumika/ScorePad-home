//
//  UIBarButtonItem+Additions.m
//  ScoreTracker
//
//  Created by Anca Julean on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBarButtonItem+Additions.h"

@implementation UIBarButtonItem (Additions)

+ (UIBarButtonItem *)clearBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    UIBarButtonItem *barButtonItem = nil;
    
    UIImage *buttonImage = [[UIImage imageNamed:@"bar-button.png"] stretchableImageWithLeftCapWidth:7.0 topCapHeight:15.0];
    
    UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:17.0]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize buttonSize = [title sizeWithFont:button.titleLabel.font];
    CGFloat marginSpace = 20.0f;
    button.frame = CGRectMake(0, 0, buttonSize.width + marginSpace, 30);
    
    barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)backButtonItemWithTarget:(id)target action:(SEL)action {
    
    UIBarButtonItem *barButtonItem = nil;
    
    UIImage *backImage = [[UIImage imageNamed:@"back-button"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
    
    UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0)];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:17.0]];
    CGSize buttonSize = [@"Back" sizeWithFont:button.titleLabel.font];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGFloat marginSpace = 20.0f;
    button.frame = CGRectMake(0, 0, buttonSize.width + marginSpace, 30);
    
    barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    return barButtonItem;
}

@end
