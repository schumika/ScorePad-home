//
//  UIView+Additions.m
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "UIView+Additions.h"

#import <QuartzCore/QuartzCore.h>


@implementation UIView (Additions)

- (UIImage*)getImage {
	BOOL isHidden = self.hidden;
	if (isHidden) {
		self.hidden = NO;
	}
	
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
	
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	if (isHidden) {
		self.hidden = YES;
	}
	
	return image;
}

@end
