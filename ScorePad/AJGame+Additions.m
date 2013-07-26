//
//  AJGame+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"

#import "UIImage+Additions.h"

@implementation AJGame (Additions)

+ (AJGame *)createGameWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    AJGame *game = nil;
    
    game = [NSEntityDescription insertNewObjectForEntityForName:@"AJGame" inManagedObjectContext:context];
    game.name = name;
    game.rowId = @(0);
    game.sortOrder = @(AJPlayersSortingNone);
    
    CLSNSLog(@"a game was created with name %@", name);
    
    return game;
}

#pragma mark - Pbublic properties

- (int)maxNumberOfScores; {
    int maxNumber = 0;
    
    for (AJPlayer *player in self.players) {
        maxNumber = MAX(maxNumber, [player.scores count]);
    }
    
    return maxNumber;
}

- (NSArray *)orderedPlayersArray {
    NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:[self.players allObjects]];
    
    int playersSortingType = self.sortOrder.intValue;
    if (playersSortingType == AJPlayersSortingNone) return orderedArray;
    
    BOOL isSortingByTotal = (playersSortingType == AJPlayersSortingByTotalASC || playersSortingType == AJPlayersSortingByTotalDESC);
    BOOL isSortingASC = (playersSortingType == AJPlayersSortingByTotalASC || playersSortingType == AJPlayersSortingByNameASC);
    
    [orderedArray sortUsingComparator:^NSComparisonResult(AJPlayer *player1, AJPlayer *player2) {
        if (isSortingByTotal) {
            if (player1.totalScore < player2.totalScore) {
                return isSortingASC ? NSOrderedAscending : NSOrderedDescending;
            } else {
                return isSortingASC ? NSOrderedDescending : NSOrderedAscending;
            }
        } else {
            if ([player1.name compare:player2.name] == NSOrderedAscending) {
                return isSortingASC ? NSOrderedAscending : NSOrderedDescending;
            } else {
                return isSortingASC ? NSOrderedDescending : NSOrderedAscending;
            }
        }
    }];
    
    return orderedArray;
}

#pragma mark - Public methods

- (NSDictionary *)toDictionary {
    NSMutableDictionary *displayDictionary = [NSMutableDictionary dictionary];
    
    displayDictionary[kAJNameKey] = self.name;
    displayDictionary[kAJColorStringKey] = self.color;
    
    NSData *data = self.imageData;
    if (!data) {
        data = UIImagePNGRepresentation([UIImage defaultGamePicture]);
    }
    displayDictionary[kAJPictureDataKey] = data;
    
    displayDictionary[kAJRowIdKey] = self.rowId;
    displayDictionary[kAJGameNumberOfPlayersKey] = @([self.players count]);
    
    return displayDictionary;
}

- (void)setPropertiesFromDictionary:(NSDictionary *)dictionary {
    self.name = dictionary[kAJNameKey];
    self.color = dictionary[kAJColorStringKey];
    self.imageData = dictionary[kAJPictureDataKey];
}

@end
