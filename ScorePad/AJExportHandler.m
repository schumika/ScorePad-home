//
//  AJExportHandler.m
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJExportHandler.h"

#import <QuartzCore/QuartzCore.h>

#import "AJScoresManager.h"

#import "UIFont+Additions.h"
#import "UIImage+Additions.h"
#import "UIColor+Additions.h"

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
     
    CGFloat calculatedHeight = self.game.players.count * 50.0 + 70.0;
    imageBounds.size.height = MIN(calculatedHeight, imageBounds.size.height - [UIImage imageNamed:@"nav-bar.png"].size.height - 20.0);
    
    UIGraphicsBeginImageContextWithOptions(imageBounds.size, NO, 0.0);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextDrawImage(contextRef, imageBounds, [UIImage imageNamed:@"background.png"].CGImage);
    
    // preparing for writing text
    CGContextSetTextDrawingMode(contextRef, kCGTextFill);
    
    // write Game name
    NSString *gameName = self.game.name;
	CGContextSetFillColorWithColor(contextRef, [UIColor colorWithHexString:self.game.color].CGColor);
    CGFloat fontSize = 65.0;
	CGContextSelectFont(contextRef, "LDBrushStroke", fontSize, kCGEncodingMacRoman);
    CGContextSetFont(contextRef, CGFontCreateWithFontName((CFStringRef)[UIFont LDBrushFontWithSize:fontSize].fontName));
    CGSize nameStringSize = [gameName sizeWithFont:[UIFont LDBrushFontWithSize:fontSize]];
    CGRect nameStringRect = CGRectMake((imageBounds.size.width - nameStringSize.width)/2, 5.0, nameStringSize.width, 60.0);
    [gameName drawInRect:nameStringRect withFont:[UIFont LDBrushFontWithSize:fontSize]];
    
    // draw separator line
    [[UIImage imageNamed:@"separator_new2.png"] drawInRect:CGRectMake(0.0, 63.0, imageBounds.size.width, 2.0)];
    
    NSArray *players = [[AJScoresManager sharedInstance] getAllPlayersForGame:self.game];
    for (AJPlayer *player in players) {
        int playerIndex = [players indexOfObject:player];
        
        // draw player image
        UIImage *playerImage = nil;
        if (player.imageData == nil) {
            playerImage  = [[UIImage defaultPlayerPicture] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        } else {
            playerImage = [[UIImage imageWithData:player.imageData] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        }
        [[playerImage applyMask:[UIImage imageNamed:@"mask.png"]] drawInRect:CGRectMake(10.0, 65.0 + (playerIndex * 50.0) + 7.0, 35.0, 35.0)];
        
        
        NSString *playerName = player.name;
        // write player name
        CGContextSetFillColorWithColor(contextRef, [UIColor colorWithHexString:player.color].CGColor);
        CGFloat playerFontSize = 50.0;
        CGContextSelectFont(contextRef, "LDBrushStroke", playerFontSize, kCGEncodingMacRoman);
        CGContextSetFont(contextRef, CGFontCreateWithFontName((CFStringRef)[UIFont LDBrushFontWithSize:playerFontSize].fontName));
        CGSize nameStringSize = [playerName sizeWithFont:[UIFont LDBrushFontWithSize:playerFontSize]];
        CGRect nameStringRect = CGRectMake(60.0, 65.0 + playerIndex * 50.0, nameStringSize.width, 50.0);
        [playerName drawInRect:nameStringRect withFont:[UIFont LDBrushFontWithSize:playerFontSize]];
        
        NSString *playerScore = [NSString stringWithFormat:@"%g", [player totalScore]];
        // write player score
        CGContextSetFillColorWithColor(contextRef, [UIColor AJBrownColor].CGColor);
        CGFloat scoreFontSize = 65.0;
        CGContextSelectFont(contextRef, "LDBrushStroke", scoreFontSize, kCGEncodingMacRoman);
        CGContextSetFont(contextRef, CGFontCreateWithFontName((CFStringRef)[UIFont LDBrushFontWithSize:scoreFontSize].fontName));
        CGSize scoreStringSize = [playerScore sizeWithFont:[UIFont LDBrushFontWithSize:scoreFontSize]];
        CGRect scoreStringRect = CGRectMake(imageBounds.size.width - scoreStringSize.width - 10.0, 65.0 + playerIndex * 50.0, scoreStringSize.width, 50.0);
        [playerScore drawInRect:scoreStringRect withFont:[UIFont LDBrushFontWithSize:scoreFontSize]];
        
        // draw separator line
        [[playerImage applyMask:[UIImage imageNamed:@"mask.png"]] drawInRect:CGRectMake(0.0, 65.0 + (playerIndex * 50.0) + 48, imageBounds.size.width, 2.0)];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    return image;
}

@end
