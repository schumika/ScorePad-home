//
//  AJPlayer+Additions.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayer.h"
#import "AJGame+Additions.h"
#import "AJScore+Additions.h"

@interface AJPlayer (Additions)

+ (AJPlayer *)createPlayerWithName:(NSString *)name forGame:(AJGame *)game;
- (double)totalScore;
- (AJSettingsInfo *)settingsInfo;
- (NSArray *)scoreValues;

@end
