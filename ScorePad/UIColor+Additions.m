//
//  UIColor+Additions.m
//  ScoreBoardModel
//
//  Created by Anca Julean on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor*)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;  
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor*)colorWithHexString:(NSString *)color {
    NSScanner *scanner = [NSScanner scannerWithString:color];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

- (NSString*)toHexString:(BOOL)ignoreAlpha {
	CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
	if (model == kCGColorSpaceModelMonochrome || model == kCGColorSpaceModelRGB) {
		const CGFloat *components = CGColorGetComponents(self.CGColor);
		if (model == kCGColorSpaceModelMonochrome) {
			CGFloat w = components[0], a = components[1];
			
			if (ignoreAlpha) {
				return [NSString stringWithFormat:@"%02X%02X%02X", (int)(w * 255), (int)(w * 255), (int)(w * 255)];
			} else {
				return [NSString stringWithFormat:@"%02X%02X%02X%02X", (int)(w * 255), (int)(w * 255), (int)(w * 255), (int)(a * 255)];
			}
		} else if (model == kCGColorSpaceModelRGB) {
			CGFloat r = components[0]; CGFloat g = components[1];
			CGFloat b = components[2]; CGFloat a = components[3];
			
			if (ignoreAlpha) {
				return [NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
			} else {
				return [NSString stringWithFormat:@"%02X%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255), (int)(a * 255)];
			}
		}
	}
	
	return nil;
}

@end
