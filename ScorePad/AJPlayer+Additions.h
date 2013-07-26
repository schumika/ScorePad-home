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
    AJScoresSortingByRoundASC = 0,
    AJScoresSortingByRoundDESC,
} AJScoresSortingType;

@interface AJPlayer (Additions)

@property (nonatomic, assign, readonly) double totalScore;
@property (nonatomic, readonly) NSArray *scoreValues;
@property (nonatomic, readonly) NSArray *orderedScoresArray;

+ (AJPlayer *)createPlayerWithName:(NSString *)name forGame:(AJGame *)game;

- (NSDictionary *)toDictionary;
- (void)setPropertiesFromDictionary:(NSDictionary *)dictionary;

- (double)intermediateTotalAtRound:(int)row;
- (void)updateRoundsForScores;

@end
