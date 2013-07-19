//
//  UIBarButtonItem+Additions.m
//  ScoreTracker
//
//  Created by Anca Julean on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBarButtonItem+Additions.h"
#import "UIFont+Additions.h"
#import "UIColor+Additions.h"

@implementation UIBarButtonItem (Additions)

+ (UIBarButtonItem *)clearBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    UIBarButtonItem *barButtonItem = nil;
    
    UIImage *buttonImage = [[UIImage imageNamed:@"bar-button.png"] stretchableImageWithLeftCapWidth:7.0 topCapHeight:15.0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor AJBrownColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor AJBrownColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont LDBrushFontWithSize:35.0];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:17.0]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize buttonSize = [title sizeWithFont:button.titleLabel.font];
    CGFloat marginSpace = 20.0f;
    button.frame = CGRectMake(0, 0, buttonSize.width + marginSpace, 30);
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)backButtonItemWithTarget:(id)target action:(SEL)action {
    
    UIBarButtonItem *barButtonItem = nil;
    
    UIImage *backImage = [[UIImage imageNamed:@"back-button"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)simpleBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    UIBarButtonItem *barButtonItem = nil;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor AJGreenColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont LDBrushFontWithSize:35.0];
    //[button.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:17.0]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button.titleLabel setShadowColor:[UIColor whiteColor]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize buttonSize = [title sizeWithFont:button.titleLabel.font];
    button.frame = CGRectMake(0, 0, buttonSize.width, 30);
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)simpleBackButtonItemWithTarget:(id)target action:(SEL)action {
    
    UIBarButtonItem *barButtonItem = nil;
    
    UIImage *backImage = [UIImage imageNamed:@"back"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize buttonSize = backImage.size;
    button.frame = (CGRect){CGPointZero, buttonSize};
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

@end
