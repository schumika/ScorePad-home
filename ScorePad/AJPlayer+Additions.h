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

@property (nonatomic, assign, readonly) double totalScore;
@property (nonatomic, readonly) NSArray *scoreValues;

+ (AJPlayer *)createPlayerWithName:(NSString *)name forGame:(AJGame *)game;

- (NSDictionary *)toDictionary;
- (void)setPropertiesFromDictionary:(NSDictionary *)dictionary;

@end
