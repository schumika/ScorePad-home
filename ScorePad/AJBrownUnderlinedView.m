//
//  AJBrownUnderlinedView.m
//  ScorePad
//
//  Created by Anca Calugar on 1/24/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJBrownUnderlinedView.h"

@interface AJBrownUnderlinedView() {
    UIImageView *_underlinedImageView;
}

- (UIImage *)underlinedImage;

@end


@implementation AJBrownUnderlinedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _underlinedImageView = [[UIImageView alloc] initWithImage:[self underlinedImage]];
        [self addSubview:_underlinedImageView];
        [_underlinedImageView release];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat imageHeight = [self underlinedImage].size.height;
    _underlinedImageView.frame = CGRectMake(0.0, frame.size.height - imageHeight, frame.size.width, imageHeight);
}

- (UIImage *)underlinedImage {
    static UIImage *image = nil;
    
    if (image == nil) {
        image = [UIImage imageNamed:@"separator_new2.png"];
    }
    
    return image;
}

@end
