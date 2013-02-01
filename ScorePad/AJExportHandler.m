//
//  AJExportHandler.m
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJExportHandler.h"

#import <QuartzCore/QuartzCore.h>

@implementation AJExportHandler

@synthesize game = _game;

- (id)initWithGame:(AJGame *)game {
    self = [super init];
    if (!self) return nil;
    
    self.game = game;
    
    return self;
}

- (void)dealloc {
    [_game release];
    
    [super dealloc];
}

- (UIImage *)createPlayersImage {
    CGRect imageBounds = [[UIScreen mainScreen] bounds];
     
    CGFloat calculatedHeight = self.game.players.count * 50.0 + 60.0;
    imageBounds.size.height = MIN(calculatedHeight, imageBounds.size.height - [UIImage imageNamed:@"nav-bar.png"].size.height - 20.0);
    
    UIGraphicsBeginImageContextWithOptions(imageBounds.size, NO, 0.0);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextDrawImage(contextRef, imageBounds, [UIImage imageNamed:@"background.png"].CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    return image;
}

@end
