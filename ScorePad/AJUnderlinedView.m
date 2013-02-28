//
//  AJUnderlinedView.m
//  ScorePad
//
//  Created by Anca Calugar on 11/20/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJUnderlinedView.h"

@implementation AJUnderlinedView

@synthesize underlineColor = _underlineColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (UIColor *)underlineColor {
    return _underlineColor;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    if (underlineColor != _underlineColor) {
        _underlineColor = underlineColor;
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, rect.origin.x, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.underlineColor.CGColor);
    
    CGContextStrokePath(context);
}

@end

