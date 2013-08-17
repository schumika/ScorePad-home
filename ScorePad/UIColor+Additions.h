//
//  UIColor+Additions.h
//  ScoreBoardModel
//
//  Created by Anca Julean on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor*)colorWithRGBHex:(UInt32)hex;
+ (UIColor*)colorWithHexString:(NSString *)color;
- (NSString*)toHexString:(BOOL)ignoreAlpha;

// custom colors
+ (UIColor *)AJBlueColor;
+ (UIColor *)AJBrownColor;
+ (UIColor *)AJGreenColor;
+ (UIColor *)AJOrangeColor;
+ (UIColor *)AJPinkColor;
+ (UIColor *)AJPurpleColor;
+ (UIColor *)AJRedColor;
+ (UIColor *)AJYellowColor;
+ (UIColor *)AJLightBlueColor;
+ (UIColor *)AJLightGreenColor;
+ (UIColor *)AJVioletColor;
+ (UIColor *)AJBrightOrangeColor;
+ (UIColor *)AJBrightPinkColor;
+ (UIColor *)AJDarkBlueColor;

@end
