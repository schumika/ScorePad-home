//
//  AJPlayer+Additions.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayer.h"
#import "AJDefines.h"

#import "AJGame+Additions.h"
#import "AJScore+Additions.h"


typedef enum {
    AJScoresSortingNone = 0,
    AJScoresSortingByRoundASC,
    AJScoresSortingByRoundDESC,
} AJScoresSortingType;

@interface AJPlayer (Additions)

+ (AJPlayer *)createPlayerWithName:(NSString *)name forGame:(AJGame *)game;
- (double)totalScore;
- (AJSettingsInfo *)settingsInfo;
- (NSArray *)scoreValues;

- (NSDictionary *)toDictionary;

@end
