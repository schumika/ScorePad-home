//
//  UIImage+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)staticImageNamed:(NSString *)imageName {
    static UIImage *i = nil;
	if (i == nil) {
		i = [[UIImage imageNamed:imageName] retain];
	}
	return i;
}

+ (UIImage *)defaultGamePicture {
    return [UIImage imageNamed:@"cards_icon.png"];
}

+ (UIImage *)defaultPlayerPicture {
    return [UIImage imageNamed:@"main_tile_default_pic.png"];
}

+ (UIImage *)separatorImage {
    return [UIImage imageNamed:@"separator.png"];
}

+ (UIImage *)roundTextFieldImage {
    return [[UIImage imageNamed:@"round.png"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:10.0];
}

- (UIImage*)resizeToNewSize:(CGSize)newSize {
	if (self.size.height == 0 || self.size.width == 0) {
		return [[self retain] autorelease];
	}
	
	CGSize constrainedSize = newSize;
	
	UIGraphicsBeginImageContextWithOptions(constrainedSize, NO, 0.0);
	
	[self drawInRect:CGRectMake(0,0, constrainedSize.width, constrainedSize.height)];
	UIImage *retimage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return retimage;
}

- (UIImage*)applyMask:(UIImage*)mask {
	CGSize masksize = mask.size, imagesize = self.size;
	
	UIGraphicsBeginImageContextWithOptions(masksize, NO, 0.0);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextConcatCTM(ctx, CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0, -1.0), 0.0, -masksize.height));
	CGContextClipToMask(ctx, CGRectMake(0.0, 0.0, masksize.width, masksize.height), mask.CGImage);
	
	// Center the image into the mask rect.
	CGContextDrawImage(ctx, CGRectMake(ceil((masksize.width - imagesize.width) / 2.0), ceil((masksize.height - imagesize.height) / 2.0),
									   imagesize.width, imagesize.height), self.CGImage);
	
	UIImage *retimage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return retimage;
}

@end
