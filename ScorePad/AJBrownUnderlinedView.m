//
//  AJBrownUnderlinedView.m
//  ScorePad
//
//  Created by Anca Calugar on 1/24/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJBrownUnderlinedView.h"

@interface AJBrownUnderlinedView() {
    UIImageView *_backgroundImageView;
    UIImageView *_underlinedImageView;
}

- (UIImage *)underlinedImage;

@end


@implementation AJBrownUnderlinedView

@synthesize backgroundImage = _backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _underlinedImageView = [[UIImageView alloc] initWithImage:[self underlinedImage]];
        [self addSubview:_underlinedImageView];
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_backgroundImageView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self sendSubviewToBack:_backgroundImageView];
    [self bringSubviewToFront:_underlinedImageView];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _backgroundImageView.frame = self.bounds;
    CGFloat imageHeight = [self underlinedImage].size.height;
    _underlinedImageView.frame = CGRectMake(0.0, frame.size.height - imageHeight, frame.size.width, imageHeight);
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (backgroundImage != _backgroundImage) {
        _backgroundImage = backgroundImage;
        
        _backgroundImageView.image = _backgroundImage;
        
        [self setNeedsLayout];
    }
}

- (UIImage *)underlinedImage {
    static UIImage *image = nil;
    
    if (image == nil) {
        image = [UIImage imageNamed:@"separator_new2.png"];
    }
    
    return image;
}

@end
