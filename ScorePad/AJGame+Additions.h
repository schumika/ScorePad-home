//
//  AJGame+Additions.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGame.h"

typedef enum {
    AJPlayersSortingNone = 0,
    AJPlayersSortingByTotalASC,
    AJPlayersSortingByTotalDESC,
    AJPlayersSortingByNameASC,
    AJPlayersSortingByNameDESC
} AJPlayersSortingType;

@interface AJGame (Additions)

@property (nonatomic, assign, readonly) int maxNumberOfScores;

+ (AJGame *)createGameWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

- (NSDictionary *)toDictionary;
- (void)setPropertiesFromDictionary:(NSDictionary *)dictionary;

@end
