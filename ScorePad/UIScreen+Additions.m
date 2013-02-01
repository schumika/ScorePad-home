//
//  UIScreen+Additions.m
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "UIScreen+Additions.h"

@implementation UIScreen (Additions)

+ (BOOL)isHighRes {
	static signed char i = 2;
	
	if (i == 2) {
		i = ([self mainScreen].scale == 2.0);
	}
	
	return i;
}

+ (BOOL)isTallScreen {
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
        ([[UIScreen mainScreen] bounds].size.height == 568)) {
        return YES;
    } else {
        return NO;
    }
}


@end
